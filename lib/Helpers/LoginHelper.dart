import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../src/models/UserModel.dart';

class LoginHelper{

 static showLoginAlertDialog(BuildContext context) {
    Widget okButton = ElevatedButton(
      child: isArabic(context) ? const Text("تم") : const Text("Done"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );

    AlertDialog alert = AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))),
      actions: [
        okButton,
      ],
      content: SizedBox(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height / 4,
        child: ListView(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LimitedBox(
                    maxHeight: MediaQuery.of(context).size.height * 0.15,
                    maxWidth: MediaQuery.of(context).size.width,
                    child: Image.asset('assets/images/loginlock.png')
                ),
              ],
            ),
            const Divider(),
            ListTile(
                title: isArabic(context)
                    ? const Text(
                  'يرجى تسجيل الدخول حتى تتمكن من الوصول الى هذه الصفحة.',
                  style: TextStyle(fontSize: 17),
                )
                    : const Text(
                  'You have to login in order to access this page.',
                  style: TextStyle(fontSize: 17),
                ),
                ),
          ],
        ),
      ),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

 static bool isArabic(BuildContext context) {
   return context.locale.languageCode == 'ar';
 }

 static Future<UserModel> getUserWithEmail(String email) async {
   late UserModel user;
   await FirebaseFirestore.instance.collection('Users').where('email', isEqualTo: email.trim()).get().then((value) => value.docs.forEach((doc) {
     user = UserModel.fromJson(value.docs.first.data());
   }));
   print(user.email);
   print("From Login");
   print(user.RoleID);
   final box = GetStorage();
   box.write("roleID", user.RoleID);
   return user;
 }

 static showSuccessAlertDialog(BuildContext context,String message) {
   Widget okButton = ElevatedButton(
     child: isArabic(context) ? const Text("تم") : const Text("Done"),
     onPressed: () {
       Navigator.of(context, rootNavigator: true).pop('dialog');
     },
   );

   AlertDialog alert = AlertDialog(
     shape: const RoundedRectangleBorder(
         borderRadius: BorderRadius.all(Radius.circular(32.0))),
     actions: [
       okButton,
     ],
     content: SizedBox(
       width: double.maxFinite,
       height: MediaQuery.of(context).size.height / 4,
       child: ListView(
         children: <Widget>[
           Row(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               LimitedBox(
                   maxHeight: MediaQuery.of(context).size.height * 0.15,
                   maxWidth: MediaQuery.of(context).size.width,
                   child: Image.asset('assets/images/success.png')
               ),
             ],
           ),
           const Divider(),
           ListTile(
             title: Text(
               message,
               style: TextStyle(fontSize: 17),
             ),
           ),
         ],
       ),
     ),
   );

   // show the dialog
   showDialog(
     context: context,
     builder: (BuildContext context) {
       return alert;
     },
   );
 }

 static showErrorAlertDialog(BuildContext context,String ErrorMessage) {
   Widget okButton = ElevatedButton(
     child: isArabic(context) ? const Text("تم") : const Text("Done"),
     onPressed: () {
       Navigator.of(context, rootNavigator: true).pop('dialog');
     },
   );

   AlertDialog alert = AlertDialog(
     shape: const RoundedRectangleBorder(
         borderRadius: BorderRadius.all(Radius.circular(32.0))),
     actions: [
       okButton,
     ],
     content: SizedBox(
       width: double.maxFinite,
       height: MediaQuery.of(context).size.height / 4,
       child: ListView(
         children: <Widget>[
           Row(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               LimitedBox(
                   maxHeight: MediaQuery.of(context).size.height * 0.15,
                   maxWidth: MediaQuery.of(context).size.width,
                   child: Image.asset('assets/images/error.png')
               ),
             ],
           ),
           const Divider(),
           ListTile(
             title: Text(
               ErrorMessage,
               style: TextStyle(fontSize: 17),
             ),
           ),
         ],
       ),
     ),
   );

   // show the dialog
   showDialog(
     context: context,
     builder: (BuildContext context) {
       return alert;
     },
   );
 }

}