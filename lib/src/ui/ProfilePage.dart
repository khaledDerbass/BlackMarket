import 'package:flutter/material.dart';
import 'package:souq/src/models/CustomProfileAppBar.dart';
import '../models/ProfileHeader.dart';
import 'GalleryPage.dart';

class profilepage extends StatelessWidget{
  const profilepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Material(
        color: Colors.white,
     child: DefaultTabController(
      length: 1,

      child: NestedScrollView(
          headerSliverBuilder: (context,index) {
            return [
            CustomProfileAppBar(),
              profileHeader(),
            ];
          },


          body: Column(
            children: <Widget>[
              Material(
                color: Colors.white,
                child: TabBar(
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey[400],
                  indicatorWeight: 1,
                  indicatorColor: Colors.black,
                  tabs: [
                    Tab(
                      icon: Icon(
                        Icons.grid_on_sharp,
                        color: Colors.black,
                      ),
                    ),

                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    Gallery(),
                  ],
                ),
              ),
            ],

    ),),),);



  }

}

