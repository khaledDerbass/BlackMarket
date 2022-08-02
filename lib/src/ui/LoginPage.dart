import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:souq/src/ui/resetpassPage.dart';
import '../../generated/locale_keys.g.dart';
import 'package:flutter/cupertino.dart';
import '../models/CustomProfileAppBar.dart';
import 'HomeScreen.dart';
import 'RegisterPage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  LoginScreenState createState() => LoginScreenState();
}


class LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(

      child: NestedScrollView(
      headerSliverBuilder: (context,index) {
      return [
        CustomProfileAppBar(),
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
                        decoration: InputDecoration(
                          labelText: 'Email',
                          fillColor: Colors.transparent,
                          filled: true,

                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * .05),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the password';
                          } else if (value.length <= 6) {
                            return 'Password must be greater than 6 digits';
                          }
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
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
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()),
                                );                                 },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('LOGIN'),
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
                            child: Text(
                              'Register',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const resetPassword()),
                              );
                              },
                            child: Text(
                              'Forgot password?',
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
        ),
    );
  }
}
