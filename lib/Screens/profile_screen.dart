
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagramclone/Resorces/firestore_methods.dart';
import 'package:instagramclone/Screens/login_screen.dart';
import 'package:instagramclone/Widgets/follow_button.dart';
import 'package:instagramclone/utils/colors.dart';
import 'package:instagramclone/utils/utils.dart';

class ProfileScreen extends StatefulWidget {
  final uid;
  const ProfileScreen({Key? key, required this.uid}) :super(key:key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  
  var userData={};
  int postLen=0;
  int followers=0;
  int following=0;
  bool isFollowing=false;
  bool isLoading=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userDetails();
  }

  userDetails() async{
    setState(() {
      isLoading=true;
    });
    try{
      var userSnap= await FirebaseFirestore.instance.collection('users').doc(widget.uid).get();

      //get post length
      var postSnap=await FirebaseFirestore.instance.collection('posts').where('uid',isEqualTo: widget.uid).get();
      postLen=postSnap.docs.length;
      followers=userSnap.data()!['followers'].length;
      following=userSnap.data()!['following'].length;
      isFollowing=userSnap.data()!['following'].contains(FirebaseAuth.instance.currentUser!.uid);
      userData=userSnap.data()!;
      setState(() {});
      
    }catch(e){
      showSnackBar(e.toString(), context);
    }
    setState(() {
      isLoading=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(widget.uid);
    print(userData['username']);
    print(userData['photoUrl']);
    print(userData['bio']);
    print(postLen);
    print(followers);
    print(following);
    return isLoading?const Center(child: CircularProgressIndicator(),) 
    :Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text(userData['username']),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(userData['photoUrl']),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Row(
                           mainAxisSize: MainAxisSize.max,
                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                           children: [
                            buildStartColumn(postLen, "Posts"),
                            buildStartColumn(followers, "Followers"),
                            buildStartColumn(following, "Following")
                           ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                                FirebaseAuth.instance.currentUser!.uid==widget.uid? FollowButton(
                                    text: "Sign Out",
                                    backgroundColor: Colors.black,
                                    borderColor: Colors.grey,
                                    textColor: primaryColor,
                                    function: () async{
                                      await FirestoreMethod().signout();
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                         builder: (context) => const LoginScreen()
                                        
                                      ),
                                      );
                                    }
                                )
                                 :
                                 isFollowing ? FollowButton(
                                    text: "UnFollow",
                                    backgroundColor: Colors.white,
                                    borderColor: Colors.grey,
                                    textColor: Colors.black,
                                    function: () async{
                                        await FirestoreMethod().followUser(FirebaseAuth.instance.currentUser!.uid,userData['uid']);
                                        setState(() {
                                          isFollowing=false;
                                          followers--;
                                        });
                                    },
                                 
                                ):FollowButton(
                                    text: "Follow",
                                    backgroundColor: Colors.blue,
                                    borderColor: Colors.grey,
                                    textColor: Colors.white,
                                    function: () async{
                                        await FirestoreMethod().followUser(FirebaseAuth.instance.currentUser!.uid,userData['uid']);
                                        setState(() {
                                          isFollowing=true;
                                          followers++;
                                        });
                                    },
                                ),
                             ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(top: 15),
                  child: Text(
                    userData['username'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(top: 1),
                  child: Text(
                    userData['bio'],
                  ),
                )
              ],
            ),
          ),
          const Divider(
            color: Colors.grey,
          ),
          FutureBuilder(
            future: FirebaseFirestore.instance.collection('posts').where('uid',isEqualTo: widget.uid).get(),
            builder: (context, snapshot) {
              if(snapshot.connectionState==ConnectionState.waiting){
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } 
              return GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 1.5,
                  mainAxisSpacing: 1.5,
                  childAspectRatio: 1
                ),
                itemCount: (snapshot.data! as dynamic).docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot snap=(snapshot.data! as dynamic).docs[index];
                  return Container(
                    child: Image(
                      image: NetworkImage(snap['postUrl']),
                      fit: BoxFit.cover,
                    ),
                  );
                },
              );
            },
          )
        ]
      ),
    );
  }
  Column buildStartColumn(int count,String label){
    return Column(
     mainAxisSize: MainAxisSize.min,
     mainAxisAlignment: MainAxisAlignment.center,
     children: [
      Text(
        count.toString(),
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      Container(
        margin: EdgeInsets.only(top: 4),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.grey
          ),
        ),
      ),
     ],
    );
  }
}