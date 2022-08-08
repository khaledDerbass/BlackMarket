import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'CustomProfileAppBar.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  ContactUsState createState() => ContactUsState();
}

class ContactUsState extends State<ContactUs> {
  @override
  Widget build(BuildContext context) {
    return Material(
        child: NestedScrollView(
            headerSliverBuilder: (context, index) {
            return [
              CustomProfileAppBar(),
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
