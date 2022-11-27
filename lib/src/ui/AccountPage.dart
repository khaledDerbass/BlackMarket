import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:souq/src/ui/UpdateAccountInfo.dart';
import '../models/Store.dart';
import '../models/UserModel.dart';
import '../models/UserStore.dart';
import 'CustomProfileAppBar.dart';
import 'changePasswordUi.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  AccountPageState createState() => AccountPageState();
}

class AccountPageState extends State<AccountPage> {
  TextEditingController _StoreNameArController = TextEditingController();
  TextEditingController _StoreNameEnController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  TextEditingController _DescriprionController = TextEditingController();
  TextEditingController _LocationController = TextEditingController();
  GlobalKey<FormState> _form = GlobalKey<FormState>();
  late UserStore? userStore;
  @override
  void initState() {
    // TODO: implement initState
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
          body: FutureBuilder(
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
                  _usernameController.text = data.name;
                  _emailController.text = data.email;
                  _phoneController.text = data.phoneNumber;
                  if (userStore != null) {
                    _StoreNameArController.text = userStore!.store.nameAr;
              _StoreNameEnController.text = userStore!.store.nameEn;
                    _DescriprionController.text = userStore!.store.descStore;
                    _LocationController.text = userStore!.store.locStore;
                  }
                  return Container(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * .01,
                      left: MediaQuery.of(context).size.height * .05,
                      right: MediaQuery.of(context).size.height * .05,
                    ),
                    child: Form(
                      key: _form,
                          child: SingleChildScrollView(
                            child: ListView(
                              shrinkWrap: true,
                              children: [
                          TextFormField(
                            readOnly: true,
                            controller: _emailController,   style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'SouqFont'),
                            decoration: InputDecoration(
                              fillColor: Colors.transparent,
                              enabled: false,
                              labelText: isArabic(context)
                                  ? 'البريد الإلكتروني'
                                  : 'Email',
                            ),
                          ),
                          SizedBox(
                              height: MediaQuery.of(context).size.height * .03),
                          TextFormField(
                            readOnly: true,
                            controller: _phoneController,   style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'SouqFont'),
                            decoration: InputDecoration(
                              fillColor: Colors.transparent,
                              enabled: false,
                              labelText: isArabic(context)
                                  ? 'رقم الهاتف'
                                  : 'Phone Number',
                            ),
                          ),
                          userStore == null ?
                          SizedBox(
                              height: MediaQuery.of(context).size.height * .03): Container(),
                          userStore == null ?  TextFormField(
                            readOnly: true,
                            enabled: false,
                            controller: _usernameController,   style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'SouqFont'),
                            decoration: InputDecoration(
                              enabled: false,
                              fillColor: Colors.transparent,
                              labelText: isArabic(context)
                                  ? 'اسم المستخدم'
                                  : 'Username',
                            ),
                          ): Container(),
                          userStore != null ? UserStoreFields() : Container(),

                          SizedBox(
                              height: MediaQuery.of(context).size.height * .07),
                 Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        maximumSize: Size(
                                            MediaQuery.of(context).size.height *
                                                .25,
                                            MediaQuery.of(context).size.height *
                                                .06),
                                        minimumSize: Size(
                                            MediaQuery.of(context).size.height *
                                                .25,
                                            MediaQuery.of(context).size.height *
                                                .06),
                                        primary: Colors.black,
                                        shape: StadiumBorder(),
                                      ),
                                      onPressed: () async {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const ChangePasswordUi()),
                                        );
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                              isArabic(context)
                                                  ? 'تغيير كلمة السر'
                                                  : "Change Password",
                                              style: TextStyle(
                                                  fontFamily: 'SouqFont',
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                          Icon(
                                            Icons.change_circle_outlined,
                                            color: Colors.white,
                                          ),
                                        ],
                                      )),
                                ]
                          ),
                          SizedBox(
                              height: MediaQuery.of(context).size.height * .03),

                           Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      maximumSize: Size(
                                          MediaQuery.of(context).size.height *
                                              .33,
                                          MediaQuery.of(context).size.height *
                                              .07),
                                      minimumSize: Size(
                                          MediaQuery.of(context).size.height *
                                              .33,
                                          MediaQuery.of(context).size.height *
                                              .07),
                                      primary: Colors.black,
                                      shape: StadiumBorder(),
                                    ),
                                    onPressed: () async {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const UpdateAccountPage()),
                                      );
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                            isArabic(context)
                                                ? 'تعديل المعلومات الشخصية'
                                                : "Edit Personal Information",
                                            style: TextStyle(
                                                fontFamily: 'SouqFont',
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                        Icon(
                                          Icons.edit,
                                          color: Colors.white,
                                        ),
                                      ],
                                    )),
                              ]),
                        ],
                      ),
                    ),)
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
            future: loadUser(),
          )),
    );
  }

  bool isArabic(BuildContext context) {
    return context.locale.languageCode == 'ar';
  }
  Widget UserStoreFields() {
    return Column(children: [
      SizedBox(height: MediaQuery.of(context).size.height * .03),
      TextFormField(
        controller: _StoreNameArController,   style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          fontFamily: 'SouqFont'),
        decoration: InputDecoration(
          enabled: false,                              fillColor: Colors.transparent,
          labelText: isArabic(context) ? 'الإسم العربي' : 'Arabic Name',
        ),
      ),
      SizedBox(height: MediaQuery.of(context).size.height * .03),
      TextFormField(
        readOnly: true,
        controller: _StoreNameEnController,   style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          fontFamily: 'SouqFont'),
        decoration: InputDecoration(
          fillColor: Colors.transparent,
          enabled: false,
          labelText: isArabic(context) ? 'الإسم الانجليزي' : 'English Name',
        ),
      ),
      SizedBox(height: MediaQuery.of(context).size.height * .03),
      TextFormField(
        controller: _DescriprionController,   style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          fontFamily: 'SouqFont'),
        decoration: InputDecoration(
          fillColor: Colors.transparent,
          enabled: false,
          labelText: isArabic(context) ? 'وصف المتجر' : 'Store Description',
        ),
      ),
      SizedBox(height: MediaQuery.of(context).size.height * .03),
      TextFormField(
        controller: _LocationController,   style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          fontFamily: 'SouqFont'),
        decoration: InputDecoration(
          fillColor: Colors.transparent,
          enabled: false,
          labelText: isArabic(context) ? 'موقع المتجر' : 'Store Location',
        ),
      )
    ]);
  }

  Future<UserModel> loadUser() async {
    late UserModel user;
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
