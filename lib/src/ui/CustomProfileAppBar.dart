import 'package:flutter/material.dart';
import 'package:souq/src/ui/HeaderWidget.dart';

import 'HomeScreen.dart';

class CustomProfileAppBar extends StatelessWidget {
  bool isSearchStore = false;
   CustomProfileAppBar(this.isSearchStore, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(

      backgroundColor: Colors.deepPurpleAccent,
      pinned: true,
      centerTitle: false,
      elevation: 0,
      expandedHeight: MediaQuery.of(context).size.height * 0.05,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(15),
              bottomLeft: Radius.circular(15))),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children:[
          isSearchStore ? IconButton(onPressed:(){
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                  const HomeScreen()),
            );
          }, icon: Icon(Icons.arrow_back)) : Container(),
          Padding(
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.height * .057,
            ),),

       Image.asset('assets/images/offerstorylogo.png',height: MediaQuery.of(context).size.width * 0.4,width: MediaQuery.of(context).size.width * 0.4,),

    ],
    ),

    );

  }

}
