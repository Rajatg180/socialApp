import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageMethod{
  final FirebaseAuth _auth= FirebaseAuth.instance;
  final FirebaseStorage _storage=FirebaseStorage.instance;

  //adding image to firebase storage 
  Future<String> uploadImageToStorage(String childName,Uint8List file,bool isPost)async{

    Reference ref=_storage.ref().child(childName).child(_auth.currentUser!.uid);

    if(isPost){
      String id=const Uuid().v1();
      ref=ref.child(id);
    }

    UploadTask uploadTask=ref.putData(file);


    TaskSnapshot snap=await uploadTask;
    
    //getting download url of the ecurrent uploaded file
    String downloadUrl=await snap.ref.getDownloadURL();
    print("Uploading done!!");
    return downloadUrl;
  }

}