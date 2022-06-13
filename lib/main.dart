import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:souq/src/ui/LoginScreen.dart';
import 'generated/codegen_loader.g.dart';
import 'src/app.dart';
import 'dart:async';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(EasyLocalization(
      supportedLocales: const [Locale('en', 'US'), Locale('ar', 'JO')],
      path: 'assets/languages',
      fallbackLocale: const Locale('en', 'US'),
      assetLoader: const CodegenLoader(),
      child: const App()
  ),);
}
/*
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(MyApp());
}
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Splash Screen',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
class Splash2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 6,
      navigateAfterSeconds: LoginScreen(),
      title: new Text('GeeksForGeeks',textScaleFactor: 2,),
      image: new Image.network('https://www.geeksforgeeks.org/wp-content/uploads/gfg_200X200.png'),
      loadingText: Text("Loading"),
      photoSize: 100.0,
      loaderColor: Colors.blue,
    );
  }
}
*///