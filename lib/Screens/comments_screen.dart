import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagramclone/Models/users.dart';
import 'package:instagramclone/Provider/user_provider.dart';
import 'package:instagramclone/Resorces/firestore_methods.dart';
import 'package:instagramclone/Screens/comment_card.dart';
import 'package:instagramclone/utils/colors.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CommentsScreen extends StatefulWidget {
  // final String profImage;
  // final String description;
  // final String date;
  // final String userName;
  // final String postId;
  // final String uid;
  final snap;
  const CommentsScreen({
    // required this.profImage,
    // required this.description,
    // required this.date,
    // required this.userName,
    // required this.postId,
    // required this.uid,
    required this.snap,
  });

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _commentController=TextEditingController();

  @override 
  void dispose(){
    super.dispose();
    _commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Users users=Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text("Comments"),        
      ),
      body: Column(
        children: [
          Container(
          padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 8),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(widget.snap['profImage']),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 7),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: widget.snap['username'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: ' ${widget.snap['description']}',
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: Text(
                           DateFormat.yMMMd().format(widget.snap['datePublished'].toDate()),
                           style: TextStyle(
                              color: Colors.grey
                           ),
                         ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          ),
          Divider(
               color: Colors.grey,
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('posts').doc(widget.snap['postId']).collection('comments').orderBy(descending: true,'datePublished').snapshots(),
              builder: (context, snapshot) {
                if(snapshot.connectionState==ConnectionState.waiting){
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  itemBuilder: (context, index) {
                    return  CommentCard(
                      snap: (snapshot.data! as dynamic).docs[index].data(),
                    );
                  }
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          padding: const EdgeInsets.only(left: 16,right: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(users.photoUrl),
                radius: 18,
              ),
              SizedBox(
                width: 10,
              ),
              Flexible(
                child: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    hintText: "Comment as ${users.username}",
                    border: InputBorder.none,
                    
                  ),
                ),
              ),
              IconButton(
                onPressed: () async {
                  await FirestoreMethod().postComment(widget.snap['postId'],_commentController.text,widget.snap['uid'],widget.snap['username'],widget.snap['profImage']); 
                  setState(() {
                    _commentController.text="";
                  });
                }, 
                icon: Icon(
                  Icons.send,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}