import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagramclone/Resorces/auth_methods.dart';
import 'package:provider/provider.dart';

import '../Models/users.dart';

class UserProvider with ChangeNotifier{
  late Users _user;
  //creating instance of AuthMethod class
  AuthMethod _authMethod=AuthMethod();

  //createing getUser method which will return _user!
  Users get getUser => _user;

  Future<void> refreshUser() async{
    Users user=await _authMethod.getUserDetails();
    _user=user;
    notifyListeners();
  }
  

}