import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:souq/Helpers/LoginHelper.dart';
import 'package:souq/src/Services/AuthenticationService.dart';
import '../models/Store.dart';
import '../models/UserModel.dart';
import '../models/UserStore.dart';
import 'CustomProfileAppBar.dart';
import 'changePasswordUi.dart';

class UpdateAccountPage extends StatefulWidget
{
  const UpdateAccountPage({Key? key}) : super(key: key);

  @override
  UpdateAccountPageState createState() => UpdateAccountPageState();
}

class UpdateAccountPageState extends State<UpdateAccountPage> {
  TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  TextEditingController _DescriprionController = TextEditingController();
  TextEditingController _LocationController = TextEditingController();
  GlobalKey<FormState> _form = GlobalKey<FormState>();
  late UserStore? userStore;
  late UserModel user;
  bool isLoading = false;
  Timer? _timer;
  @override
  void initState()  {
    setState(() {
      isLoading =true;
    });
     loadUser().then((value) => {
       _usernameController.text = user.name,
       _emailController.text = user.email,
       _phoneController.text = user.phoneNumber,
       if(userStore != null){
         _DescriprionController.text = userStore!.store.descStore,
         _LocationController.text = userStore!.store.locStore,
       },
     setState(() {
     isLoading =false;
     })
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
      backgroundColor: Colors.deepPurpleAccent,
      automaticallyImplyLeading: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(25),
              bottomLeft: Radius.circular(25))),
      title: Center(
        child: Text(isArabic(context) ? 'تعديل معلومات الحساب' : "Edit Account Info",style: TextStyle(
            fontFamily:'SouqFont')),
      ),
    ),
      body: !isLoading ? Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * .07,
          left: MediaQuery.of(context).size.height * .05,
          right: MediaQuery.of(context).size.height * .05,
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    onChanged: (value) {},
                    controller: _usernameController,
                    decoration:  InputDecoration(
                      fillColor: Colors.transparent,
                      labelText: isArabic(context) ? 'اسم المستخدم' : 'Username',
                      filled: true,
                    ),
                  ),
                  SizedBox(
                      height:
                      MediaQuery
                          .of(context)
                          .size
                          .height * .03),
                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText:
                      isArabic(context) ? 'رقم الهاتف' : 'Phone Number',
                    ),
                  ),
                  SizedBox(
                      height:
                      MediaQuery
                          .of(context)
                          .size
                          .height * .05),
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: isArabic(context)
                          ? 'اسم المستخدم'
                          : 'Username',
                    ),
                  ),
                  SizedBox(
                      height:
                      MediaQuery
                          .of(context)
                          .size
                          .height * .05),

                  userStore != null ? TextFormField(
                    controller: _DescriprionController,
                    decoration: InputDecoration(
                      labelText:
                      isArabic(context) ? 'وصف المتجر' : 'Store Description',
                    ),
                  ) : Container(),
                  userStore != null ? SizedBox(
                      height:
                      MediaQuery
                          .of(context)
                          .size
                          .height * .05) : Container(),
                  userStore != null ? TextFormField(
                    controller: _LocationController,
                    decoration: InputDecoration(
                      labelText:
                      isArabic(context) ? 'موقع المتجر' : 'Store Location',
                    ),
                  ) : Container(),
                  SizedBox(
                      height:
                      MediaQuery
                          .of(context)
                          .size
                          .height * .10),
                  FittedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              maximumSize: Size(
                                  MediaQuery
                                      .of(context)
                                      .size
                                      .height *
                                      .2,
                                  MediaQuery
                                      .of(context)
                                      .size
                                      .height *
                                      .08),
                              minimumSize: Size(
                                  MediaQuery
                                      .of(context)
                                      .size
                                      .height *
                                      .2,
                                  MediaQuery
                                      .of(context)
                                      .size
                                      .height *
                                      .08),
                              primary: Colors.black,
                              shape: StadiumBorder(),
                            ),
                            onPressed: () async {
                              _timer?.cancel();
                              await EasyLoading.show(
                                  status: 'loading...',
                                  maskType: EasyLoadingMaskType.black,
                                  dismissOnTap: false
                              );
                              print(FirebaseAuth.instance.currentUser?.uid);
                              await FirebaseFirestore.instance
                                  .collection('Users')
                                  .where('email', isEqualTo: FirebaseAuth.instance.currentUser?.email)
                                  .get()
                                  .then((value) => value.docs.forEach((doc) async {
                                await FirebaseFirestore.instance.collection('Users').doc(value.docs.first.id).update({'email' : _emailController.text,'phoneNumber': _phoneController.text,'name' : _usernameController.text}).then((value) async => {
                                  if(userStore !=null){
                                    await FirebaseFirestore.instance.collection('Store').doc(userStore!.store.storeId.replaceAll(" ", "")).update({'locStore' : _LocationController.text,'descStore' : _DescriprionController.text}),
                                  },
                                  _timer?.cancel(),
                                  await EasyLoading.dismiss(),
                                  LoginHelper.showSuccessAlertDialog(context, isArabic(context)? "تم تحديث معلومات الحساب بنجاح"  : "Account information has been updated successfully.")
                                });
                              }));


                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(isArabic(context)
                                    ? 'حفظ'
                                    : "Save", style: TextStyle(
                                    fontFamily: 'SouqFont')),
                                Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
      ): Center(child: CircularProgressIndicator(),),
    );
  }

  bool isArabic(BuildContext context) {
    return context.locale.languageCode == 'ar';
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
    })).then((value) async => {
      if(user.storeId != ''){
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
      }else{
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
      await  FirebaseFirestore.instance.collection('Users').doc(value.docs.first.id).update(user.toJson());
    }));

    return user;
  }
}
