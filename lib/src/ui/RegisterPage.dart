import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:souq/src/ui/LoginPage.dart';
import '../../Helpers/LoginHelper.dart';
import '../Services/AuthenticationService.dart';
import 'CustomProfileAppBar.dart';
import 'StoreRegisteration.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  Timer? _timer;

  final _formKey = GlobalKey<FormState>();
  bool _submitted = false;

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

  String? _errorTextAR(value) {
    if (value.isEmpty) {
      return 'Can\'t be empty';
    } else if (value!.length < 4) {
      return 'Too short, Name must be more than 4 charater';
    } else
      return null;
  }

  String? _errorTextEM(value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (value.isEmpty) {
      return 'Can\'t be empty';
    } else if (!regex.hasMatch(value!)) {
      return 'Enter Valid Email';
    } else
      return null;
  }

  String? _errorTextPH(String? value) {
    if (value!.isEmpty) {
      return 'Can\'t be empty, Mobile Number must be of 10 digit';
    } else if (value!.length != 10) {
      return 'Mobile Number must be of 10 digit';
    } else
      return null;
  }

  String? _errorTextPASS(String? value) {
    if (value!.isEmpty) {
      return 'Can\'t be empty, ';
    } else if (value!.length < 6) {
      return 'Too short, Password must be more than 6 digits';
    } else
      return null;
  }

  void _submit() {
    setState(() => _submitted = true);
    if (_formKey.currentState!.validate()) {
      // TODO SAVE DATA
    }
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
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * .04,
                    left: MediaQuery.of(context).size.height * .05,
                    right: MediaQuery.of(context).size.height * .05,
                    bottom: MediaQuery.of(context).size.height * .01,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          textAlign: TextAlign.center,
                          validator: _errorTextAR,
                          controller: _usernameController,
                          decoration: InputDecoration(
                            fillColor: Colors.transparent,
                            labelText:
                                isArabic(context) ? 'اسم المستخدم' : 'Username',
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * .05),
                        TextFormField(
                          textAlign: TextAlign.center,
                          validator: _errorTextEM,
                          controller: _emailController,
                          decoration: InputDecoration(
                            fillColor: Colors.transparent,
                            labelText:
                                isArabic(context) ? 'البريد الإلكتروني' : 'Email',
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * .05),
                        TextFormField(
                          textAlign: TextAlign.center,
                          validator: _errorTextPH,
                          controller: _phoneController,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r"[0-9]"),
                            )
                          ],
                          decoration: InputDecoration(
                            fillColor: Colors.transparent,
                            labelText: isArabic(context) ? 'رقم الهاتف' : 'Phone',
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * .05),
                        TextFormField(
                          textAlign: TextAlign.center,
                          validator: _errorTextPASS,
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            fillColor: Colors.transparent,
                            labelText: isArabic(context) ? 'كلمة السر' : 'Password',
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * .05),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  maximumSize: Size(
                                      MediaQuery.of(context).size.height * .30,
                                      MediaQuery.of(context).size.height * .07),
                                  minimumSize: Size(
                                      MediaQuery.of(context).size.height * .30,
                                      MediaQuery.of(context).size.height * .07),
                                  primary: Colors.black,
                                  shape: const StadiumBorder(),
                                ),
                                onPressed: () async {
                                  _submit();
                                  _timer?.cancel();
                                  await EasyLoading.show(
                                      status: 'loading...',
                                      maskType: EasyLoadingMaskType.black,
                                      dismissOnTap: false);
                                  final snackBar1 = SnackBar(
                                      content: Text(
                                        isArabic(context)
                                            ? 'تم التسجيل بنجاح '
                                            : 'Your account has been created successfully',
                                        style: TextStyle(fontFamily: 'SouqFont'),
                                      ));
                                  final snackBar2 = SnackBar(
                                    content: Text(
                                      isArabic(context)
                                          ? 'حدث خطأ اثناء عملية التسجيل'
                                          : 'Error during sign up',
                                      style: TextStyle(fontFamily: 'SouqFont'),
                                    ),
                                  );
                                  // Find the ScaffoldMessenger in the widget tree
                                  // and use it to show a SnackBar.
                                  AuthenticationService.register(
                                          _emailController.text
                                              .toLowerCase()
                                              .trim(),
                                          _passwordController.text,
                                          _phoneController.text,
                                          _usernameController.text)
                                      .then((value) async => {
                                            if (value)
                                              {
                                                LoginHelper.showSuccessAlertDialog(
                                                    context,
                                                    isArabic(context)
                                                        ? 'تم التسجيل بنجاح '
                                                        : 'Your account has been created successfully'),
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const LoginScreen()),
                                                )
                                              }
                                            else
                                              {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snackBar2),
                                              },
                                            _timer?.cancel(),
                                            await EasyLoading.dismiss(),
                                          });
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  //crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                        isArabic(context)
                                            ? 'التسجيل كمستخدم'
                                            : 'Register as User',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'SouqFont',
                                            fontSize: 16)),
                                    Icon(
                                      Icons.how_to_reg,
                                      color: Colors.white,
                                    ),
                                  ],
                                )),
                          ],
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * .05),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => StoreRegisteration()),
                                );
                              },
                              child: Text(
                                isArabic(context)
                                    ? ' التسجيل كمتجر'
                                    : 'Register as Store',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'SouqFont',
                                    fontSize: 16),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
  }

  bool isArabic(BuildContext context) {
    return context.locale.languageCode == 'ar';
  }
}
