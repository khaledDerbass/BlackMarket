import 'package:flutter/material.dart';

class CustomProfileAppBar extends StatelessWidget{
  const CustomProfileAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return SliverAppBar(
      backgroundColor: Colors.deepPurpleAccent,
      pinned: true,
      centerTitle: false,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children:[
        Padding(
          padding: const EdgeInsets.only(
            left: 45.0,
          ),
          child: Icon(Icons.shopping_cart,
          size: 25,
    ),),
         Text("Souq Story",
        style: TextStyle(fontSize: 20, ),)
        ],
      ),

    );

      }

  }

