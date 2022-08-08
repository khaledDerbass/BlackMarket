import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'CustomProfileAppBar.dart';
import 'HomeScreen.dart';

class StoreRegisteration extends StatefulWidget
{
  const StoreRegisteration({Key? key}) : super(key: key);

  @override
  StoreRegisterationState createState() => StoreRegisterationState();
}
class StoreRegisterationState extends State<StoreRegisteration> {

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
          child: Text( isArabic(context) ? 'التسجيل كمتجر' : "Registration as Store"),
        ),
      ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * .07,
                  left: MediaQuery.of(context).size.height * .05,
                  right: MediaQuery.of(context).size.height * .05,
                ),
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        fillColor: Colors.transparent,
                        labelText:  isArabic(context) ? 'الإسم بالعربي' : 'Arabic Name',
                        filled: true,
                      ),
                    ),
                    SizedBox(height:  MediaQuery.of(context).size.height * .05),
                    TextField(
                      decoration: InputDecoration(
                        fillColor: Colors.transparent,
                        filled: true,
                        labelText:  isArabic(context) ? 'الإسم بالإنجليزية' : 'English Name',
                      ),
                    ),
                    SizedBox(height:  MediaQuery.of(context).size.height * .05),
                    TextField(
                      decoration: InputDecoration(
                        fillColor: Colors.transparent,
                        filled: true,
                        labelText: isArabic(context) ? 'البريد الإلكتروني' : 'Email',
                      ),
                    ),
                    SizedBox(height:  MediaQuery.of(context).size.height * .05),
                    TextField(
                      decoration: InputDecoration(
                        fillColor: Colors.transparent,
                        filled: true,
                        labelText: isArabic(context) ? 'رقم الهاتف' : 'Phone',
                      ),
                    ),
                    SizedBox(height:  MediaQuery.of(context).size.height * .05),
                    TextField(
                      decoration: InputDecoration(
                        fillColor: Colors.transparent,
                        filled: true,
                        labelText: isArabic(context) ? 'نوع البضاعة' : 'Type of product',
                      ),
                    ),
                    SizedBox(height:  MediaQuery.of(context).size.height * .05),
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        fillColor: Colors.transparent,
                        filled: true,
                        labelText: isArabic(context) ? 'كلمة السر' : 'Password',
                      ),
                    ),
                    SizedBox(height:  MediaQuery.of(context).size.height * .05),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              maximumSize: Size(MediaQuery.of(context).size.height * .20, MediaQuery.of(context).size.height * .07),
                              minimumSize: Size(MediaQuery.of(context).size.height * .20, MediaQuery.of(context).size.height * .07),
                              primary: Colors.black,
                              shape: const StadiumBorder(),
                            ),
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()),
                              );
                            },
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              //crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text( isArabic(context) ? 'التسجيل' : 'REGISTER'),
                                Icon(
                                  Icons.content_paste_rounded,
                                  color: Colors.white,
                                ),
                              ],
                            )),
                      ],),
                  ],
                ),
              ),
            ),
          ],
        ),
    );
  }
  bool isArabic(BuildContext context) {
    return context.locale.languageCode == 'ar';
  }
}