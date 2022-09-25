import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
                top: MediaQuery.of(context).size.height * .07,
                left: MediaQuery.of(context).size.height * .05,
                right: MediaQuery.of(context).size.height * .05,
              ),
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
                  SizedBox(height: MediaQuery.of(context).size.height * .05),
                  TextField(
                    onChanged: (value) {},
                    controller: _emailController,
                    decoration:  InputDecoration(
                      fillColor: Colors.transparent,
                      filled: true,
                      labelText: isArabic(context) ? 'البريد الإلكتروني' : 'Email',
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .05),
                  TextField(
                    onChanged: (value) {},
                    controller: _phoneController,
                    decoration:  InputDecoration(
                      fillColor: Colors.transparent,
                      filled: true,
                      labelText: isArabic(context) ? 'رقم الهاتف' : 'Phone',
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .05),
                  TextField(
                    onChanged: (value) {},
                    controller: _passwordController,
                    obscureText: true,
                    decoration:  InputDecoration(
                      fillColor: Colors.transparent,
                      filled: true,
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
                          onPressed: () async{
                            _timer?.cancel();
                            await EasyLoading.show(
                              status: 'loading...',
                              maskType: EasyLoadingMaskType.black,
                                dismissOnTap: false
                            );


                            // Find the ScaffoldMessenger in the widget tree
                            // and use it to show a SnackBar.
                            AuthenticationService.register(
                                _emailController.text.toLowerCase().trim(),
                                _passwordController.text,
                                _phoneController.text,
                                _usernameController.text)
                                .then((value) async => {
                              if (value)
                                {
                                LoginHelper.showSuccessAlertDialog(context, isArabic(context) ? 'تم التسجيل بنجاح ' : 'Your account has been created successfully'),
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                        const LoginScreen()),
                                  )
                                }else{
                                LoginHelper.showErrorAlertDialog(context, isArabic(context) ? 'حدث خطأ اثناء عملية التسجيل' : 'Error during sign up'),
                              },
                              _timer?.cancel(),
                              await EasyLoading.dismiss(),
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            //crossAxisAlignment: CrossAxisAlignment.center,
                            children:  [
                             Text( isArabic(context) ? 'التسجيل كمستخدم' : 'Register as User',style: TextStyle(
                                 fontWeight:FontWeight.bold ,   fontFamily:'SouqFont',fontSize: 16)),
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
                                builder: (context) =>
                                const StoreRegisteration()),
                          );
                        },
                        child:  Text(
                         isArabic(context) ? ' التسجيل كمتجر' : 'Register as Store',
                          style: TextStyle(color: Colors.black,fontWeight:FontWeight.bold ,   fontFamily:'SouqFont',fontSize: 16),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
  bool isArabic(BuildContext context) {
    return context.locale.languageCode == 'ar';
  }
}
