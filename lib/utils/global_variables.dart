// ignore_for_file: unnecessary_const

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagramclone/Screens/add_post_screen.dart';
import 'package:instagramclone/Screens/feed_screen.dart';
import 'package:instagramclone/Screens/profile_screen.dart';
import 'package:instagramclone/Screens/search_screen.dart';

const webScreenSize=600;

List<Widget> homeScreenItems=[
          const FeedScreen(),
          const SearchScreen(),
          const AddPostScreen(),
          const Center(
           child: Text("notification"),
          ),
          ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid),
        ];