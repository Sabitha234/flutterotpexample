import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:otpexample/Provider/auth_provider.dart';
import 'package:otpexample/Screens/register_screen.dart';
import 'package:otpexample/Widgets/custom_button.dart';
import 'package:provider/provider.dart';

import 'home_screen.dart';
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    final ap=Provider.of<AuthProvider>(context,listen:false);
    return Scaffold(
      body:SafeArea(
          child:Column(
            children: [
              SizedBox(height: 50,),
              Padding(
                padding: const EdgeInsets.only(left: 20,right: 20),
                child: Image.asset('img/1.png',width: 300,height: 300,),),
              Text("Lets Get Started",style: TextStyle(fontSize: 22,
                  fontWeight: FontWeight.bold),),
              SizedBox(height: 10,),
              Text("Never a better time than now to start",style: TextStyle(fontSize: 15),),
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(width:double.infinity ,
                  height: 50,
                  child: CustomButton(text: "Get Started", onpressed:()async{
                    if(ap.isSignedIn==true){
                      await ap.getDataFromSpref().whenComplete(() => Navigator.push(context,
                          MaterialPageRoute(builder: (context)=>Home())));
                  }
                    else{
                    Navigator.push(context,MaterialPageRoute(builder: (context)=>RegisterScreen()));
                    }

                  }),),
              ),
            ],
          ),
      )
    );
  }

}
