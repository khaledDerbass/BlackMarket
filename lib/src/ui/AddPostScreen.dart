import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Services/AuthenticationService.dart';
import 'CustomProfileAppBar.dart';
import 'HomeScreen.dart';
import 'StoreRegisteration.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({Key? key}) : super(key: key);

  @override
  _AddPostPageState createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        automaticallyImplyLeading: false,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(25),
                bottomLeft: Radius.circular(25))),
        title:  Center(
          child: Text( isArabic(context) ? 'إضافة منشور' : "Add Post"),
        ),
      ),
    );
  }
  bool isArabic(BuildContext context) {
    return context.locale.languageCode == 'ar';
  }
}
