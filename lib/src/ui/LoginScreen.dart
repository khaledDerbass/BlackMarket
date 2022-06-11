import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../generated/locale_keys.g.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Try this
    //context.setLocale(Locale('en', 'US'));
   // context.setLocale(Locale('ar', 'JO'));

    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.welcometext.tr()),
      ),
      body: Container(),
    );
  }
}
