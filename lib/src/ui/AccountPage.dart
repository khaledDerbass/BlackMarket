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

class AccountPage extends StatefulWidget
{
  const AccountPage({Key? key}) : super(key: key);

  @override
  AccountPageState createState() => AccountPageState();
}

class AccountPageState extends State<AccountPage> {
   TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
   TextEditingController _DescriprionController = TextEditingController();
   TextEditingController _LocationController = TextEditingController();
   GlobalKey<FormState> _form = GlobalKey<FormState>();
   late UserStore? userStore;
  @override
  void initState()  {
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
                }
                else if (snapshot.hasData) {
                  // Extracting data from snapshot object
                  var data = snapshot.data as UserModel;
                  _usernameController.text = data.name;
                  _emailController.text = data.email;
                  _phoneController.text = data.phoneNumber;
                  if(userStore != null){
                    _DescriprionController.text = userStore!.store.descStore;
                    _LocationController.text = userStore!.store.locStore;
                  }
                  return Container(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * .08,
                      left: MediaQuery.of(context).size.height * .05,
                      right: MediaQuery.of(context).size.height * .05,
                    ),
                    child:  Form(
                        key: _form,
                        child: Column(
                          children: [
                            TextFormField (
                              readOnly: true,
                              controller: _emailController,
                              decoration: InputDecoration(
                                fillColor: Colors.transparent,
                                filled: true,
                                enabled: false,
                                labelText: isArabic(context)
                                    ? 'البريد الإلكتروني'
                                    : 'Email',
                              ),
                            ),
                            SizedBox(
                                height:
                                MediaQuery.of(context).size.height * .03),
                            TextFormField (
                              readOnly: true,
                              controller: _phoneController,
                              decoration: InputDecoration(
                                fillColor: Colors.transparent,
                                filled: true,
                                enabled: false,
                                labelText:
                                isArabic(context) ? 'رقم الهاتف' : 'Phone Number',
                              ),
                            ),
                            SizedBox(
                                height:
                                MediaQuery.of(context).size.height * .05),
                            TextFormField (
                              readOnly: true,
                              enabled: false,
                              controller: _usernameController,
                              decoration: InputDecoration(
                                fillColor: Colors.transparent,
                                labelText: isArabic(context)
                                    ? 'اسم المستخدم'
                                    : 'Username',
                                filled: true,
                              ),
                            ),
                            SizedBox(
                                height:
                                MediaQuery.of(context).size.height * .05),

                           userStore != null ?TextFormField (
                             readOnly: true,
                             enabled: false,

                              controller: _DescriprionController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.transparent,
                                labelText:
                                isArabic(context) ? 'وصف المتجر' : 'Store Description',
                              ),
                            ) : Container(),
                            userStore != null ?SizedBox(
                                height:
                                MediaQuery.of(context).size.height * .05): Container(),
                            userStore != null ? TextFormField (
                              readOnly: true,
                              enabled: false,
                              controller: _LocationController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.transparent,
                                labelText:
                                isArabic(context) ? 'موقع المتجر' : 'Store Location',
                              ),
                            ): Container(),
                            SizedBox(
                                height:
                                MediaQuery.of(context).size.height * .10),
                            FittedBox(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        maximumSize: Size(
                                            MediaQuery.of(context).size.height *
                                                .21,
                                            MediaQuery.of(context).size.height *
                                                .08),
                                        minimumSize: Size(
                                            MediaQuery.of(context).size.height *
                                                .21,
                                            MediaQuery.of(context).size.height *
                                                .08),
                                        primary: Colors.black,
                                        shape: StadiumBorder(),
                                      ),
                                      onPressed: () async {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => const ChangePasswordUi()),
                                        );
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(isArabic(context)
                                              ? 'تغيير كلمة السر'
                                              : "Change Password",style: TextStyle(
              fontFamily:'SouqFont')),
                                          Icon(
                                            Icons.refresh,
                                            color: Colors.white,
                                          ),
                                        ],
                                      )),
                                  SizedBox(
                                      width:
                                      MediaQuery.of(context).size.height * .01),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        maximumSize: Size(
                                            MediaQuery.of(context).size.height *
                                                .2,
                                            MediaQuery.of(context).size.height *
                                                .08),
                                        minimumSize: Size(
                                            MediaQuery.of(context).size.height *
                                                .2,
                                            MediaQuery.of(context).size.height *
                                                .08),
                                        primary: Colors.black,
                                        shape: StadiumBorder(),
                                      ),
                                      onPressed: () async {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => const UpdateAccountPage()),
                                        );
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(isArabic(context)
                                              ? 'تعديل'
                                              : "Edit",style: TextStyle(
                                              fontFamily:'SouqFont')),
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
                        )),
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
