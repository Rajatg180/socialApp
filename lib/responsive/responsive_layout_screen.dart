import 'package:flutter/material.dart';
import 'package:instagramclone/utils/dimensions.dart';

class ResponsiveLayout extends StatelessWidget {

  final Widget webScreenLayout;
  final Widget mobileScreenLayout;
  
  ResponsiveLayout({required this.webScreenLayout,required this.mobileScreenLayout});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context,constraints){
        if(constraints.maxWidth > webScreenSize){
          //web Screen
          return webScreenLayout;
        }
        //mobile Screen
        return mobileScreenLayout;
      },
    ) ;
  }
}