import 'package:flutter/material.dart';
import 'package:instagramclone/utils/colors.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  @override
  Widget build(BuildContext context) {
    // return Center(
    //   child: IconButton(
    //     icon: Icon(
    //       Icons.upload,
    //     ),
    //     onPressed: (){},
    //   ),
    // );
   return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            
          },
        ),
        title: Text("Post to"),
        centerTitle: false,
        actions: [
          TextButton(
            child: Text(
              "Post",
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            onPressed: () {
              
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: AssetImage("assets/profileImage.png")
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width*0.45,
                child: TextField(
                  decoration: const InputDecoration(
                      hintText: "Write a caption....",
                      border: InputBorder.none,
                  ),
                  maxLines: 8,
                ),
              ),
              SizedBox(
                height: 45,
                width: 45,
                child: AspectRatio(
                   aspectRatio: 487/451,
                   child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/profileImage.png"),
                        fit: BoxFit.fill,
                        alignment: FractionalOffset.topCenter,
                      ),
                    ),
                   ),
                ),
              ),
              const Divider(),
            ],
          ),
        ],
      ),
    );
  }
}