import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommentCard extends StatefulWidget {
  final snap;
  const CommentCard({
   required this.snap,
  });

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    print(widget.snap);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(widget.snap['profilePic']),
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
                            text: widget.snap['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: ' ${widget.snap['text']}',
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                        DateFormat.yMMMd().format(
                          //converting to DateTime
                           widget.snap['datePublished'].toDate(),
                        ),
                        style: TextStyle(
                          color: Colors.grey
                       ),
                     ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            child: const Icon(
              Icons.favorite_border,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}