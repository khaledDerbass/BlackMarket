import 'package:flutter/material.dart';
import 'package:souq/src/ui/HeaderWidget.dart';

class CustomProfileAppBar extends StatelessWidget {
  const CustomProfileAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(

      backgroundColor: Colors.deepPurpleAccent,
      pinned: true,
      centerTitle: false,
      elevation: 0,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(25),
              bottomLeft: Radius.circular(25))),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children:[
          Padding(
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.height * .10,
            ),),
          Text("Souq Story",
            style: TextStyle(fontSize: 18,fontFamily:'SouqFont' ),)
        ],
      ),

    );

  }

}
