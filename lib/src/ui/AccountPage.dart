import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'CustomProfileAppBar.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  AccountPageState createState() => AccountPageState();
}

class AccountPageState extends State<AccountPage> {

  @override
  Widget build(BuildContext context) {
    return Material(
      child: NestedScrollView(
        headerSliverBuilder: (context, index) {
          return [
            CustomProfileAppBar(),
          ];
        },
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * .08,
                left: MediaQuery.of(context).size.height * .05,
                right: MediaQuery.of(context).size.height * .05,
              ),
              child: Column(
                children: [
                  TextField(
                    onChanged: (value) {},
                    //controller: _usernameController,
                    decoration: InputDecoration(
                      fillColor: Colors.transparent,
                      labelText:
                          isArabic(context) ? 'اسم المستخدم' : 'Username',
                      filled: true,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .03),
                  TextField(
                    onChanged: (value) {},
                   // controller: _emailController,
                    decoration: InputDecoration(
                      fillColor: Colors.transparent,
                      filled: true,
                      enabled: false,
                      labelText:

                          isArabic(context) ? 'البريد الإلكتروني' : 'Email',
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .03),
                  TextField(
                    onChanged: (value) {},
                   // controller: _phoneController,
                    decoration: InputDecoration(
                      fillColor: Colors.transparent,
                      filled: true,
                      enabled: false,
                      labelText: isArabic(context) ? 'رقم الهاتف' : 'Phone',
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .03),
                  TextField(
                    onChanged: (value) {},
                   // controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      fillColor: Colors.transparent,
                      filled: true,
                      labelText: isArabic(context) ? 'كلمة السر الجديدة' : 'New password',
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .05),
                  TextField(
                    onChanged: (value) {},
                    // controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      fillColor: Colors.transparent,
                      filled: true,
                      labelText: isArabic(context) ? 'إعادة كلمة السر الجديدة' : 'Retype new password',
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            maximumSize: Size(
                                MediaQuery.of(context).size.height * .20,
                                MediaQuery.of(context).size.height * .07),
                            minimumSize: Size(
                                MediaQuery.of(context).size.height * .20,
                                MediaQuery.of(context).size.height * .07),
                            primary: Colors.black,
                            shape: StadiumBorder(),
                          ),
                          onPressed: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                  isArabic(context) ? 'تعديل' : "Modify"),
                              Icon(
                                Icons.refresh,
                                color: Colors.white,
                              ),
                            ],
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isArabic(BuildContext context) {
    return context.locale.languageCode == 'ar';
  }
}
