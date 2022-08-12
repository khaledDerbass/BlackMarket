import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../models/Store.dart';
import '../models/UserModel.dart';
import '../models/UserStore.dart';

class Gallery extends StatefulWidget {
  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  late OverlayEntry _popupDialog;
  late int roleId;
  final box = GetStorage();
  late UserStore userStore;
  String storeName = "Souq Story";

  List<String> imageUrls = [

  ];

  @override
  Widget build(BuildContext context) {
    roleId = box.read("roleID");
    return Scaffold(
      body: roleId == 1 ? FutureBuilder(
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
                padding: EdgeInsets.all(MediaQuery.of(context).size.height * .002),
                children: imageUrls.map(_createGridTileWidget).toList(),
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
      ) :
      FutureBuilder(
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
                padding: EdgeInsets.all(MediaQuery.of(context).size.height * .002),
                children: data.stories.length > 0 ? imageUrls.map(_createGridTileWidget).toList() : [Container()],
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
      onLongPress: () {
        _popupDialog = _createPopupDialog(url);
        Overlay.of(context)!.insert(_popupDialog);
      },
      onLongPressEnd: (details) => _popupDialog.remove(),
      child: Image.memory(base64Decode(url) ,fit: BoxFit.cover),

    ),
  );


  OverlayEntry _createPopupDialog(String url) {
    return OverlayEntry(
      builder: (context) => AnimatedDialog(
        child: _createPopupContent(url),
      ),
    );
  }
  Widget _createPhotoTitle() => Container(
      width: double.infinity,
      color: Colors.white,
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: Image.memory(base64Decode(userStore.userModel.profilePicture) ,fit: BoxFit.fitWidth).image,
        ),
        title: Text(
          storeName,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ));

  Widget _createActionBar() => Container(
    padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * .01),
    color: Colors.white,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Icon(
          Icons.favorite_border,
          color: Colors.black,
        ),
        Icon(
          Icons.chat_bubble_outline_outlined,
          color: Colors.black,
        ),
        Icon(
          Icons.send,
          color: Colors.black,
        ),
      ],
    ),
  );

  Widget _createPopupContent(String url) => Container(
    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.height * .01),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height * .01),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _createPhotoTitle(),
          Image.memory(base64Decode(url) ,fit: BoxFit.fitWidth),
          _createActionBar(),
        ],
      ),
    ),
  );

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
    roleId = user.RoleID;
    DocumentSnapshot snap;

    await FirebaseFirestore.instance.collection('Store').doc(user.storeId)
        .get().then((value) => {
      snap = value,
      store = Store.fromSnapshot(snap),
      print(store.nameAr),
    });

    userStore = UserStore(user, store);
    storeName = isArabic(context) ? userStore.store.nameAr : userStore.store.nameEn;

    print(store.stories.length);
    imageUrls.clear();
    for(int i = 0 ; i < store.stories.length ; i++){
      imageUrls.add(store.stories[i].img);
    }
    print(imageUrls.length);
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

