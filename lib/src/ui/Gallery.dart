import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:souq/src/models/StoryItem.dart';
import '../models/Store.dart';
import '../models/UserModel.dart';
import '../models/UserStore.dart';

class Gallery extends StatefulWidget {
  final UserStore? searchStore;

  const Gallery({Key? key, this.searchStore}) : super(key: key);

  @override
  _GalleryState createState() => _GalleryState(searchStore);
}

class _GalleryState extends State<Gallery> {
  late OverlayEntry _popupDialog;
  late OverlayEntry _deleteDialog;
  late int roleId;
  final box = GetStorage();
  late UserStore userStore;
  String storeName = "Souq Story";
  final UserStore? searchStore;
  List<String> imageUrls = [];
  _GalleryState(this.searchStore);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (searchStore != null) {
      for (int i = 0; i < widget.searchStore!.store.stories.length; i++) {
        imageUrls.add(widget.searchStore!.store.stories[i].img);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    roleId = box.read("roleID") ?? 0;

    return Scaffold(
      body: widget.searchStore != null
          ? GridView.count(
              crossAxisCount: 3,
              childAspectRatio: .5,
              padding:
                  EdgeInsets.all(MediaQuery.of(context).size.height * .002),
              children: imageUrls
                  .map(_createGridTileWidget)
                  .toList()
                  .reversed
                  .toList(),
            )
          : roleId == 1
              ? FutureBuilder(
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
                        return GridView.count(
                          crossAxisCount: 3,
                          childAspectRatio: .5,
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.height * .002),
                          children:
                              imageUrls.map(_createGridTileWidget).toList(),
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
                        return GridView.count(
                          crossAxisCount: 3,
                          childAspectRatio: .5,
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.height * .002),
                          children: data.stories.length > 0
                              ? imageUrls
                                  .map(_createGridTileWidget)
                                  .toList()
                                  .reversed
                                  .toList()
                              : [Container()],
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
    );
  }

  Widget _createGridTileWidget(String url) => Builder(
        builder: (context) => GestureDetector(
          onTap: () {
            _popupDialog = _createPopupDialog(url);
            Overlay.of(context)!.insert(_popupDialog);
          },
          child: Image.memory(base64Decode(url), fit: BoxFit.cover),
        ),
      );

  OverlayEntry _createPopupDialog(String url) {
    return OverlayEntry(
      builder: (context) => AnimatedDialog(
        child: _createPopupContent(url),
      ),
    );
  }

  OverlayEntry _createDeleteDialog(String url) {
    return OverlayEntry(
      builder: (context) => AnimatedDialog(
        child: _createDeleteBox(url),
      ),
    );
  }

  Widget _createPhotoTitle() => Container(
        // width: double.infinity ,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IconButton(
                onPressed: () {
                  _popupDialog.remove();
                },
                icon: Icon(
                  Icons.close,
                  size: MediaQuery.of(context).size.height * 0.032,
                )),
            ListTile(
              leading: searchStore == null
                  ? CircleAvatar(
                      backgroundImage: Image.memory(
                              base64Decode(userStore.userModel.profilePicture),
                              fit: BoxFit.fitWidth)
                          .image,
                    )
                  : CircleAvatar(
                      backgroundImage: Image.memory(
                              base64Decode(
                                  searchStore!.userModel.profilePicture),
                              fit: BoxFit.fitWidth)
                          .image,
                    ),
              title: Text(
                widget.searchStore != null ? isArabic(context) ? widget.searchStore!.store.nameAr : widget.searchStore!.store.nameEn : storeName,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      );

  Widget _createPopupContent(String url) => Container(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.height * .01),
        child: ClipRRect(
          borderRadius:
              BorderRadius.circular(MediaQuery.of(context).size.height * .01),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _createPhotoTitle(),
              Image.memory(base64Decode(url), fit: BoxFit.cover),
              _createActionBar(url),
            ],
          ),
        ),
      );
  Widget _createActionBar(String url) => Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * .015),
      color: Colors.white,
      child: searchStore == null &&
              userStore.userModel.storeId == userStore.store.storeId
          ? GestureDetector(
              onTap: () {
                _deleteDialog = _createDeleteDialog(url);
                Overlay.of(context)!.insert(_deleteDialog);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isArabic(context) ? "حذف المنشور" : "Remove Post",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Icon(
                    Icons.delete_forever,
                    size: MediaQuery.of(context).size.height * 0.04,
                  )
                ],
              ),
            )
          : Container());

  Widget _createDeleteBox(String url) => Container(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.height * .01),
        child: ClipRRect(
          borderRadius:
              BorderRadius.circular(MediaQuery.of(context).size.height * .01),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.42,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.07),
                    child: SizedBox(
                      width: double.maxFinite,
                      height: MediaQuery.of(context).size.height / 4,
                      child: ListView(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              LimitedBox(
                                  maxHeight:
                                      MediaQuery.of(context).size.height * 0.15,
                                  maxWidth: MediaQuery.of(context).size.width,
                                  child:
                                      Image.asset('assets/images/delete.png')),
                            ],
                          ),
                          const Divider(),
                          ListTile(
                            title: Center(
                              child: Text(
                                isArabic(context)
                                    ? "هل أنت متأكد من حذف المنشور ؟"
                                    : "Are you sure to delete ? ",
                                style: TextStyle(fontSize: 17),
                              ),
                            ),
                          ),
                          ListTile(
                            title: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton(
                                    onPressed: () async {
                                      StoryContent storyContent = userStore
                                          .store.stories
                                          .where(
                                              (element) => element.img == url)
                                          .first;
                                      List<dynamic> list = [];
                                      list.add(storyContent.toJson());
                                      _deleteDialog.remove();
                                      _popupDialog.remove();
                                      await FirebaseFirestore.instance
                                          .collection('Store')
                                          .doc(userStore.store.storeId)
                                          .update({
                                        'Stories': FieldValue.arrayRemove(list)
                                      }).then((value) => {
                                                setState(() {}),
                                              });
                                    },
                                    child: Text(
                                        isArabic(context) ? "موافق" : "Ok")),
                                ElevatedButton(
                                    onPressed: () {
                                      _deleteDialog.remove();
                                    },
                                    child: Text(isArabic(context)
                                        ? "إلغاء"
                                        : "Cancel")),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
            ],
          ),
        ),
      );

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
    roleId = user.RoleID;
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

    print(store.stories.length);
    imageUrls.clear();
    store.stories.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    for (int i = 0; i < store.stories.length; i++) {
      imageUrls.add(store.stories[i].img);
    }
    print(imageUrls.length);
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
    roleId = user.RoleID;
    return user;
  }

  bool isArabic(BuildContext context) {
    return context.locale.languageCode == 'ar';
  }
}

class AnimatedDialog extends StatefulWidget {
  const AnimatedDialog({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  State<StatefulWidget> createState() => AnimatedDialogState();
}

class AnimatedDialogState extends State<AnimatedDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> opacityAnimation;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.easeOutExpo);
    opacityAnimation = Tween<double>(begin: 0.0, end: 0.6).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeOutExpo));

    controller.addListener(() => setState(() {}));
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(opacityAnimation.value),
      child: Center(
        child: FadeTransition(
          opacity: scaleAnimation,
          child: ScaleTransition(
            scale: scaleAnimation,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
