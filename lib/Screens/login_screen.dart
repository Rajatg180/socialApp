import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagramclone/Resorces/auth_methods.dart';
import 'package:instagramclone/Widgets/textfield_input.dart';
import 'package:instagramclone/utils/colors.dart';
import 'package:instagramclone/utils/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController=TextEditingController();
  final TextEditingController _passwordController=TextEditingController();
  bool _isLoading=false;

  @override
  void dispose(){
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void logInUser()async{
    //start circular progress bar until it get login
    setState(() {
      _isLoading=true;
    });

    String res=await AuthMethod().loginUpUser(
                    email: _emailController.text.trim(),
                    password: _passwordController.text.trim()
                  );
    
    if(res=="success"){
      print(res);
      showSnackBar(res, context);
    }
    else{
      showSnackBar(res, context);
    }

    //stoping circular progress bar 
    setState(() {
      _isLoading=false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

              //text field input fro email
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

              //Button 
              InkWell(
                onTap: logInUser,
                child: Container(
                  child: _isLoading 
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: primaryColor,
                      ),
                    )
                  : const Text("Login"),
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
                    child: Text("Don't have an account ? "),
                    padding: EdgeInsets.symmetric(vertical: 8),
                  ),
                  GestureDetector(
                    onTap: () => null,
                    child: Container(
                      child: Text(
                        "Sign up",
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