import 'package:flutter/material.dart';
import 'package:instagramclone/Provider/user_provider.dart';
import 'package:instagramclone/utils/global_variables.dart';
import 'package:provider/provider.dart';

class ResponsiveLayout extends StatefulWidget {

  final Widget webScreenLayout;
  final Widget mobileScreenLayout;
  
  ResponsiveLayout({required this.webScreenLayout,required this.mobileScreenLayout});

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addData();
  }
  addData() async{
    UserProvider _userProvider=Provider.of(context,listen: false);

    _userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context,constraints){
        if(constraints.maxWidth > webScreenSize){
          //web Screen
          return widget.webScreenLayout;
        }
        //mobile Screen
        return widget.mobileScreenLayout;
      },
    ) ;
  }
}