import 'package:flutter/material.dart';
import 'package:instagramclone/Provider/user_provider.dart';
import 'package:instagramclone/Resorces/firestore_methods.dart';
import 'package:instagramclone/Screens/comments_screen.dart';
import 'package:instagramclone/utils/colors.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../Models/users.dart';
import 'likes_animation.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({
    required this.snap,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {

  bool isLikeAnimating=false;
  @override
  Widget build(BuildContext context) {
    final Users user=Provider.of<UserProvider>(context).getUser;

    return Container(
      color: mobileBackgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          //Upper Section
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 16,
            ).copyWith(right: 0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(
                    widget.snap['profImage'],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.snap['username'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.more_vert,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  child: ListView(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    shrinkWrap: true,
                                    children: ['Delete', 'Report']
                                        .map(
                                          (e) => InkWell(
                                            onTap: () => null,
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 16, vertical: 12,
                                                ),
                                              child: Text(e),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          //Image section
          GestureDetector(
            onDoubleTap: () async{
              await FirestoreMethod().likePost(
               widget.snap['postId'],
               widget.snap['uid'],
               widget.snap['likes'],
              );
              setState(() {
                isLikeAnimating=true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                  child: Image.network(
                    widget.snap['postUrl'],
                    fit: BoxFit.cover,
                  )
                ),
                AnimatedOpacity(
                  duration: const Duration(microseconds: 200),
                  opacity: isLikeAnimating?1:0,
                  child: LikeAnimation(
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 120,
                    ), 
                    isAnimating: isLikeAnimating,
                    duration: const Duration(
                      microseconds: 400,
                    ),
                    onEnd: () {
                      setState(() {
                        isLikeAnimating=false;
                      });
                    },
                  ),
                ),
              ], 
            ),
          ),
          //Like,commnet section
          Row(
            children: [
              LikeAnimation(
                isAnimating: widget.snap['likes'].contains(user.uid),
                smallLike: true,
                child: IconButton(
                  onPressed: (() async{
                    await FirestoreMethod().likePost(
                      widget.snap['postId'],
                      widget.snap['uid'],
                      widget.snap['likes'],
                    ); 
                  }),
                  icon: widget.snap['likes'].contains(user.uid) 
                  ? const Icon(
                    Icons.favorite,
                    color: Colors.red,
                  )
                  :const Icon(
                    Icons.favorite_border,
                  ),
                ),
              ),
              IconButton(
                onPressed:(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CommentsScreen(profImage: widget.snap['profImage'],description: widget.snap['description'],date :DateFormat.yMMMd().format(widget.snap['datePublished'].toDate(),),userName: widget.snap['username'],postId: widget.snap['postId'],uid: widget.snap['uid'],)
                    ),
                  );
                }),
                icon: const Icon(
                  Icons.comment_outlined,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: null,
                icon: const Icon(
                  Icons.send,
                  color: Colors.white,
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: null,
                      icon: Icon(
                        Icons.bookmark_outline,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          //Description
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DefaultTextStyle(
                style: Theme.of(context).textTheme.subtitle2!.copyWith(
                  fontWeight: FontWeight.w800,
                ),
                child: Text(
                  '${widget.snap['likes'].length} likes',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                  top: 8,
                ),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(color: primaryColor,),
                    children: [
                      TextSpan(
                        text: '${widget.snap['username']} ',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: widget.snap['description'],
                        // style: const TextStyle(
                        //   fontWeight: FontWeight.bold,
                        // ),
                      ),
                    ],
                  ), 
                ),
              ),
              InkWell(
                onTap: (() => null),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 4
                  ),
                  child: Text(
                    "view all 24 comments",
                    style: const TextStyle(
                      fontSize: 16,
                      color: secondaryColor,
                    ),
                  ),
                ),
              ),
              Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 4
                  ),
                  child: Text(
                    //as date is not of type string using intl package to fomating date
                    DateFormat.yMMMd().format(
                      //converting to DateTime
                      widget.snap['datePublished'].toDate(),
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                      color: secondaryColor,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
