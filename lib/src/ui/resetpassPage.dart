import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'CustomProfileAppBar.dart';


class resetPassword extends StatefulWidget
{
  const resetPassword({Key? key}) : super(key: key);

  @override
  _resetPasswordState createState() => _resetPasswordState();
}

class _resetPasswordState extends State<resetPassword> {
  final emailController=TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
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
                          onPressed: () {
                            resetPassword();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                            children: [
                              Text(
                                  isArabic(context)
                                      ? 'إعادة تعيين'
                                      : "Reset now",
                                  style: TextStyle(fontFamily: 'SouqFont')),
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
    await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.toLowerCase().trim());
    Navigator.of(context, rootNavigator: true).pop('dialog');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:Text('Reset Password Email Sent'),
        duration: Duration(seconds: 3),
      ),
    );
  }
  bool isArabic(BuildContext context) {
    return context.locale.languageCode == 'ar';
  }
}


