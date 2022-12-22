import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagramclone/Models/post.dart';
import 'package:instagramclone/Widgets/post_card.dart';
import 'package:instagramclone/responsive/web_screen_layout.dart';
import 'package:instagramclone/utils/colors.dart';
import 'package:instagramclone/utils/global_variables.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
      final width=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: width>webScreenSize? null :AppBar(
        backgroundColor: width>webScreenSize? webBackgroundColor : mobileBackgroundColor,
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
              return Container(
                margin: EdgeInsets.symmetric(
                 horizontal: width>webScreenSize?width+0.3:0, 
                 vertical: width>webScreenSize?15:0, 
                ),
                child: PostCard(
                  snap: snapshot.data!.docs[index].data(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}