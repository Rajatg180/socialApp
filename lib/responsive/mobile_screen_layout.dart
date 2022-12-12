import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:instagramclone/Provider/user_provider.dart';
import 'package:instagramclone/utils/colors.dart';
import 'package:instagramclone/utils/global_variables.dart';
import 'package:provider/provider.dart';
import '../Models/users.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  // String username="";
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   getUsername();
  // }

  //function for getting userName of currnet user 
  // void getUsername()async{
  //   DocumentSnapshot snap= await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();

  //   setState(() {
  //     //get username of currentuser
  //     username=(snap.data() as Map<String,dynamic>)['username'];
  //   });

  // }
  
  int _page=0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController=PageController();
  }

  @override
  void dispose(){
    super.dispose();
    pageController.dispose();
  }

  void navigationTapped(int page){
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page){
    setState(() {
      _page=page;
    });
  }

  @override
  Widget build(BuildContext context) {
    Users user=Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      body: PageView(
        children: homeScreenItems,
        controller: pageController,
        onPageChanged: onPageChanged,
        //page will chnage when we will swipe
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: mobileBackgroundColor,
        ),
        child: BottomNavigationBar(
          
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: _page==0?primaryColor:secondaryColor,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                color: _page==1?primaryColor:secondaryColor,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.add_circle,
                color: _page==2?primaryColor:secondaryColor,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite,
                color: _page==3?primaryColor:secondaryColor,
              ),
              label: '',
            ),
             BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: _page==4?primaryColor:secondaryColor,
              ),
              label: '',
            ),
          ],
          onTap: navigationTapped,
        ),
      ),
    );
  }
}