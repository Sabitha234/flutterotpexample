import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:otpexample/Model/user_model.dart';
import 'package:otpexample/Screens/otp_screen.dart';
import 'package:otpexample/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthProvider extends ChangeNotifier {
  bool _isSignedin = false;

  bool get isSignedIn => _isSignedin;
  bool _isLoading = false;

  bool get isLoding => _isLoading;
  String? _uid;
  String get uid=>_uid!;
  UserModel? _usermodel;
  UserModel get usermodel=>_usermodel!;
  final FirebaseAuth firebaseAuth=FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFireStore=FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage=FirebaseStorage.instance;
  AuthProvider() {
    checkSignedIn();
  }

  void checkSignedIn() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    //if key exist=>true else=>false
    _isSignedin = s.getBool("is_signedin")?? false ;
    notifyListeners();
  }
  Future setSignin()async{
    SharedPreferences s=await SharedPreferences.getInstance();
    await s.setBool("is_signedin", true);
    _isSignedin=true;
    notifyListeners();
  }
  void signinWithPhone(BuildContext context,String phonenumber)async{
    try{
      await firebaseAuth.verifyPhoneNumber(
        phoneNumber: phonenumber,
          verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async{
             await firebaseAuth.signInWithCredential(phoneAuthCredential);
      }
    ,verificationFailed: (error){
            throw Exception(error.message);
      },
    codeSent: (verificationid,forceResendingToken){
       Navigator.push(context, MaterialPageRoute(
           builder:(context)=>OtpScreen(verificationid: verificationid)));
    },
    codeAutoRetrievalTimeout: (verificationId){});
    } on FirebaseAuthException catch(e){
      showSnackBar(context, phonenumber.toString());
    }
  }

  void verifyOtp({required BuildContext context,
    required String verificationId,
    required String otp,
  required Function onSuccess})async{
      _isLoading=true;
      notifyListeners();
      try{
        PhoneAuthCredential credential=PhoneAuthProvider.credential(
            verificationId: verificationId,
            smsCode: otp);
        User? user=(await firebaseAuth.signInWithCredential(credential)).user!;
        await firebaseAuth.signInWithCredential(credential);
        if(user!=null){
          _uid=user.uid;
          onSuccess();
        }
        _isLoading=false;
      } on FirebaseAuthException catch(e){
        showSnackBar(context, e.message.toString());
        _isLoading=false;
        }
  }

  //database function
  Future<bool> checkExistingUser() async{
    DocumentSnapshot snapshot=await _firebaseFireStore.
    collection("users").doc(_uid).get();
    if(snapshot.exists){
      print("user exist");
      return true;
    }
    else{
      print("New user");
      return false;
    }
  }
  void storeDataToFireStore({
    required BuildContext context,
    required UserModel usermodel,
    required File profile,
    required Function onsuccess})async{
     _isLoading=true;
     notifyListeners();
     try {
         //upload image to firebase
       await storeFileToStorage("profile/$_uid",profile).then((value){
         usermodel.profile_pic!=value;
         usermodel.createdAt!=DateTime.now().millisecondsSinceEpoch.toString();
         usermodel.phno!=firebaseAuth.currentUser?.phoneNumber;
         usermodel.uid!=firebaseAuth.currentUser?.uid;
         _usermodel=usermodel;
         notifyListeners();
       });
       //upload to db
       await _firebaseFireStore.collection("users").doc(_uid).set(usermodel.toMap()).then((value) {
         onsuccess();
         _isLoading=false;
         notifyListeners();

       });
     } on FirebaseAuthException catch(e){
       showSnackBar(context, e.message.toString());
       _isLoading=false;
       notifyListeners();
     }
  }
  Future<String> storeFileToStorage(String ref,File file)async{
   UploadTask uploadTask=_firebaseStorage.ref().child(ref).putFile(file);
   TaskSnapshot snapshot=await uploadTask;
   String downloadurl=await snapshot.ref.getDownloadURL();
   return downloadurl;
  }

  //storing data locally
Future saveUserDataToSpref()async{
    SharedPreferences s=await SharedPreferences.getInstance();
    await s.setString("user_model", jsonEncode(usermodel.toMap()));
}
Future getDataFromSpref()async{
SharedPreferences s=await SharedPreferences.getInstance();
String data=s.getString("user_model")??'';
_usermodel=UserModel.fromMap(jsonDecode(data));
_uid=_usermodel!.uid;
notifyListeners();
}
}
