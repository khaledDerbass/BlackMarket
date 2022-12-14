import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:souq/Helpers/LoginHelper.dart';
import 'package:souq/src/ui/AccountPage.dart';
import 'package:souq/src/ui/HelpPage.dart';
import 'CustomProfileAppBar.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  SettingPageState createState() => SettingPageState();
}

class SettingPageState extends State<SettingPage> {
  bool isSwitched = true;
  @override
  Widget build(BuildContext context) {
    return Material(
      child: NestedScrollView(
        headerSliverBuilder: (context,index) {
          return [
            CustomProfileAppBar(false),
          ];
        },
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * .10,
                left: MediaQuery.of(context).size.height * .05,
                right: MediaQuery.of(context).size.height * .05,
              ),
              child: ListView(
                      children: [
                        ListTile(
                            title: isArabic(context)
                                ? const Text(
                              'الحساب',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                  fontFamily:'SouqFont'
                              ),
                            )
                                : const Text(
                              'Account',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                  fontFamily:'SouqFont'
                              ),
                            ),
                            trailing: Icon(
                              Icons.account_circle_outlined
                              ,
                              color: Colors.black,
                            ),
                            onTap: () => {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>  AccountPage()),
                              ),}
                        ),
                        const Divider(),
                        ListTile(
                            title: isArabic(context)
                                ? const Text(
                              'حذف الحساب',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                                : const Text(
                              'Delete Account',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily:'SouqFont'
                              ),
                            ),
                            trailing: Icon(
                              Icons.delete
                              ,
                              color: Colors.black,
                            ),
                            onTap: () => {
                              LoginHelper.showDeleteAccountConfirmationDialog(context)
                            }),
                        const Divider(),
                        ListTile(
                            title: isArabic(context)
                                ? const Text(
                              'مساعدة',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                                : const Text(
                              'Help',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                  fontFamily:'SouqFont'
                              ),
                            ),
                            trailing: Icon(
                              Icons.live_help_outlined
                              ,
                              color: Colors.black,
                            ),
                            onTap: () => {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HelpPage()),
                              ),
                            }),
                        const Divider(),
                            ],
              ),
    ),
    ],),),
    );
  }
  bool isArabic(BuildContext context) {
    return context.locale.languageCode == 'ar';
  }
}