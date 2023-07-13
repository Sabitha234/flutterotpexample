import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:otpexample/Provider/auth_provider.dart';
import 'package:otpexample/Widgets/custom_button.dart';
import 'package:provider/provider.dart';
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController phno=TextEditingController();
  Country selected_country=Country(phoneCode: "91",
      countryCode: "IN",
      e164Sc:0,
      geographic: true,
      level: 1,
      name: "India",
      example: "India",
      displayName: "India",
      displayNameNoCountryCode: "IN",
      e164Key: "");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: SafeArea(
         child: Padding(
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
                  Text("Register",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                  Text("Enter your phone number we will",
                      style: TextStyle(fontSize: 15),
                  ),
                  Text("send you a code"),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      onChanged: (value){
                        setState(() {
                          phno.text=value;
                        });
                      },
                      cursorColor: Colors.purple,
                      controller: phno,
                      decoration: InputDecoration(
                        hintText: "Enter your Phone Number",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.black12)
                        ),
                         focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.black12)
                              ),
                        prefixIcon: Container(
                          padding: EdgeInsets.all(10),
                          child: InkWell(
                            onTap: (){
                              showCountryPicker(countryListTheme: CountryListThemeData(
                                bottomSheetHeight: 500
                              ),context: context, onSelect: (value){
                                setState(() {
                                  selected_country=value;
                                });
                              });
                            },
                            child: Text("${selected_country.flagEmoji}+${selected_country.phoneCode}",
                              style: TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.bold),),
                          ),
                        ),
                     suffixIcon: phno.text.length>9?Container(
                       child: Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: Container(
                           decoration: BoxDecoration(
                             shape: BoxShape.circle,
                             color: Colors.green
                           ),
                           child: Icon(Icons.done,color: Colors.white,),
                         ),
                       ),
                    ):null,
                  )
                    )
                  ),
                  SizedBox(width: double.infinity,height: 50,
                    child: CustomButton(text: "Login", onpressed:(){
                    sendPhno();
                  }),)
                ],
              ),
            ),
          ),
       ),
      
    );
  }
  void sendPhno(){
    final ap=Provider.of<AuthProvider>(context, listen: false);
    String phoneno=phno.text.trim();
    ap.signinWithPhone(context, "+${selected_country.phoneCode}$phoneno");
  }
}
