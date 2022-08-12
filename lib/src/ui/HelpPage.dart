import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'CustomProfileAppBar.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  HelpPageState createState() => HelpPageState();
}

class HelpPageState extends State<HelpPage> {
  bool isSwitched = true;
  bool enabledBut = false;
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
                top: MediaQuery.of(context).size.height * .10,
                left: MediaQuery.of(context).size.height * .05,
                right: MediaQuery.of(context).size.height * .05,
              ),
              child: ListView(
                children: [
                  Align(
                    alignment: isArabic(context)
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.width * 0.10,
                          left: MediaQuery.of(context).size.width * 0.02,
                          right: MediaQuery.of(context).size.width * 0.02),
                      child: isArabic(context)
                          ? const Text(
                        "الإبلاغ عن مشكلة",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                          : const Text(
                        "Report a Problem",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  TextField(
                    maxLines: 5,
                    decoration: InputDecoration(
                      labelText: isArabic(context)
                          ? 'أدخل وصف المشكلة هنا'
                          : 'Enter the description here',
                      fillColor: Colors.transparent,

                      border: InputBorder.none,
                    ),
                  ),
                  Align(
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.width * 0.10,
                          left: MediaQuery.of(context).size.width * 0.01,
                          right: MediaQuery.of(context).size.width * 0.01),
                      child: isArabic(context)
                          ? ElevatedButton(

                          style: ElevatedButton.styleFrom(enableFeedback: enabledBut,

                            maximumSize: Size(
                                MediaQuery.of(context).size.height * .20,
                                MediaQuery.of(context).size.height * .05),
                            minimumSize: Size(
                                MediaQuery.of(context).size.height * .20,
                                MediaQuery.of(context).size.height * .05),
                            primary: Colors.black,
                          ),
                          onPressed:  null,
                          child: Row(

                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('تقديم'),
                              Icon(
                                Icons.done_outline,
                                color: Colors.white,
                              ),
                            ],
                          ))
                          : ElevatedButton(
                          style: ElevatedButton.styleFrom(

                            maximumSize: Size(
                                MediaQuery.of(context).size.height * .20,
                                MediaQuery.of(context).size.height * .05),
                            minimumSize: Size(
                                MediaQuery.of(context).size.height * .20,
                                MediaQuery.of(context).size.height * .05),
                            primary: Colors.black,
                          ),
                          onPressed: null,
                            child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('Report'),
                              Icon(
                                Icons.done_outline_outlined,
                                color: Colors.white,
                              ),
                            ],
                          )),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                      title: isArabic(context)
                          ? const Text(
                        'مركز المساعدة والدعم',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),                )
                          : const Text(
                        'Help & Support Center',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () => {

                      }),
            ],),),
          ],),),
    );
  }
  bool isArabic(BuildContext context) {
    return context.locale.languageCode == 'ar';
  }
}