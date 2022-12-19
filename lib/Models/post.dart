
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class Post{
  final String description;
  final String uid;
  final String username;
  final String postId;
  final  datePublished;
  final String postUrl;
  final String profImage;
  final likes;

  const Post({
    required this.description,
    required this.uid,
    required this.username,
    required this.postId,
    required this.datePublished,
    required this.postUrl,
    required this.profImage,
    required this.likes
  });

  //converting all the argunment in object file
  Map<String,dynamic> tojson(){
    return{
    'description':description,
    'uid':uid,
    'username':username,
    'postId': postId,
    'datePublished': datePublished,
    'postUrl':postUrl,
    'profImage':profImage,
    'likes':likes,
  };
  }

  //getting DocumentSnapshaot and returning User Model
  static Post fromSnap(DocumentSnapshot snap){
    var snapshot=snap.data() as Map<String,dynamic>;
    return Post(
      description: snapshot['description'],
      uid: snapshot['uid'],
      username: snapshot['username'],
      postId: snapshot['postId'],
      datePublished: snapshot['datePublished'],
      postUrl: snapshot['postUrl'],
      profImage: snapshot['profImage'],
      likes: snapshot['likes']
    );
  }
}