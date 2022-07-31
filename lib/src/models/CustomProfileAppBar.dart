import 'package:flutter/material.dart';

class CustomProfileAppBar extends StatelessWidget{
  const CustomProfileAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return SliverAppBar(
      pinned: true,
      centerTitle: false,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children:[
        Padding(
          padding: const EdgeInsets.only(left: 45.0,),
          child: Icon(Icons.perm_identity_outlined,
          size: 25,
    ),),
         Text("Souq Story",
        style: TextStyle(fontSize: 20, ),)
        ],
      ),
      actions: [
        IconButton(onPressed: () =>{}, icon: Icon(Icons.dehaze_outlined))
      ],
    );

      }

  }

