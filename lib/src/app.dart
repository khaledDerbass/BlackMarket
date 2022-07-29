import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:souq/src/ui/HomeScreen.dart';
import 'package:souq/src/ui/UserPrefrencesScreen.dart';
import 'ui/LoginScreen.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: ThemeData(
        primaryColor: CupertinoColors.systemIndigo,
      ),
      home: const Scaffold(
        body: UserPrefrencesScreen(),
      ),
    );
  }
}