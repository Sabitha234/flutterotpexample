import 'package:flutter/material.dart';
import 'package:otpexample/Model/user_model.dart';
import 'package:otpexample/Provider/auth_provider.dart';
import 'package:otpexample/Screens/register_screen.dart';
import 'package:provider/provider.dart';
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final ap=Provider.of<AuthProvider>(context,listen:true);
    return Scaffold(
      appBar: AppBar(title: Text("Phone Auth",),backgroundColor: Colors.purple,),
      body:Center(child: Text(ap.usermodel.name),),
        floatingActionButton: FloatingActionButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterScreen()));
        },child: Icon(Icons.remove),backgroundColor: Colors.purple,),
    );
  }
}
