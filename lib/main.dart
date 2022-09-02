import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:souq/src/ui/LoginPage.dart';
import 'generated/codegen_loader.g.dart';
import 'src/app.dart';
import 'dart:async';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  runApp(EasyLocalization(
      supportedLocales: const [Locale('en', 'US'), Locale('ar', 'JO')],
      path: 'assets/languages',
      fallbackLocale: const Locale('ar', 'JO'),
      assetLoader: const CodegenLoader(),
      child: const App()
  ),);
}