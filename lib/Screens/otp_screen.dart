import 'package:flutter/material.dart';
import 'package:otpexample/Provider/auth_provider.dart';
import 'package:otpexample/Screens/user_info.dart';
import 'package:otpexample/Widgets/custom_button.dart';
import 'package:otpexample/utils/utils.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
class OtpScreen extends StatefulWidget {
  final String verificationid;
  const OtpScreen({super.key,required this.verificationid});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String ?otpcode;
  @override
  Widget build(BuildContext context) {
    final isLoading=Provider.of<AuthProvider>(context,listen:true).isLoding;
    return Scaffold(
        body: SafeArea(
            child:isLoading==true?
            const Center(child:
            CircularProgressIndicator(color: Colors.purple,),)
            :Padding(
                padding: const EdgeInsets.all(10.0),
                child: SingleChildScrollView(
                    child: Column(
                        children: [
                          Center(
                              child: Container(
                                child: Image.asset("img/1.png",width: 200,height: 200,),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.purple.shade50
                                ),
                              )
                          ),
                          SizedBox(height: 20,),
                          Text("Verification",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                          Text("Enter the OTP sent to your phone number",
                            style: TextStyle(fontSize: 15),
                          ),
                          SizedBox(height: 20,),

            Pinput(
              length: 6,
              showCursor: true,
              defaultPinTheme: PinTheme(
                width: 60,
                height: 60,
                decoration:BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.purple.shade200),
              ),
                textStyle: TextStyle(fontSize: 20,fontWeight: FontWeight.w600)
              ),
              onCompleted: (value){
                setState(() {
                  otpcode=value;
                });
              },
            ),
                          SizedBox(height: 20,),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: CustomButton(text: "Verify",
                  onpressed:(){
                if(otpcode!=null){
                  verifyOtp(context,otpcode!);
                }
                else{
                  showSnackBar(context, "Enter 6 digit code");
                }
                  }),
            )
                        ]
                    )
                )
            )
        )
    );
  }
  void verifyOtp(BuildContext context,String otp){
    final ap=Provider.of<AuthProvider>(context,listen:false);
    ap.verifyOtp(context: context, verificationId: widget.verificationid, otp: otp, onSuccess: (){
      ap.checkExistingUser().then((value) async{
        if(value==true){
          //user exist
        }
        else{
          //new user
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>UserInfoScreen()), (route) => false);
        }
      });
    });
  }
}
