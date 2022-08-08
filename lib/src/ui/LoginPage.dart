import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:souq/src/ui/resetpassPage.dart';
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

  @override
  Widget build(BuildContext context) {
    context.setLocale(Locale('en', 'US'));
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.deepPurpleAccent,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(25),
                bottomLeft: Radius.circular(25))),
        title: Center(
          child: Text(isArabic(context) ? 'تسجيل دخول' : 'Login'),
        ),
      ),
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
                          labelText: isArabic(context) ? 'البريد الإلكتروني' : 'Email',
                          fillColor: Colors.transparent,
                          filled: true,
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * .05),
                      TextFormField(
                        controller: _passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return isArabic(context) ? 'ادخل كلمة السر' : 'Please enter the password';
                          } else if (value.length <= 6) {
                            return isArabic(context) ? 'كلمة السر يجب ان لا تقل عن 6 أحرف' : 'Password must be greater than 6 digits';
                          }
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: isArabic(context) ? 'كلمة السر' : 'Password',
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
                                maximumSize: Size(MediaQuery.of(context).size.height * .18, MediaQuery.of(context).size.height * .07),
                                minimumSize: Size(MediaQuery.of(context).size.height * .18, MediaQuery.of(context).size.height * .07),
                                primary: Colors.black,
                                shape: StadiumBorder(),
                              ),
                              onPressed: () {
                                final snackBar1 = SnackBar(
                                  content:  Text(isArabic(context) ? 'تم تسجيل الدخول' : 'Signed in successfully'),
                                );
                                final snackBar2 = SnackBar(
                                  content:  Text(isArabic(context) ? 'خطأ في إسم المستخدم او كلمة السر' : 'Wrong Email or Password'),
                                );
                                AuthenticationService.signInWithEmailAndPassword(
                                    _emailController.text,
                                    _passwordController.text,)
                                    .then((value) => {
                                  if (value)
                                    {
                                      ScaffoldMessenger.of(context).showSnackBar(snackBar1),
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                            const HomeScreen()),
                                      )
                                    }else{
                                    ScaffoldMessenger.of(context).showSnackBar(snackBar2),
                                  }
                                });
                                                                },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children:  [
                                  Text(isArabic(context) ? 'تسجيل الدخول' : 'Sign in'),
                                  Icon(
                                    Icons.lock,
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
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage()),
                              );
                              },
                            child:
                              Text(isArabic(context) ? 'التسجيل' : 'Register',
                  style: TextStyle(color: Colors.black),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const resetPassword()),
                              );
                              },
                            child:
                            Text(isArabic(context) ? 'نسيت كلمة المرور؟' : 'Forgot password?',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ],
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
