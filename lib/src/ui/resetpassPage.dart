import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'CustomProfileAppBar.dart';

class resetPassword extends StatefulWidget {
  const resetPassword({Key? key}) : super(key: key);

  @override
  _resetPasswordState createState() => _resetPasswordState();
}

class _resetPasswordState extends State<resetPassword> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: NestedScrollView(
        headerSliverBuilder: (context,index) {
          return [
            CustomProfileAppBar(),
          ];
        },
          body: Stack(
                children: [
                  Container(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * .15,
                    left: MediaQuery.of(context).size.height * .05,
                    right: MediaQuery.of(context).size.height * .05,
                  ),
                  child: Column(
                    children: [
                      TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: isArabic(context) ? 'البريد الإلكتروني' : 'Email',
                          fillColor: Colors.transparent,
                          filled: true,
                          // hintText: 'Password',
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * .10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                maximumSize: Size(MediaQuery.of(context).size.height * .20, MediaQuery.of(context).size.height * .07),
                                minimumSize: Size(MediaQuery.of(context).size.height * .20, MediaQuery.of(context).size.height * .07),
                                primary: Colors.black,
                                shape: StadiumBorder(),
                              ),
                              onPressed: () {},
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                //crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text( isArabic(context) ? 'إعادة تعيين' : "Reset now"),                                  Icon(
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