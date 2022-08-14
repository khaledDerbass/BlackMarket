import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:souq/Helpers/LoginHelper.dart';
import '../models/UserModel.dart';
import 'CustomProfileAppBar.dart';

class ChangePasswordUi extends StatefulWidget {
  const ChangePasswordUi({Key? key}) : super(key: key);

  @override
  ChangePasswordUiState createState() => ChangePasswordUiState();
}

class ChangePasswordUiState extends State<ChangePasswordUi> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _newpasswordController = TextEditingController();
  final GlobalKey<FormState> _form = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Material(
      child: NestedScrollView(
          headerSliverBuilder: (context, index) {
            return [
              CustomProfileAppBar(),
            ];
          },
          body: Stack(
            children: [
              Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * .08,
                  left: MediaQuery.of(context).size.height * .05,
                  right: MediaQuery.of(context).size.height * .05,
                ),
                child: Form(
                    key: _form,
                    child: Column(
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .03),
                        TextFormField(
                          validator: (validator) {
                             if (validator =="" || validator == null) return 'Required';
                            return null;
                          },
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            fillColor: Colors.transparent,
                            filled: true,
                            labelText: isArabic(context)
                                ? 'كلمة السر الجديدة'
                                : 'New password',
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .05),
                        TextFormField(
                          validator: (validator) {
                                    if (validator != _passwordController.text) return 'The passwords does not match';
                                    else if (validator =="" || validator == null) return 'Required';
                                    return null;
                                  },
                          controller: _newpasswordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            fillColor: Colors.transparent,
                            filled: true,
                            labelText: isArabic(context)
                                ? 'إعادة كلمة السر الجديدة'
                                : 'Retype new password',
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  maximumSize: Size(
                                      MediaQuery.of(context).size.height * .20,
                                      MediaQuery.of(context).size.height * .07),
                                  minimumSize: Size(
                                      MediaQuery.of(context).size.height * .20,
                                      MediaQuery.of(context).size.height * .07),
                                  primary: Colors.black,
                                  shape: StadiumBorder(),
                                ),
                                onPressed: () async {
                                  if (_form.currentState!.validate()) {
                                    try {
                                      print("Valid");
                                      await FirebaseAuth.instance.currentUser
                                          ?.updatePassword(
                                          _passwordController.text);
                                      await changeUserPassword(
                                          _passwordController.text);
                                      LoginHelper.showSuccessAlertDialog(context, isArabic(context) ? "تم تغيير كلمة السر بنجاح": "Your Password has been changed Successfully");

                                    }on FirebaseAuthException catch  (e) {
                                      LoginHelper.showErrorAlertDialog(context, e.message.toString());
                                      print(e.message);
                                    }
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  //crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                        isArabic(context) ? 'تعديل' : "Modify"),
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
              await FirebaseFirestore.instance
                  .collection('Users')
                  .doc(value.docs.first.id)
                  .update(user.toJson());
            }));

    return user;
  }
}
