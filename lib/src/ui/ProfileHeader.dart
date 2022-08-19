import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../models/Store.dart';
import '../models/UserModel.dart';
import '../models/UserStore.dart';

class profileHeader extends StatelessWidget {
  final Store? searchStore;

  profileHeader({Key? key, this.searchStore}) : super(key: key);
  late int roleId;
  final box = GetStorage();
  late UserStore userStore;
  String storeName = "Souq Story";
  @override
  Widget build(BuildContext context) {
    roleId = box.read("roleID") ?? 0;
    print('rele for' + roleId.toString());
    return searchStore != null ?
    SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * .0,
          left: MediaQuery.of(context).size.height * .01,
          right: MediaQuery.of(context).size.height * .01,
          bottom: MediaQuery.of(context).size.height * .0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * .02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius:
                  MediaQuery.of(context).size.height * .06,
                  backgroundColor: Color(0xffe4eeee),
                  backgroundImage: Image.asset('assets/images/pic2.png').image,),

                Row(
                  children: [
                    Column(
                      children: [
                        Text(
                          searchStore?.stories.length.toString() ?? "0",
                          style: const TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 15,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          isArabic(context) ? 'العروض' : 'Offers',
                          style: const TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 12,
                            letterSpacing: .5,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.height *
                          .05,
                    ),
                    Column(
                      children: [
                        Text(
                          searchStore?.numOfFollowers.toString() ?? "0",
                          style: const TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 15,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          isArabic(context)
                              ? 'المتابعون'
                              : 'Followers',
                          style: const TextStyle(
                            decoration: TextDecoration.none,
                            letterSpacing: .5,
                            fontSize: 12,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.height *
                          .08,
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  height:
                  MediaQuery.of(context).size.height * .0,
                ),
                Padding(
                  padding:  EdgeInsets.all(MediaQuery.of(context).size.height *
                      0.02 ,),
                  child: Text(
                    isArabic(context) ? searchStore?.nameAr ?? "" : searchStore?.nameEn ?? "",
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      decoration: TextDecoration.none,
                      fontSize: 16,
                      letterSpacing: .5,
                    ),
                  ),
                ),
                Padding(
                  padding:  EdgeInsets.only(left: MediaQuery.of(context).size.height *
                      .1 ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      maximumSize: Size(
                          MediaQuery.of(context).size.height *
                              .20,
                          MediaQuery.of(context).size.height *
                              .04),
                      minimumSize: Size(
                          MediaQuery.of(context).size.height *
                              .20,
                          MediaQuery.of(context).size.height *
                              .04),
                      primary: Colors.black,
                    ),
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment:
                      CrossAxisAlignment.center,
                      children: const [
                        Text('Follow'),
                        Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height:
                  MediaQuery.of(context).size.height * .005,
                ),
              ],
            ),
          ],
        ),
      ),
    )
        : roleId == 2
        ? SliverToBoxAdapter(
            child: FutureBuilder(
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
                    return Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * .0,
                        left: MediaQuery.of(context).size.height * .01,
                        right: MediaQuery.of(context).size.height * .01,
                        bottom: MediaQuery.of(context).size.height * .0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * .02,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius:
                                    MediaQuery.of(context).size.height * .06,
                                backgroundColor: Color(0xffe4eeee),
                                backgroundImage: userStore.userModel.profilePicture.isNotEmpty ?
                                Image.memory(base64Decode(userStore.userModel.profilePicture)).image
                                : Image.asset('assets/images/pic2.png').image,),
                                 Padding(
                                  padding:  EdgeInsets.only(top: 0 ),
                                child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  maximumSize: Size(
                                      MediaQuery.of(context).size.height *
                                          .08,
                                      MediaQuery.of(context).size.height *
                                          .04),
                                  minimumSize: Size(
                                      MediaQuery.of(context).size.height *
                                          .08,
                                      MediaQuery.of(context).size.height *
                                          .04),
                                  primary: Colors.white,
                                ),
                                onPressed: () {},
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: const [
                                    Text(''),
                                    Icon(
                                      Icons.add,
                                      color: Colors.blue,
                                    ),
                                  ],
                                ),
                              ),
                              ),

                              Row(
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        data.stories.length.toString(),
                                        style: TextStyle(
                                          decoration: TextDecoration.none,
                                          fontSize: 15,
                                          letterSpacing: 1,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        isArabic(context) ? 'العروض' : 'Offers',
                                        style: TextStyle(
                                          decoration: TextDecoration.none,
                                          fontSize: 12,
                                          letterSpacing: .5,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.height *
                                        .05,
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        data.numOfFollowers.toString(),
                                        style: TextStyle(
                                          decoration: TextDecoration.none,
                                          fontSize: 15,
                                          letterSpacing: 1,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        isArabic(context)
                                            ? 'المتابعون'
                                            : 'Followers',
                                        style: TextStyle(
                                          decoration: TextDecoration.none,
                                          letterSpacing: .5,
                                          fontSize: 12,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.height *
                                        .08,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * .0,
                              ),
                              Padding(
                                padding:  EdgeInsets.all(MediaQuery.of(context).size.height *
                                    0.02 ,),
                                child: Text(
                                  storeName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    decoration: TextDecoration.none,
                                    fontSize: 16,
                                    letterSpacing: .5,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:  EdgeInsets.only(left: MediaQuery.of(context).size.height *
                                    .1 ),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    maximumSize: Size(
                                        MediaQuery.of(context).size.height *
                                            .20,
                                        MediaQuery.of(context).size.height *
                                            .04),
                                    minimumSize: Size(
                                        MediaQuery.of(context).size.height *
                                            .20,
                                        MediaQuery.of(context).size.height *
                                            .04),
                                    primary: Colors.black,
                                  ),
                                  onPressed: () {},
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: const [
                                      Text('Follow'),
                                      Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * .005,
                              ),
                            ],
                          ),
                        ],
                      ),
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
              future:  loadStore(context),
            ),
          )
        : SliverToBoxAdapter(
            child: FutureBuilder(
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
                    return Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * .0,
                        left: MediaQuery.of(context).size.height * .01,
                        right: MediaQuery.of(context).size.height * .01,
                        bottom: MediaQuery.of(context).size.height * .0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * .02,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius:
                                    MediaQuery.of(context).size.height * .06,
                                backgroundColor: Color(0xffe4eeee),
                                backgroundImage: data.profilePicture.isNotEmpty
                                    ? Image.memory(
                                            base64Decode(data.profilePicture))
                                        .image
                                    : Image.asset('assets/images/pic2.png')
                                        .image,
                              ),
                              Row(
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        data.followedStores.length.toString(),
                                        style: TextStyle(
                                          decoration: TextDecoration.none,
                                          fontSize: 15,
                                          letterSpacing: 1,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        isArabic(context)
                                            ? 'المتابعون'
                                            : 'Followers',
                                        style: TextStyle(
                                          decoration: TextDecoration.none,
                                          letterSpacing: .5,
                                          fontSize: 12,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.height *
                                        .15,
                                  ),
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * .02,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              data.name,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.none,
                                fontSize: 13,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * .005,
                          ),
                        ],
                      ),
                    );
                  }
                }

                // Displaying LoadingSpinner to indicate waiting state
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
              future: loadUser(),
            ),
          );
  }

  bool isArabic(BuildContext context) {
    return context.locale.languageCode == 'ar';
  }

  Future<Store> loadStore(BuildContext context) async {
    late Store store;
    late UserModel user;

    await FirebaseFirestore.instance
        .collection('Users')
        .where('email', isEqualTo: FirebaseAuth.instance.currentUser?.email)
        .get()
        .then((value) => value.docs.forEach((doc) {
              user = UserModel.fromJson(value.docs.first.data());
              print(user.name);
            }));

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
