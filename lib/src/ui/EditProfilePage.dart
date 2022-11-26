import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:souq/src/models/Store.dart';
import '../models/UserModel.dart';
import '../models/UserStore.dart';
import 'UserPrefrencesScreen.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

// late final FirebaseMessaging _messaging;
// PushNotification? _notificationInfo;
enum Branch { havebranch, nobranch }

class _EditProfileState extends State<EditProfile> {
  late UserStore? userStore;
  late UserModel user;
  Branch _branch = Branch.nobranch;
  bool isLoading = false;
  Timer? _timer;
  bool BranHidden = false;
  bool LocHidden = false;
  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    loadUser().then((value) => {
          // _usernameController.text = user.name,
          // _emailController.text = user.email,
          // _phoneController.text = user.phoneNumber,
          if (userStore != null)
            {
              // _DescriprionController.text = userStore!.store.descStore,
              // _LocationController.text = userStore!.store.locStore,
            },
          setState(() {
            isLoading = false;
          })
        });
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        automaticallyImplyLeading: false,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(15),
                bottomLeft: Radius.circular(15))),
        title: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 4,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(Icons.arrow_back_ios_new))
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 2,
              child: Row(
                children: [
                  Center(
                    child: Image.asset(
                      'assets/images/offerstorylogo.png',
                      height: MediaQuery.of(context).size.width * 0.4,
                      width: MediaQuery.of(context).size.width * 0.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Stack(children: [
        SingleChildScrollView(
            child: Column(children: [
          SizedBox(height: MediaQuery.of(context).size.height * .01),
          Align(
            alignment: isArabic(context)
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.width * 0.10,
                  left: MediaQuery.of(context).size.width * 0.02,
                  right: MediaQuery.of(context).size.width * 0.02,
                  bottom: MediaQuery.of(context).size.width * 0.02),
              child: isArabic(context)
                  ? const Text(
                      "تعديل وصف المتجر",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'SouqFont'),
                    )
                  : const Text(
                      "Edit Store Description",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'SouqFont'),
                    ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.02,
                right: MediaQuery.of(context).size.width * 0.02,
                bottom: MediaQuery.of(context).size.width * 0.02),
            child: TextField(
              //controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: isArabic(context)
                    ? '.. أدخل وصف المتجر هنا'
                    : 'Enter the description here ..',
                fillColor: Colors.transparent, //filled: true,
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Align(
            alignment: isArabic(context)
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.width * 0.05,
                  left: MediaQuery.of(context).size.width * 0.02,
                  right: MediaQuery.of(context).size.width * 0.02,
                  bottom: MediaQuery.of(context).size.width * 0.02),
              child: isArabic(context)
                  ? const Text(
                      "تعديل عنوان المتجر",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'SouqFont'),
                    )
                  : const Text(
                      "Edit Store Location",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'SouqFont'),
                    ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.02,
                right: MediaQuery.of(context).size.width * 0.02,
                bottom: MediaQuery.of(context).size.width * 0.02),
            child: TextField(
              //controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: isArabic(context)
                    ? '.. أدخل عنوان المتجر هنا'
                    : 'Enter the Location here ..',
                fillColor: Colors.transparent, //filled: true,
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.width * 0.05,
                left: MediaQuery.of(context).size.width * 0.3,
                right: MediaQuery.of(context).size.width * 0.02,
                bottom: MediaQuery.of(context).size.width * 0.02),
            child: Row(
              children: [
                IconButton(
                    onPressed: () {newBranch();}, icon: Icon(Icons.add_circle_outline)),
                TextButton(
                  onPressed: () { newBranch(); },
                  child:isArabic(context)
                    ? Text( "إضافة فرع",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SouqFont',color: Colors.black),
                      )
                    : Text(
                        "Add Branch",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SouqFont',color: Colors.black),
                      ),)
              ],
            ),
          ),
          // // Padding(
          // //   padding: EdgeInsets.only(
          // //     left: MediaQuery.of(context).size.width * 0.2,
          // //   ),
          // //   child: ListTile(
          // //     title: isArabic(context)
          // //         ? Text(
          // //             'ليس لدينا فرع آخر',
          // //             style: TextStyle(
          // //                 fontSize: 16,
          // //                 fontWeight: FontWeight.bold,
          // //                 fontFamily: 'SouqFont'),
          // //           )
          // //         : Text(
          // //             'No Other Branches',
          // //             style: TextStyle(
          // //                 fontSize: 16,
          // //                 fontWeight: FontWeight.bold,
          // //                 fontFamily: 'SouqFont'),
          // //           ),
          // //     leading: Radio(
          // //       fillColor: MaterialStateColor.resolveWith(
          // //           (states) => Colors.deepPurpleAccent),
          // //       focusColor: MaterialStateColor.resolveWith(
          // //           (states) => Colors.deepPurpleAccent),
          // //       value: Branch.nobranch,
          // //       groupValue: _branch,
          // //       onChanged: (Branch? Value) {
          // //         setState(() {
          // //           _branch = Value!;
          // //         });
          // //       },
          // //     ),
          // //   ),
          // // ),
          // // Padding(
          // //   padding: EdgeInsets.only(
          // //     left: MediaQuery.of(context).size.width * 0.2,
          // //   ),
          // //   child: ListTile(
          // //     title: isArabic(context)
          // //         ? Text(
          // //             'أكثر من فرع',
          // //             style: TextStyle(
          // //                 fontSize: 16,
          // //                 fontWeight: FontWeight.bold,
          // //                 fontFamily: 'SouqFont'),
          // //           )
          // //         : Text(
          // //             'Other Branches',
          // //             style: TextStyle(
          // //                 fontSize: 16,
          // //                 fontWeight: FontWeight.bold,
          // //                 fontFamily: 'SouqFont'),
          // //           ),
          // //     leading: Radio(
          // //       fillColor: MaterialStateColor.resolveWith(
          // //           (states) => Colors.deepPurpleAccent),
          // //       focusColor: MaterialStateColor.resolveWith(
          // //           (states) => Colors.deepPurpleAccent),
          // //       value: Branch.havebranch,
          // //       groupValue: _branch,
          // //       onChanged: (Branch? Value) {
          // //         setState(() {
          // //           _branch = Value!;
          // //          if(Branch.havebranch == Value) {
          // //            Row(children: [
          // //              IconButton(
          // //                  onPressed: () {
          // //                    Navigator.push(
          // //                      context,
          // //                      MaterialPageRoute(builder: (context) => profilepage()),
          // //                    );
          // //                  },
          // //                  icon: Icon(
          // //                    Icons.save_alt,
          // //                    color: Colors.white,
          // //                    size: MediaQuery.of(context).size.height * 0.035,
          // //                  ))
          // //            ]);
          // //          }
          // //         });
          // //       },
          // //     ),
          // //   ),
          // ),
        ]))
      ]),
    );
  }

  Widget newBranch() => Column(children: [
        SizedBox(height: MediaQuery.of(context).size.height * .01),
        Align(
            alignment: isArabic(context)
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.width * 0.04,
                left: MediaQuery.of(context).size.width * 0.02,
                right: MediaQuery.of(context).size.width * 0.02,
              ),
              child: TextFormField(
                textAlign: TextAlign.center,

                //    validator: _errorTextEN,
                //  controller: _nameEnController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  fillColor: Colors.transparent,
                  labelText: isArabic(context)
                      ? 'إسم الفرع الجديد'
                      : 'New Branch Name',
                ),
              ),
            )),
        Align(
          alignment:
              isArabic(context) ? Alignment.centerRight : Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.width * 0.05,
                left: MediaQuery.of(context).size.width * 0.02,
                right: MediaQuery.of(context).size.width * 0.02,
                bottom: MediaQuery.of(context).size.width * 0.02),
            child: isArabic(context)
                ? const Text(
                    " عنوان الفرع الجديد",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'SouqFont'),
                  )
                : const Text(
                    "Branch Location",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'SouqFont'),
                  ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.02,
              right: MediaQuery.of(context).size.width * 0.02,
              bottom: MediaQuery.of(context).size.width * 0.02),
          child: TextField(
//controller: _descriptionController,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: isArabic(context)
                  ? '.. أدخل عنوان المتجرالجديد هنا'
                  : 'Enter Branch Location Here ..',
              fillColor: Colors.transparent, //filled: true,
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ]);

  Future<UserModel> loadUser() async {
    DocumentSnapshot snap;
    late Store store;

    await FirebaseFirestore.instance
        .collection('Users')
        .where('email', isEqualTo: FirebaseAuth.instance.currentUser?.email)
        .get()
        .then((value) => value.docs.forEach((doc) {
              user = UserModel.fromJson(value.docs.first.data());
              print(user.name);
            }))
        .then((value) async => {
              if (user.storeId != '')
                {
                  await FirebaseFirestore.instance
                      .collection('Store')
                      .doc(user.storeId)
                      .get()
                      .then((value) => {
                            snap = value,
                            store = Store.fromSnapshot(snap),
                            print(store.nameAr),
                          }),
                  userStore = UserStore(user, store),
                }
              else
                {
                  userStore = null,
                }
            });

    return user;
  }
}
