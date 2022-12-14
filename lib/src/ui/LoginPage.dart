import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:souq/src/models/UserModel.dart';
import 'package:souq/src/ui/resetpassPage.dart';
import '../../Helpers/LoginHelper.dart';
import '../../generated/locale_keys.g.dart';
import 'package:flutter/cupertino.dart';
import '../Services/AuthenticationService.dart';
import 'CustomProfileAppBar.dart';
import 'HomeScreen.dart';
import 'RegisterPage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  Timer? _timer;

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
    return Material(
        child: NestedScrollView(
        headerSliverBuilder: (context, index) {
      return [
        CustomProfileAppBar(false),
      ];
    },

      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * .15,
                left: MediaQuery.of(context).size.height * .05,
                right: MediaQuery.of(context).size.height * .05,
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText:
                          isArabic(context) ? '???????????? ????????????????????' : 'Email',
                      fillColor: Colors.transparent,
                      filled: true,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .05),
                  TextFormField(
                    controller: _passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return isArabic(context)
                            ? '???????? ???????? ????????'
                            : 'Please enter the password';
                      } else if (value.length <= 6) {
                        return isArabic(context)
                            ? '???????? ???????? ?????? ???? ???? ?????? ???? 6 ????????'
                            : 'Password must be greater than 6 digits';
                      }
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: isArabic(context) ? '???????? ????????' : 'Password',
                      fillColor: Colors.transparent,
                      filled: true,
                      // hintText: 'Password',
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .05),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            maximumSize: Size(
                                MediaQuery.of(context).size.height * .25,
                                MediaQuery.of(context).size.height * .07),
                            minimumSize: Size(
                                MediaQuery.of(context).size.height * .25,
                                MediaQuery.of(context).size.height * .07),
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

                            AuthenticationService.signInWithEmailAndPassword(
                              _emailController.text.toLowerCase().trim(),
                              _passwordController.text,
                            ).then((value) async => {
                                  if (value)
                                    {
                                      await LoginHelper.getUserWithEmail(
                                              _emailController.text
                                                  .toLowerCase()
                                                  .trim())
                                          .then((value) => {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const HomeScreen()),
                                                )
                                              }),
                                    }
                                  else
                                    {
                                     LoginHelper.showErrorAlertDialog(context, isArabic(context)
                                         ? '?????? ???? ?????? ???????????????? ???? ???????? ????????'
                                         : 'Wrong Email or Password')
                                    },
                                _timer?.cancel(),
                                await EasyLoading.dismiss(),
                                });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                  isArabic(context)
                                      ? '?????????? ????????????'
                                      : 'Sign in',
                                  style: TextStyle(fontWeight:FontWeight.bold ,   fontFamily:'SouqFont',fontSize: 16)),
                              Icon(
                                CupertinoIcons.padlock_solid,
                                color: Colors.white,
                              ),
                            ],
                          )),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegisterPage()),
                          );
                        },
                        child: Text(
                          isArabic(context) ? '??????????????' : 'Register',
                          style: TextStyle(
                              color: Colors.black,fontWeight:FontWeight.bold ,   fontFamily:'SouqFont',fontSize: 16),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const resetPassword()),
                          );
                        },
                        child: Text(
                          isArabic(context)
                              ? '???????? ???????? ??????????????'
                              : 'Forgot password?',
                          style: TextStyle(color: Colors.black,fontWeight:FontWeight.bold ,   fontFamily:'SouqFont',fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),),
    );
  }

  bool isArabic(BuildContext context) {
    return context.locale.languageCode == 'ar';
  }
}
