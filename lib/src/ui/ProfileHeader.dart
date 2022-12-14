import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:souq/Helpers/LoginHelper.dart';
import 'package:souq/src/Services/AuthenticationService.dart';
import 'package:souq/src/ui/UserPrefrencesScreen.dart';
import '../models/Store.dart';
import '../models/UserModel.dart';
import '../models/UserStore.dart';
import 'EditProfilePage.dart';

class profileHeader extends StatefulWidget {
  final UserStore? searchStore;
  final UserModel? currentUser;
  profileHeader({Key? key, this.searchStore,this.currentUser}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return profileHeaderState(searchStore,currentUser);

  }
}

class profileHeaderState extends State<profileHeader>{
  late int roleId;
  final box = GetStorage();
  late UserStore userStore;
  String storeName = "Souq Story";
  String storeDesc = "";
  String storeLoc = "";
  Timer? _timer;
  UserStore? searchStore;
  profileHeaderState(this.searchStore,currentUser);
  bool isFollowing = false;
  XFile? imageFile;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    roleId = box.read("roleID") ?? 0;
    if(widget.currentUser!=null){
      for(int i = 0 ; i < widget.currentUser!.followedStores.length ; i++){
        widget.currentUser!.followedStores[i] = widget.currentUser!.followedStores[i].replaceAll(" ", "");
        if(widget.currentUser!.followedStores[i] == widget.searchStore!.store.storeId){
           setState(() {
             isFollowing = true;
           });
        }
      }
    }
    //     ?????? ?????????? ?????????? /////////////////////////////////////////////////////////////////////////////////////
    return widget.searchStore != null ?
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
                  backgroundImage: widget.searchStore!.userModel.profilePicture.isNotEmpty ?
                  Image.memory(base64Decode(widget.searchStore!.userModel.profilePicture)).image
                      : Image.asset('assets/images/pic2.png').image,),
                Row(
                  children: [
                    Column(
                      children: [
                        Text(
                          widget.searchStore?.store.stories.length.toString() ?? "0",
                          style: const TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 15,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          isArabic(context) ? '????????????' : 'Offers',
                          style: const TextStyle(
                            decoration: TextDecoration.none,
                            letterSpacing: 1,
                            fontSize: 12,fontFamily: 'SouqFont',
                            fontWeight: FontWeight.w700,
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
                          widget.searchStore?.store.numOfFollowers.toString() ?? "0",
                          style: const TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 15,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          isArabic(context)
                              ? '??????????????????'
                              : 'Followers',
                          style: const TextStyle(
                            decoration: TextDecoration.none,
                            letterSpacing:1,
                            fontSize: 12,fontFamily: 'SouqFont',
                            fontWeight: FontWeight.w700,
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
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    LimitedBox(
                        maxWidth: MediaQuery.of(context).size.width * 0.93,
                        child: Padding(
                          padding:  EdgeInsets.only(
                            left: MediaQuery.of(context).size.height *
                              0.001 ,
                            right: MediaQuery.of(context).size.height *
                                0.04 ,
                            top: MediaQuery.of(context).size.height *
                                0.02 ,),
                        child: Text(
                          isArabic(context) ? widget.searchStore?.store.nameAr ?? "" : widget.searchStore?.store.nameEn ?? "",
                          maxLines: 2, style: TextStyle(
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'SouqFont',
                          fontSize: 18,
                          letterSpacing: .5,
                        ),
                        ),
                      ),
                    ),
                    widget.searchStore?.userModel.email != AuthenticationService.getAuthInstance().currentUser?.email ?
                    Padding(
                      padding:  EdgeInsets.only(right:MediaQuery.of(context).size.height *
                          .039 ),
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
                        onPressed: () async {
                          if(AuthenticationService.isCurrentUserLoggedIn() == false){
                            LoginHelper.showLoginAlertDialog(context);
                          }else{
                            if(isFollowing){
                              print("Unfollow");
                              UserModel user = widget.currentUser!;
                              Store store = widget.searchStore!.store;
                              setState(() {
                                isFollowing = false;
                                user.followedStores.remove(store.storeId);
                                store.numOfFollowers -=1;
                                if(store.numOfFollowers <0){
                                  store.numOfFollowers = 0;
                                }
                              });
                              await FirebaseFirestore.instance.collection('Users').where('email' , isEqualTo: FirebaseAuth.instance.currentUser!.email).get().then((value) async => {
                                print("1"),
                                await FirebaseFirestore.instance.collection('Users').doc(value.docs.first.id).update(
                                    {
                                      'followedStores':FieldValue.arrayRemove([store.storeId])
                                    }).then((value) async => {
                                  print("2"),
                                  await FirebaseFirestore.instance.collection('Store').doc(widget.searchStore?.store.storeId.trim()).update({'numOfFollowers': store.numOfFollowers})
                                }),
                              });
                            }
                            else{
                              print("follow");
                              UserModel user = widget.currentUser!;
                              Store store = widget.searchStore!.store;
                              setState(() {
                                isFollowing = true;
                                user.followedStores.add(store.storeId.replaceAll(" ", ""));
                                store.numOfFollowers +=1;
                              });
                              await FirebaseFirestore.instance.collection('Users').where('email' , isEqualTo: FirebaseAuth.instance.currentUser!.email).get().then((value) async => {
                                await FirebaseFirestore.instance.collection('Users').doc(value.docs.first.id).update(
                                    {
                                      'followedStores':FieldValue.arrayUnion(user.followedStores)
                                    }).then((value) async => {

                                  await FirebaseFirestore.instance.collection('Store').doc(widget.searchStore?.store.storeId.trim()).update({'numOfFollowers': store.numOfFollowers})

                                }),
                              });


                            }

                          }
                        },

                        child: !isFollowing?
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment:
                          CrossAxisAlignment.center,
                          children:  [

                            Text(isArabic(context) ? '????????????':'Follow',style: TextStyle(
                                fontFamily:'SouqFont'
                            ),),
                            const Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ],
                        ) :
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment:
                          CrossAxisAlignment.center,
                          children:  [

                            Text(isArabic(context) ? '?????????? ????????????????':'Unfollow',style: TextStyle(
                                fontFamily:'SouqFont'
                            ),),
                            const Icon(
                              Icons.remove_circle_outline,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ) : Container(),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    LimitedBox(
                      maxWidth: MediaQuery.of(context).size.width * 0.8,
                      child: Padding(
                        padding:   EdgeInsets.only(left: MediaQuery.of(context).size.height *
                            0.02 ,
                          right: MediaQuery.of(context).size.height *
                              0.02 ,
                          top: MediaQuery.of(context).size.height *
                              0.02 ,),
                        child: Text(
                          widget.searchStore!.store.descStore,maxLines: 3,
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            decoration: TextDecoration.none,
                            fontSize:12,
                            letterSpacing: .5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    LimitedBox(
                      maxWidth: MediaQuery.of(context).size.width * 0.8,
                      child: Padding(
                        padding:   EdgeInsets.only(left: MediaQuery.of(context).size.height *
                            0.02 ,
                          right: MediaQuery.of(context).size.height *
                              0.02 ,
                          top: MediaQuery.of(context).size.height *
                              0.02 ,),
                        child: Text(
                          widget.searchStore!.store.locStore,maxLines: 3,
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            decoration: TextDecoration.none,
                            fontSize:12,
                            letterSpacing: .5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  height:
                  MediaQuery.of(context).size.height * .005,
                ),
              ],
            ),
          ],
        )),

    )
        : roleId == 2
    //     ?????? ???????????? ???????????? /////////////////////////////////////////////////////////////////////////////////////

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
                        Stack(
                          children: [
                            CircleAvatar(
                              radius:
                              MediaQuery.of(context).size.height * .06,
                              backgroundColor: Color(0xffe4eeee),
                              backgroundImage: userStore.userModel.profilePicture.isNotEmpty ?
                              Image.memory(base64Decode(userStore.userModel.profilePicture)).image
                                  : Image.asset('assets/images/pic2.png').image,),
                            Positioned(
                              top: 65,
                              left: 70,
                              child: SizedBox.fromSize(
                                size: Size(MediaQuery.of(context).size.height * .03, MediaQuery.of(context).size.height * .03), // button width and height
                                child: ClipOval(
                                  child: Material(
                                    color: Colors.black, // button color
                                    child: InkWell(
                                      splashColor: Colors.green, // splash color
                                      onTap: () async{

                                        print(AuthenticationService.getAuthInstance().currentUser?.uid);
                                        Uint8List? bytes;
                                        String img;
                                        File? file;

                                        XFile compressedImage;
                                        _showChoiceDialog(context).then((value) async => {
                                        _timer?.cancel(),
                                            await EasyLoading.show(
                                            status: 'loading...',
                                            maskType: EasyLoadingMaskType.black,
                                            dismissOnTap: false
                                        ),
                                        file = await compressFile(File(imageFile!.path)),
                                          print("Size before : ${File(imageFile!.path).lengthSync()}"),
                                          print("Size After : ${File(file!.path).lengthSync()}"),
                                          compressedImage = XFile(file!.path),
                                           bytes = await compressedImage.readAsBytes(),
                                          img= base64Encode(bytes!),
                                            userStore.userModel.profilePicture = img,
                                            await FirebaseFirestore.instance.collection('Users').where('email' , isEqualTo: FirebaseAuth.instance.currentUser!.email).get().then((value) async => {
                                            await FirebaseFirestore.instance.collection('Users').doc(value.docs.first.id).
                                            update(
                                              {
                                                'profilePicture':img
                                              }
                                              ).then((value) async => {
                                                LoginHelper.showSuccessAlertDialog(context, isArabic(context) ? "???? ?????????? ???????????? ?????????????? ??????????" : "Your profile photo has been changed successfully."),
                                              _timer?.cancel(),
                                              await EasyLoading.dismiss(),
                                            setState(() {


                                            })
                                            }),
                                        }),

                                        });

                                      }, // button pressed
                                      child: FittedBox(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(Icons.add, color: Colors.white,), // icon
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
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
                                  isArabic(context) ? '????????????' : 'Offers',
                                  style: TextStyle(
                                    decoration: TextDecoration.none,
                                    fontSize: 12,
                                    letterSpacing: 1,fontFamily: 'SouqFont',
                                    fontWeight: FontWeight.w700,                                  ),
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
                                      ? '??????????????????'
                                      : 'Followers',
                                  style: TextStyle(
                                    decoration: TextDecoration.none,
                                    letterSpacing: 1,
                                    fontSize: 12,fontFamily: 'SouqFont', fontWeight: FontWeight.w700,
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
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            LimitedBox(
                              maxWidth: MediaQuery.of(context).size.width * 0.93,
                              child: Padding(     padding:  EdgeInsets.only(
                                left: MediaQuery.of(context).size.height *
                                0.01 ,
                                right: MediaQuery.of(context).size.height *
                                0.04 ,
                                top: MediaQuery.of(context).size.height *
                                0.02 ,),
                                child: Text(
                                  storeName,maxLines: 2,
                                  style: TextStyle(
                                    decoration: TextDecoration.none,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'SouqFont',
                                    fontSize: 16,
                                    letterSpacing: .005,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            LimitedBox(
                              maxWidth: MediaQuery.of(context).size.width * 0.8,
                              child: Padding(
                                padding:
                                EdgeInsets.only(left: MediaQuery.of(context).size.height *
                                    0.002 ,
                                  right: MediaQuery.of(context).size.height *
                                      0.02 ,
                                  top: MediaQuery.of(context).size.height *
                                      0.02 ,),
                                child: Text(
                                  storeDesc,maxLines: 3,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    decoration: TextDecoration.none,
                                    fontSize:12,
                                    letterSpacing: .5,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            LimitedBox(
                              maxWidth: MediaQuery.of(context).size.width * 0.8,
                              child: Padding(
                                padding:   EdgeInsets.only(left: MediaQuery.of(context).size.height *
                                    0.002 ,
                                  right: MediaQuery.of(context).size.height *
                                      0.02 ,
                                  top: MediaQuery.of(context).size.height *
                                      0.02 ,),
                                child: Text(
                                  storeLoc,maxLines: 3,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    decoration: TextDecoration.none,
                                    fontSize:12,
                                    letterSpacing: .5,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height:  MediaQuery.of(context).size.height * .015,
                        ),
                        actions(context),
                        userStore.userModel.storeId != userStore.store.storeId ?
///
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
                                Text('Follow',style: TextStyle(
                                  fontFamily:'SouqFont'
                                  ),
                                  ),
                                Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        )
                            : Container(),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .005,
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

    //     ?????? ????????????  ////////////////////////////////////////////////////////////////////////////////////
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
                  style: TextStyle(fontSize: 18,fontFamily: 'SouqFont'),
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
                                      ? '??????????????????'
                                      : 'Following',
                                  style: TextStyle(
                                    decoration: TextDecoration.none,
                                    letterSpacing: .5,
                                    fontSize: 12,fontFamily: 'SouqFont'
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
                    LimitedBox(
                      maxWidth: MediaQuery.of(context).size.width * 0.3,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          data.name,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.none,
                            fontSize:16,
                            letterSpacing: 0.5,fontFamily: 'SouqFont'
                          ),
                        ),
                      ),
                    ),
                    // SizedBox(
                    //   height: MediaQuery.of(context).size.height * .005,
                    // ),
                    // ???? ?????????? ????????????/////////////////////////////////////////////////////////////////////////////////////
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
  Future<File?> compressFile(File file) async {
    final filePath = file.absolute.path;

    final lastIndex = filePath.lastIndexOf(RegExp(r'.jp'));
    final splitted = filePath.substring(0, (lastIndex));
    final outPath = "${splitted}_out${filePath.substring(lastIndex)}";
    var result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path, outPath,
        quality: 50,
        minHeight: 700,
        minWidth: 700
    );

    print(file.lengthSync());
    print(result?.lengthSync());

    return result;
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: ListBody(
              children: [
                Divider(
                  height: MediaQuery.of(context).size.height * .01,
                  color: Colors.deepPurpleAccent,
                ),
                ListTile(
                  onTap: () {
                    _openGallery(context);
                  },
                  title: Text(isArabic(context) ? '??????????????????' : 'Gallery'),
                  leading: Icon(
                    Icons.account_box,
                    color: Colors.deepPurpleAccent,
                  ),
                ),
                Divider(
                  height: 1,
                  color: Colors.deepPurpleAccent,
                ),
                ListTile(
                  onTap: () {
                    _openCamera(context);
                  },
                  title: Text(isArabic(context) ? '????????????????' : 'Camera'),
                  leading: Icon(
                    Icons.camera,
                    color: Colors.deepPurpleAccent,
                  ),
                ),
              ],
            ),
          );
        });
  }
  void _openGallery(BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery
    );
    setState(() {
      imageFile = pickedFile!;
    });

    Navigator.pop(context);
  }

  void _openCamera(BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      imageFile = pickedFile!;
    });

    Navigator.pop(context);
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
    }));

    DocumentSnapshot snap;

    await FirebaseFirestore.instance
        .collection('Store')
        .doc(user.storeId)
        .get()
        .then((value) => {
      snap = value,
      store = Store.fromSnapshot(snap),
    });

    userStore = UserStore(user, store);
    storeName =
    isArabic(context) ? userStore.store.nameAr : userStore.store.nameEn;
     storeDesc = userStore.store.descStore;
     storeLoc = userStore.store.locStore;
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
    }));

    return user;
  }


}

Widget actions(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: OutlinedButton(
          // child: Padding(
           // padding: const EdgeInsets.symmetric(horizontal: 4),
            child: isArabic(context)?Text("?????????? ?????????? ????????????", style: TextStyle(color: Colors.black,fontWeight:FontWeight.bold,fontFamily: 'SouqFont',
              fontSize: 16,letterSpacing: .5,
            ))
                :Text("Edit Profile", style: TextStyle(color: Colors.black,fontWeight:FontWeight.bold,fontFamily: 'SouqFont',
                fontSize: 18,                                    letterSpacing: .5,
            )),

          style: OutlinedButton.styleFrom(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              minimumSize: Size(0, 30),
              side: BorderSide(
                color: Colors.grey,
              )),
          onPressed: () {
              Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                const EditProfile()),
          );
              },
        ),
      ),
    ],
  );
}