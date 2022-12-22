import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagramclone/utils/global_variables.dart';

import '../utils/colors.dart';

class WebScreenLayout extends StatefulWidget {
  const WebScreenLayout({super.key});

  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout> {
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
    setState(() {
      _page=page;
    });
  }

  void onPageChanged(int page){
    setState(() {
      _page=page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: SvgPicture.asset(
          "assets/ic_instagram.svg",
          color: Colors.white,
          height: 32,
        ),
        actions: [
          IconButton(
            onPressed:()=>navigationTapped(0), 
            icon: Icon(
              Icons.home,
              color: _page==0?primaryColor:secondaryColor
            ),
          ),
          IconButton(
            onPressed:()=>navigationTapped(1), 
            icon: Icon(
              Icons.search,
              color: _page==1?primaryColor:secondaryColor,
            ),
          ),
          IconButton(
            onPressed:()=>navigationTapped(2), 
            icon: Icon(
              Icons.add_a_photo,
              color: _page==2?primaryColor:secondaryColor,
            ),
          ),
          IconButton(
            onPressed:()=>navigationTapped(3), 
            icon: Icon(
              Icons.notifications,
              color: _page==3?primaryColor:secondaryColor,
            ),
          ),
          IconButton(
            onPressed:()=>navigationTapped(4), 
            icon: Icon(
              Icons.person,
              color: _page==4?primaryColor:secondaryColor,
            ),
          ),
          
        ],
      ) ,
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        children: homeScreenItems,
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
    );
  }
}