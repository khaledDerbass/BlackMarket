import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get_storage/get_storage.dart';
import '../src/Services/AuthenticationService.dart';
import '../src/models/UserModel.dart';
import '../src/ui/HomeScreen.dart';

class LoginHelper{

 static showLoginAlertDialog(BuildContext context) {
    Widget okButton = GestureDetector(
      child: Container(
        padding: EdgeInsets.all(10),
        child: isArabic(context) ? const Text("تم") : const Text("Done"),
      ),
      onTap: (){
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

 static showEmptyCategoryAlertDialog(BuildContext context) {
   Widget okButton = GestureDetector(
     child: Container(
       padding: EdgeInsets.all(10),
       child: isArabic(context) ? const Text("تم") : const Text("Done"),
     ),
     onTap: (){
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
                   child: Image.asset('assets/images/nooffers.png')
               ),
             ],
           ),
           const Divider(),
           ListTile(
             title: isArabic(context)
                 ? const Text(
               'لا يوجد عروض على هذا الصنف في الوقت الحالي.',
               style: TextStyle(fontSize: 17),
             )
                 : const Text(
               'There are no offers for this category at the moment.',
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

   Widget okButton = GestureDetector(
     child: Container(
       padding: EdgeInsets.all(10),
       child: isArabic(context) ? const Text("تم") : const Text("Done"),
     ),
     onTap: (){
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
   Widget okButton = GestureDetector(
     child: Container(
       padding: EdgeInsets.all(10),
       child: isArabic(context) ? const Text("تم") : const Text("Done"),
     ),
     onTap: (){
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
 static showDeleteAccountConfirmationDialog(BuildContext context) {

   // set up the buttons
   Widget cancelButton = TextButton(
     child: Text(isArabic(context) ? "إلغاء" :"Cancel"),
     onPressed:  () {
       Navigator.pop(context);
     },
   );
   Widget continueButton = TextButton(
     child: Text(isArabic(context) ? "تأكيد" :"Confirm"),
     onPressed:  () async {
       Timer? _timer;
       EasyLoading.addStatusCallback((status) {
         print('EasyLoading Status $status');
         if (status == EasyLoadingStatus.dismiss) {
           _timer?.cancel();
         }
       });
       _timer?.cancel();
       await EasyLoading.show(
           status: 'loading...',
           maskType: EasyLoadingMaskType.black,
           dismissOnTap: false
       );
       try{
         FirebaseAuth.instance.currentUser?.delete().then((value) async => {
           _timer?.cancel(),
           await EasyLoading.dismiss(),
       });
       Navigator.of(context, rootNavigator: true).pop('dialog');
         Navigator.push(
           context,
           MaterialPageRoute(
               builder: (context) =>
               const HomeScreen()),
         );
       LoginHelper.showSuccessAlertDialog(context, isArabic(context) ? "تم حذف الحساب" : "Account has been deleted");

       }catch(e){
         LoginHelper.showErrorAlertDialog(context, isArabic(context) ? "حدث خطأ أثناء حذف الحساب" : "Error while deleting account");
       }

       },
   );

   // set up the AlertDialog
   AlertDialog alert = AlertDialog(
     content: isArabic(context) ? Text("هل أنت متأكد من حذف حسابك ؟")
         :Text("Are you sure to delete your account ?"),
     actions: [
       cancelButton,
       continueButton,
     ],
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