import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:souq/src/models/Store.dart';
import '../../Helpers/LoginHelper.dart';
import '../models/UserModel.dart';
import '../models/UserStore.dart';
import 'CustomProfileAppBar.dart';
import 'UserPrefrencesScreen.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

enum Branch { havebranch, nobranch }

class _EditProfileState extends State<EditProfile> {
  late UserStore? userStore;
  late UserModel user;
  TextEditingController _DescriprionController = TextEditingController();
  TextEditingController _LocationController = TextEditingController();

  Branch _branch = Branch.nobranch;
  bool isLoading = false;
  Timer? _timer;

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    loadUser().then((value) => {
          if (userStore != null)
            {
              _DescriprionController.text = userStore!.store.descStore,
              _LocationController.text = userStore!.store.locStore,
            },
          setState(() {
            isLoading = false;
          })
        });
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: NestedScrollView(
          headerSliverBuilder: (context, index) {
            return [
              CustomProfileAppBar(false),
            ];
          },
          body: Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.width * 0.05,
                left: MediaQuery.of(context).size.width * 0.02,
                right: MediaQuery.of(context).size.width * 0.02,
              ),
              child: SingleChildScrollView(
                  // context,
                  child: ListView(shrinkWrap: true, children: [
                Align(
                  alignment: isArabic(context)
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
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
                TextField(
                  controller: _DescriprionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    // labelText:userStore!.store.descStore,
                    fillColor: Colors.transparent, //filled: true,
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * .05),
                Align(
                  alignment: isArabic(context)
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
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
                TextField(
                  controller: _LocationController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    // labelText: userStore!.store.locStore,
                    fillColor: Colors.transparent, //filled: true,
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * .03),
                Padding(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.17,
                  ),
                  child: ListTile(
                    title: isArabic(context)
                        ? Text(
                            'ليس لدينا فرع آخر',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'SouqFont'),
                          )
                        : Text(
                            'No Other Branches',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'SouqFont'),
                          ),
                    leading: Radio(
                      fillColor: MaterialStateColor.resolveWith(
                          (states) => Colors.deepPurpleAccent),
                      focusColor: MaterialStateColor.resolveWith(
                          (states) => Colors.deepPurpleAccent),
                      value: Branch.nobranch,
                      groupValue: _branch,
                      onChanged: (Branch? Value) {
                        setState(() {
                          _branch = Value!;
                        });
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.17,
                  ),
                  child: ListTile(
                    title: isArabic(context)
                        ? Text(
                            'أكثر من فرع',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'SouqFont'),
                          )
                        : Text(
                            'Other Branches',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'SouqFont'),
                          ),
                    leading: Radio(
                      fillColor: MaterialStateColor.resolveWith(
                          (states) => Colors.deepPurpleAccent),
                      focusColor: MaterialStateColor.resolveWith(
                          (states) => Colors.deepPurpleAccent),
                      value: Branch.havebranch,
                      groupValue: _branch,
                      onChanged: (Branch? Value) {
                        setState(() {
                          _branch = Value!;
                          if (Branch.havebranch == Value) {
                            Padding(
                              padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.width * 0.05,
                                  left: MediaQuery.of(context).size.width * 0.3,
                                  right:
                                      MediaQuery.of(context).size.width * 0.02,
                                  bottom:
                                      MediaQuery.of(context).size.width * 0.02),
                              child: Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        newBranch();
                                      },
                                      icon: Icon(Icons.add_circle_outline)),
                                  TextButton(
                                    onPressed: () {
                                      newBranch();
                                    },
                                    child: isArabic(context)
                                        ? Text(
                                            "إضافة فرع",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'SouqFont',
                                                color: Colors.black),
                                          )
                                        : Text(
                                            "Add Branch",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'SouqFont',
                                                color: Colors.black),
                                          ),
                                  )
                                ],
                              ),
                            );
                          }
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * .10),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        maximumSize: Size(
                            MediaQuery.of(context).size.height * .24,
                            MediaQuery.of(context).size.height * .07),
                        minimumSize: Size(
                            MediaQuery.of(context).size.height * .24,
                            MediaQuery.of(context).size.height * .07),
                        primary: Colors.black,
                        shape: StadiumBorder(),
                      ),
                      onPressed: () async {
                        _timer?.cancel();
                        await EasyLoading.show(
                            status: 'loading...',
                            maskType: EasyLoadingMaskType.black,
                            dismissOnTap: false);
                        print(FirebaseAuth.instance.currentUser?.uid);
                        await FirebaseFirestore.instance
                            .collection('Users')
                            .where('email',
                                isEqualTo:
                                    FirebaseAuth.instance.currentUser?.email)
                            .get()
                            .then((value) => value.docs.forEach((doc) async {
                                  await FirebaseFirestore.instance
                                      .collection('Users')
                                      .doc(value.docs.first.id)
                                      .update({
                                    'email': FirebaseAuth
                                        .instance.currentUser?.email,
                                  }).then((value) async => {
                                            if (userStore != null)
                                              {
                                                await FirebaseFirestore.instance
                                                    .collection('Store')
                                                    .doc(userStore!
                                                        .store.storeId
                                                        .replaceAll(" ", ""))
                                                    .update({
                                                  'locStore':
                                                      _LocationController.text,
                                                  'descStore':
                                                      _DescriprionController
                                                          .text
                                                }),
                                              },
                                            _timer?.cancel(),
                                            await EasyLoading.dismiss(),
                                            LoginHelper.showSuccessAlertDialog(
                                                context,
                                                isArabic(context)
                                                    ? "تم تحديث معلومات الحساب بنجاح"
                                                    : "Account information has been updated successfully.")
                                          });
                                }));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                              isArabic(context)
                                  ? 'حفظ التعديل'
                                  : "Save changes",
                              style: TextStyle(
                                  fontFamily: 'SouqFont',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                          Icon(
                            Icons.save_alt,
                            color: Colors.white,
                          ),
                        ],
                      )),
                ])
              ]))),
        ));
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
