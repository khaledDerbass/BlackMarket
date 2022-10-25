import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'CustomProfileAppBar.dart';
import 'HeaderWidget.dart';

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
                CustomProfileAppBar(false),
              ];
            },
            body: Column(
              children: [
                Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * .02,
                      left: MediaQuery.of(context).size.height * .02,
                      right: MediaQuery.of(context).size.height * .02,
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.width * 0.02,
                          left: MediaQuery.of(context).size.width * 0.02,
                          right: MediaQuery.of(context).size.width * 0.02),
                      child: isArabic(context)
                          ? const Text(
                              "للاستفسارات والإقتراحات حول التطبيق او اي مشكلة تواجهك الرجاء التواصل معنا عبر صفحة الفيسبوك ",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'SouqFont'),
                            )
                          : const Text(
                              "For inquiries and suggestions about the application or any problem you face, please contact us via the Facebook page",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'SouqFont'),
                            ),
                    )),
                SizedBox(height: MediaQuery.of(context).size.height * .03),
                LimitedBox(
                  maxHeight: MediaQuery.of(context).size.height * .7,
                  maxWidth: MediaQuery.of(context).size.width,
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children:[
                      TextButton(
                         child: Text(isArabic(context)
                            ? "التواصل معنا عبر صفحة الفيسبوك "
                            : "Offer Story Facebook page"),
                      onPressed: () async {
    final url =  Uri.parse('https://www.facebook.com/OfferStoryApp');
    await launchUrl(url);
     },
                      ),
                    ],
                  ),
                ),
              ],
            )));
  }

  bool isArabic(BuildContext context) {
    return context.locale.languageCode == 'ar';
  }
}
