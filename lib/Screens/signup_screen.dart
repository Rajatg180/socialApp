import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagramclone/Resorces/auth_methods.dart';
import 'package:instagramclone/Screens/login_screen.dart';
import 'package:instagramclone/Widgets/textfield_input.dart';
import 'package:instagramclone/utils/utils.dart';

import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/web_screen_layout.dart';
import '../utils/colors.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController=TextEditingController();
  final TextEditingController _passwordController=TextEditingController();
  final TextEditingController _userNameController=TextEditingController();
  final TextEditingController _bioController=TextEditingController();
  Uint8List? _image;
  bool _isLoading=false;

  @override
  void dispose(){
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _userNameController.dispose();
  }

  void selectImage()async{
     Uint8List im= await pickImage(ImageSource.gallery);
     setState(() {
       _image=im;
     });
  }

  void signUpUser()async{
    //start circular progress bar until it get signup
    setState(() {
      _isLoading=true;
    });

    String res =await AuthMethod().signUpUser(
                    username: _userNameController.text.trim(), 
                    email: _emailController.text.trim(), 
                    password: _passwordController.text.trim(), 
                    bio: _bioController.text.trim(), 
                    file: _image!,
                  );
    
    //stoping circular progress bar 
    setState(() {
      _isLoading=false;
    });

    if(res!="success"){
      showSnackBar(res, context);
    }
    else{
      //if signup is success full
      Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) =>  ResponsiveLayout(
                webScreenLayout: WebScreenLayout(), 
                mobileScreenLayout: MobileScreenLayout()
              )
      ),
    );
    }
  }
  //function for moving to login screen
  void navigateToLogin(){
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LoginScreen()
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //to avoid pixel overfloow
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          //const keyword will not the widget rebuild
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(child: Container(),flex: 2,),
              //svg image Instagram 
              SvgPicture.asset(
                "assets/ic_instagram.svg",
                color: primaryColor,
                height: 64,
              ),
              SizedBox(
                height: 24,
              ),

              //profile image
              Stack(
                children: [
                  _image!=null
                  ?CircleAvatar(
                    radius: 64,
                    backgroundImage: MemoryImage(_image!),
                  )
                  :const CircleAvatar(
                    radius: 64,
                    backgroundImage: AssetImage('assets/profileImage.png',),
                  ),
                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                      onPressed: selectImage, 
                      icon: Icon(
                        Icons.add_a_photo,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 24,
              ),

              //text field input for UserName
              TextFieldInput(
                textEditingController: _userNameController, 
                hintText: "Enter your username", 
                textInputType: TextInputType.text
              ),
              SizedBox(
                height: 24,
              ),

              //text field input for email
              TextFieldInput(
                textEditingController: _emailController, 
                hintText: "Enter your email", 
                textInputType: TextInputType.emailAddress
              ),
              SizedBox(
                height: 24,
              ),

              //text field input for password
              TextFieldInput(
                textEditingController: _passwordController, 
                hintText: "Enter your password", 
                textInputType: TextInputType.text,
                isPassword: true,
              ),
              SizedBox(
                height: 24,
              ),

              //text field input for bio
              TextFieldInput(
                textEditingController: _bioController, 
                hintText: "Enter your bio", 
                textInputType: TextInputType.text
              ),
              SizedBox(
                height: 24,
              ),

              //Button 
              InkWell(
                onTap: signUpUser,
                child: Container(
                  child: _isLoading 
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: primaryColor,
                      ),
                    )
                  :const Text("Sign up"),
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                    ),
                    color: blueColor,
                  ),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Flexible(child: Container(),flex: 2,),

              //For signup page
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text("Already have an account ? "),
                    padding: EdgeInsets.symmetric(vertical: 8),
                  ),
                  GestureDetector(
                    onTap: navigateToLogin,
                    child: Container(
                      child: Text(
                        "Log in",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: blueColor
                        ),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}