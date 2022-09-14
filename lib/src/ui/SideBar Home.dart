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
    return Drawer(
      child: Column(
        children: <Widget>[
          DrawerHeader(
            child: Center(
              child: Text(
                'Souq Story',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 25,
                    fontFamily:'SouqFont'),
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
                  title: Text(isArabic(context)
                      ? 'تسجيل'
                      : 'Sign up',style: TextStyle(
                      fontFamily:'SouqFont'),), //Text('Sign up'),
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
                  title: Text(isArabic(context) ? 'تسجيل دخول' : 'Sign in',style: TextStyle(
                      fontFamily:'SouqFont')),
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
              title: Text(isArabic(context) ? 'اللغة' : 'Language',style: TextStyle(
    fontFamily:'SouqFont'),),
              onTap: () => {
                    showLanguageAlertDialog(context),
                  }),
    //       ListTile(
    //         leading: Icon(Icons.home_filled),
    //         title: Text(isArabic(context) ? 'المدينة/البلد' :'Country/State',style: TextStyle(
    // fontFamily:'SouqFont'),),
    //         onTap: () => {showCitiesAlertDialog(context)},
    //       ),
          isLoggedIN == true
              ? ListTile(
                  leading: Icon(Icons.logout),
                  title: Text(isArabic(context) ? 'تسجيل خروج' : 'Sign out',style: TextStyle(
                      fontFamily:'SouqFont'),),
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

  showLanguageAlertDialog(BuildContext context) {
    Widget okButton = ElevatedButton(
      child: isArabic(context) ? const Text("إلغاء",style: TextStyle(
          fontFamily:'SouqFont'),) : const Text("Dismiss",style: TextStyle(
          fontFamily:'SouqFont'),),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );

    AlertDialog alert = AlertDialog(
      actions: [
        okButton,
      ],
      title: isArabic(context) ? const Text("اللغة",style: TextStyle(
          fontFamily:'SouqFont'),) : const Text("Language",style: TextStyle(
          fontFamily:'SouqFont'),),
      content: SizedBox(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height / 5,
        child: ListView(
          children: <Widget>[
            ListTile(
                title: Text(
                  'العربية',
                  style: TextStyle(fontSize: 17),
                ),
                trailing: Image(
                    width: MediaQuery.of(context).size.width * 0.09,
                    image: NetworkImage(
                        'https://icons.iconarchive.com/icons/wikipedia/flags/1024/JO-Jordan-Flag-icon.png')),
                onTap: () => {
                      context.setLocale(Locale('ar', 'JO')),
                      Navigator.of(context, rootNavigator: true).pop('dialog')
                    }),
            const Divider(),
            ListTile(
                title: isArabic(context)
                    ? const Text(
                        'الإنجليزية',
                        style: TextStyle(fontSize: 17,
                            fontFamily:'SouqFont'),
                      )
                    : const Text(
                        'English',
                        style: TextStyle(fontSize: 17,
                            fontFamily:'SouqFont'),
                      ),
                trailing: Image(
                    width: MediaQuery.of(context).size.width * 0.09,
                    image: NetworkImage(
                        'https://www.lifepng.com/wp-content/uploads/2021/03/Classic-Uk-Flag-png-hd.png')),
                onTap: () => {
                      context.setLocale(Locale('en', 'US')),
                      Navigator.of(context, rootNavigator: true).pop('dialog')
                    }),
          ],
        ),
      ),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  showCitiesAlertDialog(BuildContext context) {
    Widget okButton = ElevatedButton(
      child: isArabic(context) ? const Text("إلغاء",style: TextStyle(
          fontFamily:'SouqFont')) : const Text("Dismiss",style: TextStyle(
          fontFamily:'SouqFont'),),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );

    AlertDialog alert = AlertDialog(
      actions: [
        okButton,
      ],
      title: isArabic(context) ? const Text("المدينة",style: TextStyle(
          fontFamily:'SouqFont',),) : const Text("City",style: TextStyle(
          fontFamily:'SouqFont'),),
      content: SizedBox(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height / 5,
        child: ListView(
          children: <Widget>[
            ListTile(
                title: isArabic(context)
                    ? const Text(
                  'عمًان',
                  style: TextStyle(fontSize: 17,
                      fontFamily:'SouqFont'),
                )
                    : const Text(
                  'Amman',
                  style: TextStyle(fontSize: 17,
                      fontFamily:'SouqFont'),
                ),
                onTap: () => {

                }),
            const Divider(),
            ListTile(
                title: isArabic(context)
                    ? const Text(
                  'إربد',
                  style: TextStyle(fontSize: 17,
                      fontFamily:'SouqFont'),
                )
                    : const Text(
                  'Irbid',
                  style: TextStyle(fontSize: 17,
                      fontFamily:'SouqFont'),
                ),
                onTap: () => {

                }),
            const Divider(),
            ListTile(
                title: isArabic(context)
                    ? const Text(
                  'الزرقاء',
                  style: TextStyle(fontSize: 17,
                      fontFamily:'SouqFont'),
                )
                    : const Text(
                  'Zarqa',
                  style: TextStyle(fontSize: 17,
                      fontFamily:'SouqFont'),
                ),
                onTap: () => {

                }),
          ],
        ),
      ),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
