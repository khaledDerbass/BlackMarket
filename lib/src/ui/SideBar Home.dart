import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:souq/src/ui/HomeScreen.dart';
import 'package:souq/src/ui/LoginPage.dart';
import '../Services/AuthenticationService.dart';
import 'RegisterPage.dart';

class SideDrawer extends StatelessWidget {
  var isLoggedIN = AuthenticationService.isCurrentUserLoggedIn();

  @override
  Widget build(BuildContext context) {
    context.setLocale(Locale('en', 'US'));
 //   List<String> dropdown = ["Arabic", "English"];

    return Drawer(
      child: Column(
        children: <Widget>[
          DrawerHeader(
            child: Center(
              child: Text(
                'Souq Story',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.deepPurpleAccent,
            ),
          ),
          isLoggedIN == false
              ? ListTile(
                  leading: Icon(Icons.app_registration),
                  title: Text(isArabic(context) ? 'تسجيل' : 'Sign up'), //Text('Sign up'),
                  onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterPage()),
                    ),
                  },
                )
              : Container(),
          isLoggedIN == false
              ? ListTile(
                  leading: Icon(Icons.login),
                  title: Text(isArabic(context) ? 'تسجيل دخول' : 'Sign in'),
                  onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                    ),
                  },
                )
              : Container(),
          ListTile(
              leading: Icon(Icons.language),
              title: Text(isArabic(context) ? 'اللغة' :'Language'),
              onTap: () => {
                    ListTile(title: Text('Arabic'), onTap: () => {}),
                    ListTile(title: Text('English'), onTap: () => {}),
                  }),
          ListTile(
            leading: Icon(Icons.home_filled),
            title: Text('Country/State'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          isLoggedIN == true
              ? ListTile(
                  leading: Icon(Icons.logout),
                  title: Text(isArabic(context) ? 'تسجيل خروج' : 'Sign out'),
                  onTap: () => {
                    AuthenticationService.signOut().then((value) => {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeScreen()))
                        }),
                  },
                )
              : Container(),
        ],
      ),
    );
  }

  bool isArabic(BuildContext context) {
    return context.locale.languageCode == 'ar';
  }
}
