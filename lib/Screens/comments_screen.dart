import 'package:flutter/material.dart';
import 'package:instagramclone/Models/users.dart';
import 'package:instagramclone/Provider/user_provider.dart';
import 'package:instagramclone/Resorces/firestore_methods.dart';
import 'package:instagramclone/Screens/comment_card.dart';
import 'package:instagramclone/utils/colors.dart';
import 'package:provider/provider.dart';

class CommentsScreen extends StatefulWidget {
  final String profImage;
  final String description;
  final String date;
  final String userName;
  final String postId;
  final String uid;
  const CommentsScreen({
    required this.profImage,
    required this.description,
    required this.date,
    required this.userName,
    required this.postId,
    required this.uid,
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
                backgroundImage: NetworkImage(widget.profImage),
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
                                text: widget.userName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: ' ${widget.description}',
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: Text(
                          widget.date,
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
          CommentCard(),
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
                   await FirestoreMethod().postComment(widget.postId,_commentController.text,widget.uid,widget.userName,widget.profImage);
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