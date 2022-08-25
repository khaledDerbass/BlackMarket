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
            style: TextStyle(fontSize: 18, ),)
        ],
      ),

    );

  }

}
//
// Container(
// height: MediaQuery.of(context).size.height * 0.12,
// child:  Stack(
// children: [
// HeaderWidget(MediaQuery.of(context).size.height * 0.12, false, Icons.account_circle_rounded),
// Positioned(
// top: 25,
// left: 13,
// child: IconButton(
// onPressed: (){
// _scaffoldKey.currentState?.openDrawer();
// },
// icon: Icon(Icons.menu_outlined,color: Colors.white,size: MediaQuery.of(context).size.height * 0.032,),
// ),
// ),
// Row(
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// Image.asset('assets/images/logo2.png',height: MediaQuery.of(context).size.width * 0.16,width: MediaQuery.of(context).size.width * 0.16,),
//
// ],
// ),
// Padding(
// padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.025,right: MediaQuery.of(context).size.width * 0.03),
// child: Row(
// mainAxisAlignment: MainAxisAlignment.end,
// children: [
// IconButton(onPressed: (){
// Navigator.push(
// context,
// MaterialPageRoute(builder: (context) => const SearchPage()),
// );
// }, icon: Icon(Icons.search_rounded,color: Colors.white,size: MediaQuery.of(context).size.height * 0.032,))
//
// ],
// ),
// ),
// ],
// ),
// ),
