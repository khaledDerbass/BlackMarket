import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:souq/Helpers/LoginHelper.dart';
import 'package:souq/src/ui/LoginPage.dart';
import 'CustomProfileAppBar.dart';


class resetPassword extends StatefulWidget
{
  const resetPassword({Key? key}) : super(key: key);

  @override
  _resetPasswordState createState() => _resetPasswordState();
}

class _resetPasswordState extends State<resetPassword> {
  final emailController=TextEditingController();
  Timer? _timer;
  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
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
            Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * .15,
                left: MediaQuery.of(context).size.height * .05,
                right: MediaQuery.of(context).size.height * .05,
              ),
              child: Column(
                children: [
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText:
                          isArabic(context) ? 'البريد الإلكتروني' : 'Email',
                      fillColor: Colors.transparent,
                      filled: true,
                    ),
                    // autovalidateMode: AutovalidateMode.onUserInteraction,
                    // validator: (email) => email != null && !EmailValidator.validate(email)
                    // ?'Enter a valid Email'
                    // :null,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .10),
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

                            resetPassword();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                            children: [
                              Text(
                                  isArabic(context)
                                      ? 'إعادة تعيين'
                                      : "Reset now",
                                  style: TextStyle(fontWeight:FontWeight.bold ,   fontFamily:'SouqFont',fontSize: 16)),
                              Icon(
                                Icons.email_outlined,
                                color: Colors.white,
                              ),
                            ],
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future resetPassword() async
  {
    _timer?.cancel();
    await EasyLoading.show(
        status: 'loading...',
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false
    );
    await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.toLowerCase().replaceAll(" ", "").trim()).then((value) => {
       LoginHelper.showSuccessAlertDialog(context, 'Reset Password Email Sent'),
    }).whenComplete(() async=> {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
            const LoginScreen()),
      ),
      _timer?.cancel(),
      await EasyLoading.dismiss(),
    });


  }
  bool isArabic(BuildContext context) {
    return context.locale.languageCode == 'ar';
  }
}


