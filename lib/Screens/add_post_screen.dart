import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagramclone/Provider/user_provider.dart';
import 'package:instagramclone/Resorces/firestore_methods.dart';
import 'package:instagramclone/utils/colors.dart';
import 'package:instagramclone/utils/utils.dart';
import 'package:provider/provider.dart';

import '../Models/users.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  final TextEditingController _descriptionController=TextEditingController();
  bool _isLoading=false;

  void postImage(String uid,String username,String proImage)async{
    setState(() {
      _isLoading=true;
    });
    try{
      String res=await FirestoreMethod().uploadImage(_descriptionController.text, _file!, uid, username, proImage);
      if(res=="success"){
        setState(() {
          _isLoading=false;
        });
        
        showSnackBar("Posted !", context);
        clearImage();
      }
      else{
        setState(() {
          _isLoading=false;
        });
        showSnackBar(res, context);
      }
    }catch(err){
      showSnackBar(err.toString(), context);
    }
  }

   _selectImage(BuildContext context) async{
      return showDialog(
        context: context, 
        builder: (context){
          return SimpleDialog(
          title: const Text("Create a Post"),
          children: [
            SimpleDialogOption(
              padding: EdgeInsets.all(20),
              child: const Text("Take a photo"),
              onPressed: () async{
                //poping dialog box first
                Navigator.of(context).pop();
                Uint8List file=await pickImage(
                    ImageSource.camera,
                );
                setState(() {
                  _file=file;
                });
              },
            ),
            SimpleDialogOption(
              padding: EdgeInsets.all(20),
              child: const Text("Choose from Gallery"),
              onPressed: () async{
                //poping dialog box first
                Navigator.of(context).pop();
                Uint8List file=await pickImage(
                    ImageSource.gallery,
                );
                setState(() {
                  _file=file;
                });
              },
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Cancle",
                    style: TextStyle(
                      color: Colors.red
                    ),
                  ),
                  ),
                ],
              ),
            ),
          ],
        );
        }
      );
    }
  //after posting post we will show uplaod screen
  void clearImage(){
    setState(() {
      _file=null;
    });
  }
  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Users users=Provider.of<UserProvider>(context).getUser;

    return _file ==null 
    ?Center(
      child: IconButton(
        icon: Icon(
          Icons.upload,
        ),
        onPressed: () => _selectImage(context),
      ),
    )
    : Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: clearImage,
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
            onPressed: () => postImage(users.uid,users.username,users.photoUrl),
          ),
        ],
      ),
      body: Column(
        children: [
          _isLoading
                  ? const LinearProgressIndicator()
                  : const Padding(
                      padding: EdgeInsets.only(top: 0),
                    ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  users.photoUrl,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width*0.45,
                child: TextField(
                  controller: _descriptionController,
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
                        image: MemoryImage(_file!),
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