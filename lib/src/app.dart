import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'ui/LoginScreen.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,

      home: const Scaffold(
        body: LoginScreen(),
      ),
    );
  }
}