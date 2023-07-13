import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void showSnackBar(BuildContext context,String content){
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(content))
  );
}
Future<File?> pickImage(BuildContext context)async{
  File? image;
  try{
    final pickImage=await ImagePicker().pickImage(
        source: ImageSource.gallery);
    if(pickImage!=null){
      image=File(pickImage.path);
    }
  }
  catch(e){
    showSnackBar(context, e.toString());
  }
  return image;
}