import 'dart:io';

import 'package:flutter/material.dart';
import 'package:otpexample/Provider/auth_provider.dart';
import 'package:otpexample/Screens/home_screen.dart';
import 'package:otpexample/Widgets/custom_button.dart';
import 'package:otpexample/utils/utils.dart';
import 'package:provider/provider.dart';

import '../Model/user_model.dart';
class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  File? image;
  final name_controller=TextEditingController();
  final email_controller=TextEditingController();
  final bio_controller=TextEditingController();
  @override

  void dispose(){
    super.dispose();
    name_controller.dispose();
    email_controller.dispose();
    bio_controller.dispose();
  }

  void selectImage()async{
     image=await pickImage(context);
     setState(() {

     });
  }


  Widget build(BuildContext context) {
    final isLoading=Provider.of<AuthProvider>(context,listen:true).isLoding;
    return Scaffold(
      body: SafeArea(
        child:isLoading==true?
        const Center(child:
        CircularProgressIndicator(color: Colors.purple,),)
            : SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                SizedBox(height: 20,),
                InkWell(
                  onTap: ()=>selectImage(),
                  child:image==null?
                      const CircleAvatar(backgroundColor:Colors.purple ,
                      radius: 50,
                        child: Icon(Icons.account_circle),
                      ):
                      CircleAvatar(
                        backgroundImage: FileImage(image!),
                        radius: 50,
                      )
                ),
                SizedBox(height: 20,),
                Container(
                  child: TextFormField(
                    controller: name_controller,
                    decoration: InputDecoration(
                      icon: Icon(Icons.account_box),
                        iconColor: Colors.purple,
                      hintText: "Enter your name",
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4))
                  ),
                  )
                ),
                SizedBox(height: 20,),
                Container(
                  child: TextFormField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.email_outlined),
                        iconColor: Colors.purple,
                        hintText: "Enter your mailid",
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4))
                    ),
                    controller: email_controller,

                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  child: TextFormField(
                    controller: bio_controller,
                    decoration: InputDecoration(
                      icon: Icon(Icons.mode_edit_outline),
                        iconColor: Colors.purple,
                        hintText: "Enter your bio",
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4))
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                CustomButton(text: "Continue", onpressed: ()=>storeData())
              ],
            ),
          ),
        ),
      ),
    );
  }
  //store data
void storeData() async{
    final ap=Provider.of<AuthProvider>(context,listen: false);
    UserModel userModel=UserModel(
        name: name_controller.text.trim(),
        email: email_controller.text.trim(),
        bio: bio_controller.text.trim(),
        profile_pic:"",
        phno: "",
        createdAt: "",
        uid: "");
    if(image!=null){
       ap.storeDataToFireStore(
           context: context,
         usermodel: userModel,
         profile:image!,
         onsuccess: (){
             //once data is saved we need to store it locally
           ap.saveUserDataToSpref().then((value) =>
              ap.setSignin().then((value) =>
              Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (context)=>Home()) ,
                      (route) => false)
              )
           );
         },


       );
    }
    else{
      showSnackBar(context, "Please upload your profile pic");
    }
}
}
