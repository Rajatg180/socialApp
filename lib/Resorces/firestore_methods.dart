import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagramclone/Resorces/auth_methods.dart';
import 'package:instagramclone/Resorces/storage_method.dart';
import 'package:intl/date_symbols.dart';
import 'package:uuid/uuid.dart';
import '../Models/post.dart';

class FirestoreMethod{

  final FirebaseFirestore _firestore=FirebaseFirestore.instance;

  Future<String> uploadImage(
    String description,
    Uint8List file,
    String uid,
    String username,
    String profImage,
  )async{
    String res="some error occured";
    try{
      print("Uploading post.....");
      String photoUrl=await StorageMethod().uploadImageToStorage('posts', file, true);
      print("Done uploading....");
      //create a unique post id using  uuid package in flutter
      String postId=const Uuid().v1();

      Post post=Post(
        description: description,
        uid: uid,
        username: username,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
        likes: [],
      );
      
      print("Storing data to Firestore.....");
      //storing to fireStore
      _firestore.collection('posts').doc(postId).set(post.tojson());
      print("Storing data to Firestore done.....");

      res="success";


    }catch(err){
      res=err.toString();
    }
    return res;
  }
  
  Future<void> likePost(String postId,String uid,List likes)async{
    try{
      //disliking the post 
      if(likes.contains(uid)){
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      }
      //adding uid to array list
      else{
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
          // 'description': "maza pillu maza gondas balllll",
        });

      }
    }
    catch(e){
      print(e.toString());
    }
  }
   
   Future<void> postComment(String postId,String text,String uid,String name,String profilePic)async{
     try{
      if(text.isNotEmpty){
         String commentId=const Uuid().v1();
         await _firestore.collection('posts').doc(postId).collection('comments').doc(commentId).set({
            'profilePic':profilePic,
            'name':name,
            'uid':uid,
            'text':text,
            'commentId':commentId,
            'datePublished':DateTime.now()
         });
      }else{
        print("Text is Empty");
      }
     }
     catch(e){
       print(e.toString());
     }
   }


   //Deleting post 
   Future<void> deletePost(String postId)async{
     try{
      await _firestore.collection('posts').doc(postId).delete();
     }
     catch(e){
       print(e.toString());
     }
   }

   // following / followers logic

   Future<void>  followUser(String uid,String followId)async{
     
     try{
        DocumentSnapshot snap= await _firestore.collection('users').doc(uid).get();
        List following=(snap.data()! as dynamic)['following'];
        if(following.contains(followId)){
          await _firestore.collection('users').doc(followId).update({
            'followers':FieldValue.arrayRemove([uid])
          });
          await _firestore.collection('users').doc(uid).update({
            'followers':FieldValue.arrayRemove([followId])
          });
        }
        else{
          await _firestore.collection('users').doc(followId).update({
            'followers':FieldValue.arrayUnion([uid])
          });
          await _firestore.collection('users').doc(uid).update({
            'followers':FieldValue.arrayUnion([followId])
          });

        }
     }catch(e){
       print(e.toString());
     }
   }

   //signout user

   Future<void> signout()async{
     await FirebaseAuth.instance.signOut();
   }



}