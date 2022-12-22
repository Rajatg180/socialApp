import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagramclone/Screens/profile_screen.dart';
import 'package:instagramclone/utils/colors.dart';
// ignore: unused_import
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagramclone/utils/global_variables.dart';
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController=TextEditingController();
  bool isShowUsers=false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: TextFormField(

          controller: searchController,
          decoration: const InputDecoration(
            labelText: "Search for user"
          ),
          onFieldSubmitted: (_) {
            setState(() {
              isShowUsers=true;
            });
          },
        ),
      ),
      body: isShowUsers? FutureBuilder(
        future: FirebaseFirestore.instance.collection('users').where('username',isGreaterThanOrEqualTo: searchController.text).get(),
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
             itemCount: (snapshot.data! as dynamic).docs.length,
             itemBuilder: (context, index) {
               return InkWell(
                 onTap: ((){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(uid: (snapshot.data! as dynamic).docs[index]['uid']),
                    ),
                  );
                 }),
                 child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage((snapshot.data! as dynamic).docs[index]['photoUrl'])
                  ),
                  title: Text(
                    (snapshot.data! as dynamic).docs[index]['username'],
                  ),
                 ),
               );
             },
          );
        },
      ):FutureBuilder(
        future: FirebaseFirestore.instance.collection('posts').get(),
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return StaggeredGridView.countBuilder(
           crossAxisCount: 3,
           mainAxisSpacing: 1,
           crossAxisSpacing: 1,
           itemCount: (snapshot.data as dynamic).docs.length,
           itemBuilder: (context, index) {
             return Image.network(
              (snapshot.data as dynamic).docs[index]['postUrl']
             );
           },
           staggeredTileBuilder: (index) => MediaQuery.of(context).size.width>webScreenSize 
           ?StaggeredTile.count(
            (index%7==0)? 1:1, 
            (index%7==0)? 1:1,
           )
           :StaggeredTile.count(
            (index%7==0)? 2:1, 
            (index%7==0)? 2:1,
           ),
          );
        },
      ),
    );
  }
}