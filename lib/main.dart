import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:instagramclone/Screens/login_screen.dart';
import 'package:instagramclone/Screens/signup_screen.dart';
import 'package:instagramclone/responsive/mobile_screen_layout.dart';
import 'package:instagramclone/responsive/responsive_layout_screen.dart';
import 'package:instagramclone/responsive/web_screen_layout.dart';
import 'package:instagramclone/utils/colors.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //the banner at upper right corner will be disaper
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: mobileBackgroundColor,
      ),
      title: "Instagram Clone",
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if(snapshot.connectionState== ConnectionState.active){
            if(snapshot.hasData){
               return  ResponsiveLayout(
                webScreenLayout: WebScreenLayout(), 
                mobileScreenLayout: MobileScreenLayout()
              );
            }
            else if(snapshot.hasError){
              return Center(
                child: Text('${snapshot.error}',),
              );
            }
          }
          if(snapshot.connectionState==ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          }
          return LoginScreen();
        },
      ),
    );
  }
}