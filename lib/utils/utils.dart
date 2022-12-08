import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

//picking image from gallery
pickImage(ImageSource source) async{
  //creating istance of imagepicker class
  final ImagePicker _imagePicker=ImagePicker();
  XFile? _file=await _imagePicker.pickImage(source: source);
  if(_file!=null){
    return _file.readAsBytes();
  }
  print("No image selected");

}

//snackBar
showSnackBar(String content,BuildContext context){
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content,),
    ),
  );
}