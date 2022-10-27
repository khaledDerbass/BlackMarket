import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'CustomProfileAppBar.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  AboutUsState createState() => AboutUsState();
}

class AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Material(
        child: NestedScrollView(
            headerSliverBuilder: (context, index) {
              return [
                CustomProfileAppBar(false),
              ];
            },

/*
         body: Column( children:[
           isArabic(context) ?
           Text("يساعدك تطبيق اوفر ستوري على نشر عروضك المميزة حتى يصل لأكبر عدد من الجمهور.")
           : Text("Offer Story helps you publish your special offers to reach the largest number of audience."),

           isArabic(context) ?
           Text("تواصل معنا على الفيسبوك")
           : Text("Contact us on Facebook "),

           Text("www.facebook.com/OfferStoryApp"),

           isArabic(context) ?
           Text("او على حساب الانستغرام")
           :  Text("or on Instagram"),
           Text("www.instagram.com/offerstory.app"),


         ])*/
            body: Column(children: [
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * .02,
                  left: MediaQuery.of(context).size.height * .02,
                  right: MediaQuery.of(context).size.height * .02,
                ),
                child: isArabic(context)
                    ? Text(
                        "يساعدك تطبيق اوفر ستوري على نشر عروضك المميزة حتى يصل لأكبر عدد من الجمهور.",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'SouqFont',
                        fontSize: 16))
                    : Text(
                        "Offer Story helps you publish your special offers to reach the largest number of audience.",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SouqFont',
                            fontSize: 16)),),
    SizedBox(height: MediaQuery.of(context).size.height * .03),
    LimitedBox(
    maxHeight: MediaQuery.of(context).size.height * .7,
    maxWidth: MediaQuery.of(context).size.width,
    child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: <Widget>[
                    TextButton(
                      child: Text(isArabic(context)
                          ? "التواصل معنا عبر صفحة الفيسبوك "
                          : "Contact us on Facebook"),


                      onPressed: () async {
                        final url =  Uri.parse('https://www.facebook.com/OfferStoryApp');  //Twitter's URL
                        await launchUrl(url);                      },
                    ),
                    TextButton(
                      child: Text(isArabic(context)
                          ? "او على حساب الانستغرام"
                          : "Contact us on Instagram"),


                      onPressed: () async {
                        final url = Uri.parse('https://www.instagram.com/offerstory.app/');

                        await launchUrl(url);
                        },
                    ),

                  ],
                ),
    )
            ])));
  }

  bool isArabic(BuildContext context) {
    return context.locale.languageCode == 'ar';
  }
}
