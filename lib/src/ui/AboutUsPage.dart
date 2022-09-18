import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'CustomProfileAppBar.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  AboutUsState createState() => AboutUsState();
}

class AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Material(
        child: NestedScrollView(
          headerSliverBuilder: (context, index) {
            return [
              CustomProfileAppBar(false),
            ];
          },

          body:
          Text(""),
        ));
  }
  bool isArabic(BuildContext context) {
    return context.locale.languageCode == 'ar';
  }
}