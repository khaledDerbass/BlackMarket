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
import 'package:souq/src/ui/CustomProfileAppBar.dart';
import 'package:souq/src/ui/SettingPage.dart';
import '../Services/AuthenticationService.dart';
import '../models/Store.dart';
import '../models/UserStore.dart';
import 'AboutUsPage.dart';
import 'AddPostScreen.dart';
import 'ContactUsPage.dart';
import 'ProfileHeader.dart';
import 'Gallery.dart';
import 'HomeScreen.dart';
import '../../Helpers/LoginHelper.dart';

class profilepage extends StatefulWidget {
  final UserStore? searchStore;
  final UserModel? currentUser;

  const profilepage({Key? key, this.searchStore, this.currentUser})
      : super(key: key);

  @override
  State createState() {
    return profilepageState(searchStore, currentUser);
  }
}

class profilepageState extends State<profilepage> {
  PickedFile? imageFile = null;
  var isLoggedIN = AuthenticationService.isCurrentUserLoggedIn();
  final box = GetStorage();
  late int roleId;
  late UserStore userStore;
  String storeName = "Offer Story";

  profilepageState(searchStore, currentUser);



  @override
  Widget build(BuildContext context) {
    roleId = box.read("roleID") ?? 0;
    print("Test Role ID");
    print(roleId);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: widget.searchStore != null
          ? Scaffold(

              body: DefaultTabController(
                length: 1,
                child: NestedScrollView(
                  headerSliverBuilder: (context, index) {
                    return [
                      CustomProfileAppBar(true),
                      profileHeader(
                          searchStore: widget.searchStore,
                          currentUser: widget.currentUser),
                    ];
                  },
                  body: SafeArea(
                    child: Column(
                      children: <Widget>[
                        Material(
                          color: Colors.white,
                          child: TabBar(
                            labelColor: Colors.black,
                            unselectedLabelColor: Colors.black,
                            indicatorWeight:
                                MediaQuery.of(context).size.height * .002,
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
                              Gallery(searchStore: widget.searchStore),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              bottomNavigationBar: roleId == 1
                  ? ConvexAppBar(
                      height: MediaQuery.of(context).size.height * 0.07,
                      style: TabStyle.textIn,
                      color: CupertinoColors.white,
                      backgroundColor: Colors.deepPurpleAccent,
                      items: [
                        TabItem(
                            icon: Icons.home,
                            title: isArabic(context) ? 'الرئيسية' : 'Home'),
                        TabItem(
                            icon: Icons.people,
                            title: isArabic(context) ? 'الحساب' : 'Profile'),
                      ],
                      initialActiveIndex: 1, //optional, default as 0
                      onTap: (int i) => {
                        if (i == 0)
                          {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeScreen()),
                            ),
                          }
                      },
                    )
                  : ConvexAppBar(
                      height: MediaQuery.of(context).size.height * 0.07,
                      style: TabStyle.fixedCircle,
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
                              MaterialPageRoute(
                                  builder: (context) => const HomeScreen()),
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
            )
          : Scaffold(
              drawer: Drawer(
                child: roleId == 1
                    ? FutureBuilder(
                        builder: (ctx, snapshot) {
                          // Checking if future is resolved or not
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
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
                                    decoration: BoxDecoration(
                                        color: Colors.deepPurpleAccent),
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
                                      backgroundImage: Image.memory(
                                              base64Decode(data.profilePicture))
                                          .image,
                                    ),
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.info_outline),
                                    title: Text(isArabic(context)
                                        ? 'تواصل معنا'
                                        : 'Contact us'),
                                    onTap: () => {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const ContactUs())),
                                    },
                                  ),
                                  ListTile(
                                    leading:
                                        Icon(Icons.contact_support_outlined),
                                    title: Text(isArabic(context)
                                        ? 'من نحن'
                                        : 'About us'),
                                    onTap: () => {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const AboutUs())),
                                    },
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.settings),
                                    title: Text(isArabic(context)
                                        ? 'الإعدادات'
                                        : 'Settings'),
                                    onTap: () => {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const SettingPage())),
                                    },
                                  ),
                                  isLoggedIN == true
                                      ? ListTile(
                                          leading: Icon(Icons.logout),
                                          title: Text(isArabic(context)
                                              ? 'تسجيل خروج'
                                              : 'Sign out'),
                                          onTap: () => {
                                            AuthenticationService.signOut()
                                                .then((value) => {
                                                      Navigator.pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  const HomeScreen()))
                                                    }),
                                          },
                                        )
                                      : ListTile(),
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
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
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
                                    decoration: BoxDecoration(
                                        color: Colors.deepPurpleAccent),
                                    accountName: Text(
                                      isArabic(context)
                                          ? data.nameAr
                                          : data.nameEn,
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
                                      backgroundImage: Image.memory(
                                              base64Decode(userStore
                                                  .userModel.profilePicture))
                                          .image,
                                    ),
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.info_outline),
                                    title: Text(
                                        isArabic(context)
                                            ? 'تواصل معنا'
                                            : 'Contact us',
                                        style:
                                            TextStyle(fontFamily: 'SouqFont')),
                                    onTap: () => {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const ContactUs())),
                                    },
                                  ),
                                  ListTile(
                                    leading:
                                        Icon(Icons.contact_support_outlined),
                                    title: Text(
                                        isArabic(context)
                                            ? 'من نحن'
                                            : 'About us',
                                        style:
                                            TextStyle(fontFamily: 'SouqFont')),
                                    onTap: () => {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const AboutUs())),
                                    },
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.settings),
                                    title: Text(
                                        isArabic(context)
                                            ? 'الإعدادات'
                                            : 'Settings',
                                        style:
                                            TextStyle(fontFamily: 'SouqFont')),
                                    onTap: () => {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const SettingPage())),
                                    },
                                  ),
                                  isLoggedIN == true
                                      ? ListTile(
                                          leading: Icon(Icons.logout),
                                          title: Text(
                                              isArabic(context)
                                                  ? 'تسجيل خروج'
                                                  : 'Sign out',
                                              style: TextStyle(
                                                  fontFamily: 'SouqFont')),
                                          onTap: () => {
                                            AuthenticationService.signOut()
                                                .then((value) => {
                                                      Navigator.pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  const HomeScreen()))
                                                    }),
                                          },
                                        )
                                      : ListTile(),
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
                      CustomProfileAppBar(false),
                      profileHeader(),
                    ];
                  },
                  body: SafeArea(
                    child: Column(
                      children: <Widget>[
                        Material(
                          color: Colors.white,
                          child: TabBar(
                            labelColor: Colors.black,
                            unselectedLabelColor: Colors.black,
                            indicatorWeight:
                                MediaQuery.of(context).size.height * .002,
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
              bottomNavigationBar: roleId == 1
                  ? ConvexAppBar(
                      height: MediaQuery.of(context).size.height * 0.07,
                      style: TabStyle.textIn,
                      color: CupertinoColors.white,
                      backgroundColor: Colors.deepPurpleAccent,
                      items: [
                        TabItem(
                            icon: Icons.home,
                            title: isArabic(context) ? 'الرئيسية' : 'Home'),
                        TabItem(
                            icon: Icons.people,
                            title: isArabic(context) ? 'الحساب' : 'Profile'),
                      ],
                      initialActiveIndex: 1, //optional, default as 0
                      onTap: (int i) => {
                        if (i == 0)
                          {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeScreen()),
                            ),
                          }
                      },
                    )
                  : ConvexAppBar(
                      height: MediaQuery.of(context).size.height * 0.07,
                      style: TabStyle.fixedCircle,
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
                              MaterialPageRoute(
                                  builder: (context) => const HomeScreen()),
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

  bool isArabic(BuildContext context) {
    return context.locale.languageCode == 'ar';
  }

  Future<Store> loadStore(BuildContext context) async {
    late Store store;
    late UserModel user;

    try {
      print(FirebaseAuth.instance.currentUser?.email);
      await FirebaseFirestore.instance
          .collection('Users')
          .where('email', isEqualTo: FirebaseAuth.instance.currentUser?.email)
          .get()
          .then((value) => value.docs.forEach((doc) {
                user = UserModel.fromJson(value.docs.first.data());
                print(user.name);
              }));
    } on FirebaseException catch (e) {
      print(e);
    }
    ;

    DocumentSnapshot snap;
    await FirebaseFirestore.instance
        .collection('Store')
        .doc(user.storeId)
        .get()
        .then((value) => {
              snap = value,
              store = Store.fromSnapshot(snap),
              print(store.nameAr),
            });

    userStore = UserStore(user, store);
    storeName =
        isArabic(context) ? userStore.store.nameAr : userStore.store.nameEn;
    return store;
  }

  Future<UserModel> loadUser() async {
    late UserModel user;
    await FirebaseFirestore.instance
        .collection('Users')
        .where('email', isEqualTo: FirebaseAuth.instance.currentUser?.email)
        .get()
        .then((value) => value.docs.forEach((doc) {
              user = UserModel.fromJson(value.docs.first.data());
              print(user.name);
            }));

    return user;
  }
}
