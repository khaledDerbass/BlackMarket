import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:souq/src/models/CustomProfileAppBar.dart';
import '../models/ProfileHeader.dart';
import 'GalleryPage.dart';
import 'HomeScreen.dart';

class profilepage extends StatefulWidget {
  const profilepage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return profilepageState();
  }
}

class profilepageState extends State<profilepage> {
  PickedFile? imageFile = null;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
                currentAccountPicture: CircleAvatar(
                  radius: 200,
                  backgroundImage:
                      NetworkImage('https://placeimg.com/640/480/people'),
                ),
              ),
              ListTile(
                leading: Icon(Icons.contact_support_outlined),
                title: Text('Contact us'),
                onTap: () => {Navigator.of(context).pop()},
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
            body: SafeArea(
              child: Column(
                children: <Widget>[
                  Material(
                    color: Colors.white,
                    child: TabBar(
                          // ignore: prefer_const_constructors
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
        ),
        bottomNavigationBar: ConvexAppBar(
          style: TabStyle.fixed,
          color: CupertinoColors.white,
          backgroundColor: Colors.deepPurple,
          items: [
            TabItem(
                icon: Icons.home,
                title: isArabic(context) ? 'الرئيسية' : 'Home'),
            TabItem(
                icon: Icons.camera_alt,
                title: isArabic(context) ? 'إضافة' : 'Add'),
            TabItem(
                icon: Icons.people,
                title: isArabic(context) ? 'الحساب' : 'Profile'),
          ],
          initialActiveIndex: 0, //optional, default as 0
          onTap: (int i) => {
            if (i == 0)
              {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                ),
              }
            else if (i == 1)
              {
                _showChoiceDialog(context),
              }
          },
        ),
      ),
    );
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: ListBody(
              children: [
                Divider(
                  height: 1,
                  color: CupertinoColors.systemPurple,
                ),
                ListTile(
                  onTap: () {
                    _openGallery(context);
                  },
                  title: Text("Gallery"),
                  leading: Icon(
                    Icons.account_box,
                    color: CupertinoColors.systemPurple,
                  ),
                ),
                Divider(
                  height: 1,
                  color: CupertinoColors.systemPurple,
                ),
                ListTile(
                  onTap: () {
                    _openCamera(context);
                  },
                  title: Text("Camera"),
                  leading: Icon(
                    Icons.camera,
                    color: CupertinoColors.systemPurple,
                  ),
                ),
              ],
            ),
          );
        });
  }

  void _openGallery(BuildContext context) async {
    final pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );
    setState(() {
      imageFile = pickedFile!;
    });

    Navigator.pop(context);
  }

  void _openCamera(BuildContext context) async {
    final pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
    );
    setState(() {
      imageFile = pickedFile!;
    });
    Navigator.pop(context);
  }
}
