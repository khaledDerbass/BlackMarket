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
      expandedHeight: MediaQuery.of(context).size.height * 0.05,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(15),
              bottomLeft: Radius.circular(15))),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children:[
          Padding(
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.height * .08,
            ),),

    Image.asset('assets/images/logo2.png',height: MediaQuery.of(context).size.width * 0.17,width: MediaQuery.of(context).size.width * 0.30,),

    ],
    ),

    );

  }

}
