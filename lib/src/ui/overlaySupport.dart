import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(child: MaterialApp());
  }
}