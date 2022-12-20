import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagramclone/Models/post.dart';
import 'package:instagramclone/Widgets/post_card.dart';
import 'package:instagramclone/utils/colors.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: SvgPicture.asset(
          "assets/ic_instagram.svg",
          color: Colors.white,
          height: 32,
        ),
        actions: [
          IconButton(onPressed:() {}, 
            icon: Icon(Icons.message,),
          ),
        ],
      ) ,
      body: StreamBuilder(
        //we want all documents therfore we are using snapshot
        stream: FirebaseFirestore.instance.collection('posts').orderBy('datePublished',descending: true).snapshots(),
        builder: (context,  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>  snapshot){
          if(snapshot.connectionState==ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(),
            ); 
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return PostCard(
                snap: snapshot.data!.docs[index].data(),
              );
            },
          );
        },
      ),
    );
  }
}