import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'generated/codegen_loader.g.dart';
import 'src/app.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp( EasyLocalization(
      supportedLocales: const [Locale('en', 'US'), Locale('ar', 'JO')],
      path: 'assets/languages',
      fallbackLocale: const Locale('en', 'US'),
      assetLoader: const CodegenLoader(),
      child: const App()
  ),);
}