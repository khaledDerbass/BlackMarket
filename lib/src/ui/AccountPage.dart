import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/UserModel.dart';
import 'CustomProfileAppBar.dart';
import 'changePasswordUi.dart';

class AccountPage extends StatefulWidget
{
  const AccountPage({Key? key}) : super(key: key);

  @override
  AccountPageState createState() => AccountPageState();
}

class AccountPageState extends State<AccountPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  @override
  void initState()  {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Material(
      child: NestedScrollView(
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
                  return Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * .08,
                          left: MediaQuery.of(context).size.height * .05,
                          right: MediaQuery.of(context).size.height * .05,
                        ),
                        child:  Form(
                            key: _form,
                            child: Column(
                              children: [
                                TextField(
                                  onChanged: (value) {},
                                  controller: _usernameController,
                                  readOnly: true,
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
                                    MediaQuery.of(context).size.height * .03),
                                TextField(
                                  readOnly: true,
                                  onChanged: (value) {},
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
                                TextField(
                                  readOnly: true,
                                  onChanged: (value) {},
                                  controller: _phoneController,
                                  decoration: InputDecoration(
                                    fillColor: Colors.transparent,
                                    filled: true,
                                    enabled: false,
                                    labelText:
                                    isArabic(context) ? 'رقم الهاتف' : 'Phone',
                                  ),
                                ),
                                SizedBox(
                                    height:
                                    MediaQuery.of(context).size.height * .10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          maximumSize: Size(
                                              MediaQuery.of(context).size.height *
                                                  .22,
                                              MediaQuery.of(context).size.height *
                                                  .08),
                                          minimumSize: Size(
                                              MediaQuery.of(context).size.height *
                                                  .22,
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
                                  ],
                                ),
                              ],
                            )),
                      ),
                    ],
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
    await FirebaseFirestore.instance
        .collection('Users')
        .where('email', isEqualTo: FirebaseAuth.instance.currentUser?.email)
        .get()
        .then((value) => value.docs.forEach((doc) {
              user = UserModel.fromJson(value.docs.first.data());
              print(user.name);
            }));

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
