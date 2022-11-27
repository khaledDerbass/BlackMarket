import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:souq/Helpers/LoginHelper.dart';
import '../models/Store.dart';
import '../models/UserModel.dart';
import '../models/UserStore.dart';
import 'CustomProfileAppBar.dart';
import 'HandleScrollWidget.dart';

class UpdateAccountPage extends StatefulWidget {
  const UpdateAccountPage({Key? key}) : super(key: key);

  @override
  UpdateAccountPageState createState() => UpdateAccountPageState();
}

class UpdateAccountPageState extends State<UpdateAccountPage> {
  TextEditingController _StoreNameArController = TextEditingController();
  TextEditingController _StoreNameEnController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  TextEditingController _DescriprionController = TextEditingController();
  TextEditingController _LocationController = TextEditingController();
  GlobalKey<FormState> _form = GlobalKey<FormState>();
  final ScrollController _controller = ScrollController();

  late UserStore? userStore;
  late UserModel user;
  bool isLoading = false;
  Timer? _timer;
  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    loadUser().then((value) => {
          _usernameController.text = user.name,
          _emailController.text = user.email,
          _phoneController.text = user.phoneNumber,
          if (userStore != null)
            {
        _StoreNameArController.text = userStore!.store.nameAr,
 _StoreNameEnController.text = userStore!.store.nameEn,
              _DescriprionController.text = userStore!.store.descStore,
              _LocationController.text = userStore!.store.locStore,
            },
          setState(() {
            isLoading = false;
          })
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: NestedScrollView(
        headerSliverBuilder: (context, index) {
      return [
        CustomProfileAppBar(false),
      ];
    },
      body: !isLoading
          ? Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * .01,
                left: MediaQuery.of(context).size.height * .05,
                right: MediaQuery.of(context).size.height * .05,
              ),
              child: SingleChildScrollView(
               // context,
                controller: _controller,
                child: ListView(
                  controller: _controller,
                    shrinkWrap: true,
                  children: [
                    TextField(
                      onChanged: (value) {},
                      controller: _emailController,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'SouqFont'),
                      decoration: InputDecoration(
                        fillColor: Colors.transparent,
                        labelText:
                            isArabic(context) ? 'البريد الإلكتروني' : 'Email',
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * .05),
                    TextFormField(
                      controller: _phoneController,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'SouqFont'),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r"[0-9]"),
                        )
                      ],
                      decoration: InputDecoration(
                        labelText:
                            isArabic(context) ? 'رقم الهاتف' : 'Phone Number',
                      ),
                    ),
                    userStore == null ?
                    SizedBox(height: MediaQuery.of(context).size.height * .05): Container(),
                    userStore == null ? TextFormField(
                      controller: _usernameController,

                        style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'SouqFont'),
                      decoration: InputDecoration(
                        labelText: isArabic(context) ? 'الإسم' : 'Username',
                       ),
                    ): Container(),
                    userStore != null ? UserStoreFields() : Container(),
                    SizedBox(height: MediaQuery.of(context).size.height * .07),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                                      isEqualTo: FirebaseAuth
                                          .instance.currentUser?.email)
                                  .get()
                                  .then((value) =>
                                      value.docs.forEach((doc) async {
                                        await FirebaseFirestore.instance
                                            .collection('Users')
                                            .doc(value.docs.first.id)
                                            .update({
                                          'email': _emailController.text,
                                          'phoneNumber': _phoneController.text,
                                          'name': _usernameController.text
                                        }).then((value) async => {
                                                  if (userStore != null)
                                                    {
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection('Store')
                                                          .doc(userStore!
                                                              .store.storeId
                                                              .replaceAll(
                                                                  " ", ""))
                                                          .update({
                                                        'NameAr':_StoreNameArController.text,
                                                        'NameEn':_StoreNameEnController.text,
                                                        'locStore': _LocationController
                                                                .text,
                                                        'descStore': _DescriprionController
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
                      ],
                    ),
                  ],
                ),
              ))
          : Center(
              child: CircularProgressIndicator(),
            ),

        ));
  }

  bool isArabic(BuildContext context) {
    return context.locale.languageCode == 'ar';
  }

  Widget UserStoreFields() {
    return Column(children: [
      SizedBox(height: MediaQuery.of(context).size.height * .05),
      TextFormField(
        controller: _StoreNameArController,   style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          fontFamily: 'SouqFont'),
        decoration: InputDecoration(
          labelText: isArabic(context) ? 'الإسم العربي' : 'Arabic Name',
        ),
      ),
      SizedBox(height: MediaQuery.of(context).size.height * .05),
      TextFormField(
        controller: _StoreNameEnController,   style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          fontFamily: 'SouqFont'),
        decoration: InputDecoration(
          labelText: isArabic(context) ? 'الإسم الانجليزي' : 'English Name',
        ),
      ),
      SizedBox(height: MediaQuery.of(context).size.height * .05),
      TextFormField(
        controller: _DescriprionController,   style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          fontFamily: 'SouqFont'),
        decoration: InputDecoration(
          labelText: isArabic(context) ? 'وصف المتجر' : 'Store Description',
        ),
      ),
      SizedBox(height: MediaQuery.of(context).size.height * .05),
      TextFormField(
        controller: _LocationController,   style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          fontFamily: 'SouqFont'),
        decoration: InputDecoration(
          labelText: isArabic(context) ? 'موقع المتجر' : 'Store Location',
        ),
      )
    ]);
  }

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

  Future changeUserPassword(String newPassword) async {
    late UserModel user;
    await FirebaseFirestore.instance
        .collection('Users')
        .where('email', isEqualTo: FirebaseAuth.instance.currentUser?.email)
        .get()
        .then((value) => value.docs.forEach((doc) async {
              user = UserModel.fromJson(value.docs.first.data());
              user.password = newPassword;
              await FirebaseFirestore.instance
                  .collection('Users')
                  .doc(value.docs.first.id)
                  .update(user.toJson());
            }));

    return user;
  }
}
