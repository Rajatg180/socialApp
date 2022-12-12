
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class Users{
  final String email;
  final String uid;
  final String photoUrl;
  final String username;
  final String bio;
  final List followers;
  final List following;

  const Users({
    required this.email,
    required this.uid,
    required this.photoUrl,
    required this.username,
    required this.bio,
    required this.followers,
    required this.following,
  });

  //converting all the argunment in object file
  Map<String,dynamic> tojson(){
    return{
    'username':username,
    'uid':uid,
    'email': email,
    'photoUrl': photoUrl,
    'bio':bio,
    'followers':followers,
    'following':following,
  };
  }

  //getting DocumentSnapshaot and returning User Model
  static Users fromSnap(DocumentSnapshot snap){
    var snapshot=snap.data() as Map<String,dynamic>;
    return Users(
      username: snapshot['username'],
      uid: snapshot['uid'],
      email: snapshot['email'],
      photoUrl: snapshot['photoUrl'],
      bio: snapshot['bio'],
      following: snapshot['following'],
      followers: snapshot['followers'],
    );
  }
}