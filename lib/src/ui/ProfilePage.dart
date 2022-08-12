import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:souq/src/models/UserModel.dart';
import 'package:souq/src/ui/AccountPage.dart';
import 'package:souq/src/ui/CustomProfileAppBar.dart';
import 'package:souq/src/ui/SettingPage.dart';
import '../Services/AuthenticationService.dart';
import '../models/Store.dart';
import '../models/UserStore.dart';
import 'AboutUsPage.dart';
import 'AddPostScreen.dart';
import 'ContactUsPage.dart';
import 'ProfileHeader.dart';
import 'GalleryPage.dart';
import 'HomeScreen.dart';
import '../../Helpers/LoginHelper.dart';

class profilepage extends StatefulWidget {
  const profilepage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return profilepageState();
  }
}

class profilepageState extends State<profilepage> {

  PickedFile? imageFile = null;
  var isLoggedIN =  AuthenticationService.isCurrentUserLoggedIn();
  final box = GetStorage();
  late int roleId;
  late UserStore userStore;
  String storeName = "Souq Story";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    roleId = box.read("roleID");


    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        drawer: Drawer(
          child: roleId == 1 ? FutureBuilder(
            builder: (ctx, snapshot) {
              // Checking if future is resolved or not
              if (snapshot.connectionState == ConnectionState.done) {
                // If we got an error
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      '${snapshot.error} occurred',
                      style: TextStyle(fontSize: 18),
                    ),
                  );

                  // if we got our data
                } else if (snapshot.hasData) {
                  // Extracting data from snapshot object
                  var data = snapshot.data as UserModel;
                  return ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      UserAccountsDrawerHeader(
                        decoration: BoxDecoration(color: Colors.deepPurpleAccent),
                        accountName: Text(
                          data.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        accountEmail: Text(
                          data.email,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        currentAccountPicture: CircleAvatar(
                          radius: 200,
                          backgroundImage:
                          Image.memory(base64Decode(data.profilePicture)).image,
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.info_outline),
                        title: Text(isArabic(context) ? 'تواصل معنا' : 'Contact us'),
                        onTap: () => {
                          Navigator.push(context,MaterialPageRoute(builder: (context) => const ContactUs())),
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.contact_support_outlined),
                        title: Text(isArabic(context) ? 'من نحن' : 'About us'),
                        onTap: () => {
                          Navigator.push(context,MaterialPageRoute(builder: (context) => const AboutUs())),
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.settings
                        ),
                        title: Text(isArabic(context) ? 'الإعدادات' : 'Settings'),
                        onTap: () => {
                          Navigator.push(context,MaterialPageRoute(builder: (context) => const SettingPage())),
                        },
                      ),
                      isLoggedIN == true  ? ListTile(
                        leading: Icon(Icons.logout),
                        title: Text(isArabic(context) ? 'تسجيل خروج' : 'Sign out'),
                        onTap: () => {
                          AuthenticationService.signOut().then((value) => {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()))
                          }),
                        },
                      ):
                      ListTile(   ),
                    ],
                  );
                }
              }

              // Displaying LoadingSpinner to indicate waiting state
              return Center(
                child: CircularProgressIndicator(),
              );
            },

            // Future that needs to be resolved
            // inorder to display something on the Canvas
            future: roleId == 1 ? loadUser() : loadStore(context),
          )
              : FutureBuilder(
            builder: (ctx, snapshot) {
              // Checking if future is resolved or not
              if (snapshot.connectionState == ConnectionState.done) {
                // If we got an error
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      '${snapshot.error} occurred',
                      style: TextStyle(fontSize: 18),
                    ),
                  );

                  // if we got our data
                } else if (snapshot.hasData) {
                  // Extracting data from snapshot object
                  var data = snapshot.data as Store;
                  return ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      UserAccountsDrawerHeader(
                        decoration: BoxDecoration(color: Colors.deepPurpleAccent),
                        accountName: Text(
                          isArabic(context) ? data.nameAr : data.nameEn,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        accountEmail: Text(
                          "",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        currentAccountPicture: CircleAvatar(
                          radius: 200,
                          backgroundImage:
                          Image.memory(base64Decode(userStore.userModel.profilePicture)).image,
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.info_outline),
                        title: Text(isArabic(context) ? 'تواصل معنا' : 'Contact us'),
                        onTap: () => {
                          Navigator.push(context,MaterialPageRoute(builder: (context) => const ContactUs())),
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.contact_support_outlined),
                        title: Text(isArabic(context) ? 'من نحن' : 'About us'),
                        onTap: () => {
                          Navigator.push(context,MaterialPageRoute(builder: (context) => const AboutUs())),
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.settings
                        ),
                        title: Text(isArabic(context) ? 'الإعدادات' : 'Settings'),
                        onTap: () => {
                          Navigator.push(context,MaterialPageRoute(builder: (context) => const SettingPage())),
                        },
                      ),
                      isLoggedIN == true  ? ListTile(
                        leading: Icon(Icons.logout),
                        title: Text(isArabic(context) ? 'تسجيل خروج' : 'Sign out'),
                        onTap: () => {
                          AuthenticationService.signOut().then((value) => {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()))
                          }),
                        },
                      ):
                      ListTile(   ),
                    ],
                  );
                }
              }

              // Displaying LoadingSpinner to indicate waiting state
              return Center(
                child: CircularProgressIndicator(),
              );
            },

            // Future that needs to be resolved
            // inorder to display something on the Canvas
            future: roleId == 1 ? loadUser() : loadStore(context),
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
                    labelPadding: EdgeInsets.only(top:.001,bottom: .001),
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.black,
                      indicatorWeight:MediaQuery.of(context).size.height * .002,
                      indicatorColor: Colors.black,
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
          backgroundColor: Colors.deepPurpleAccent,
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddPostPage()),
                ),
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
                  title: Text(isArabic(context) ? 'الاستوديو' : 'Gallery'),
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
                  title: Text(isArabic(context) ? 'الكاميرا': 'Camera'),
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
  bool isArabic(BuildContext context) {
    return context.locale.languageCode == 'ar';
  }

  showSettingAlertDialog(BuildContext context) {
    Widget okButton = FlatButton(
      child: isArabic(context) ? const Text("إلغاء") : const Text("Dismiss"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );

    AlertDialog alert = AlertDialog(
      actions: [
        okButton,
      ],
      title: isArabic(context) ? const Text("الإعدادات" ,  style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),) : const Text("Settings",  style: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
    )),
      content: SizedBox(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height / 5,
        child: ListView(
          children: <Widget>[
            ListTile(
                title: isArabic(context)
                    ? const Text(
                  'الحساب',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                )
                    : const Text(
                  'Account',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Icon(
                  Icons.account_circle_outlined
                  ,
                  color: Colors.black,
                ),
                    onTap: () => {
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                    builder: (context) => const AccountPage()),
                    ),}),
            const Divider(),
            ListTile(
                title: isArabic(context)
                    ? const Text(
                  'إشعارات',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),                )
                    : const Text(
                  'Notifications',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),                ),
                trailing: Icon(
                  Icons.notification_add
                  ,
                  color: Colors.black,
                ),
                onTap: () => {
                }),
            const Divider(),
            ListTile(
                title: isArabic(context)
                    ? const Text(
                  'مساعدة',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                )
                    : const Text(
                  'Help',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Icon(
                  Icons.live_help_outlined
                  ,
                  color: Colors.black,
                ),
                 onTap: () => {
                    }),
            const Divider(),
            ListTile(
                title: isArabic(context)
                    ? const Text(
                  'إعلانات ممولة',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),                )
                    :  Text(
                  'Ads',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),                ),
                trailing: Icon(
                  Icons.ads_click
                  ,
                  color: Colors.black,
                ),
                onTap: () => {
                }),          ],
        ),
      ),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<Store> loadStore(BuildContext context)async{
    late Store store;
    late UserModel user;

    await FirebaseFirestore.instance.collection('Users').where(
        'email', isEqualTo: FirebaseAuth.instance.currentUser?.email)
        .get()
        .then((value) =>
        value.docs.forEach((doc) {
          user = UserModel.fromJson(value.docs.first.data());
          print(user.name);
        }));

    DocumentSnapshot snap;

    await FirebaseFirestore.instance.collection('Store').doc(user.storeId)
        .get().then((value) => {
      snap = value,
      store = Store.fromSnapshot(snap),
      print(store.nameAr),
    });

    userStore = UserStore(user, store);
    storeName = isArabic(context) ? userStore.store.nameAr : userStore.store.nameEn;
    return store;
  }
  Future<UserModel> loadUser() async {
    late UserModel user;
    await FirebaseFirestore.instance.collection('Users').where(
        'email', isEqualTo: FirebaseAuth.instance.currentUser?.email)
        .get()
        .then((value) =>
        value.docs.forEach((doc) {
          user = UserModel.fromJson(value.docs.first.data());
          print(user.name);
        }));

    return user;

  }
}
