import 'package:flutter/material.dart';
import 'package:souq/src/models/CustomProfileAppBar.dart';
import 'package:souq/src/models/SideBar%20Profile.dart';
import '../models/ProfileHeader.dart';
import 'GalleryPage.dart';


class profilepage extends StatelessWidget {
  const profilepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.deepPurpleAccent),
              accountName: Text(
                "Khaled Derbass",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              accountEmail: Text(
                "derbasskhaled1@gmail.com",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              currentAccountPicture:
              CircleAvatar( radius: 200,
                backgroundImage: NetworkImage('https://placeimg.com/640/480/people'),
              ),
            ),
            ListTile(
              leading: Icon(Icons.contact_support_outlined),
              title: Text('Contact us'),
              onTap: () => {
              Navigator.pop(context),

              },
            ),
            ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('About us'),
              onTap: () => {
                Navigator.pop(context),
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Sign out'),
              onTap: () => {Navigator.of(context).pop()},
            ),
          ],
        ),
      ),
      body: DefaultTabController(
        length: 1,
        child: NestedScrollView(
          headerSliverBuilder: (context, index) {
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
          ),
        ),
      ),
    );
  }
}
