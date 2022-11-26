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
import 'HandleScrollWidget.dart';

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
  final ScrollController _controller = ScrollController();

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
      resizeToAvoidBottomInset: false,
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
      body: !isLoading ? Container(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * .07,
            left: MediaQuery.of(context).size.height * .05,
            right: MediaQuery.of(context).size.height * .05,
          ),
          child: HandleScrollWidget(
            context,
            controller: _controller,
            child: ListView(
              controller: _controller,
              children: [
                TextField(
                  onChanged: (value) {},
                  controller: _emailController,
                  decoration:  InputDecoration(
                    fillColor: Colors.transparent,
                    labelText: isArabic(context) ? 'البريد الإلكتروني' : 'Email',
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

                 Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                  maximumSize: Size(
                  MediaQuery.of(context).size.height *
                      .24,
                    MediaQuery.of(context).size.height *
                        .07),
        minimumSize: Size(
            MediaQuery.of(context).size.height *
                .24,
            MediaQuery.of(context).size.height *
                .07),
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(isArabic(context)
                                  ? 'حفظ التعديل'
                                  : "Save changes", style: TextStyle(
                                  fontFamily: 'SouqFont',fontSize: 16,fontWeight: FontWeight.bold)),
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
