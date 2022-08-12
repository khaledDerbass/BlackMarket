import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Services/AuthenticationService.dart';
import 'CustomProfileAppBar.dart';
import 'HomeScreen.dart';
import 'ProfilePage.dart';
import 'StoreRegisteration.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({Key? key}) : super(key: key);

  @override
  _AddPostPageState createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  PickedFile? imageFile = null;

  @override
  void initState() {
    super.initState();
  }
  String dropdownvalue ='Al al-Bayt University';
  // List of items in our dropdown menu
  var items = [
    'STS-Specialized Technical Services',
    'Estarta Solutions ',
    'IRIS Technology ',
    'Al al-Bayt University'
  ];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurpleAccent,
          automaticallyImplyLeading: false,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(25),
                  bottomLeft: Radius.circular(25))),
          title: Center(
            child: Text(isArabic(context) ? 'إضافة منشور' : "Add Post"),
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Align(
                      alignment: isArabic(context)
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.width * 0.05,
                            left: MediaQuery.of(context).size.width * 0.02,
                            right: MediaQuery.of(context).size.width * 0.02,
                          bottom: MediaQuery.of(context).size.width * 0.05),
                        child: isArabic(context)
                            ? const Text(
                                "اختر القسم",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : const Text(
                                "Choose Category",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              ),
                      ),
                  ),
                  DropdownButton(
                    // Down Arrow Icon
                      icon: const Icon(Icons.keyboard_arrow_down),
                      value: dropdownvalue,
                      // Array list of items
                      items: items.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }
                      ).toList(),
                      // After selecting the desired option,it will
                      // change button value to selected value
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownvalue = newValue!;
                        });
                      }),
                  Align(
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.width * 0.10,
                          left: MediaQuery.of(context).size.width * 0.01,
                          right: MediaQuery.of(context).size.width * 0.01),
                      child: isArabic(context)
                          ? ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                maximumSize: Size(
                                    MediaQuery.of(context).size.height * .20,
                                    MediaQuery.of(context).size.height * .05),
                                minimumSize: Size(
                                    MediaQuery.of(context).size.height * .20,
                                    MediaQuery.of(context).size.height * .05),
                                primary: Colors.black,
                              ),
                              onPressed: () {
                                _showChoiceDialog(context);
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('إضافة صور'),
                                  Icon(
                                    Icons.add_photo_alternate_outlined,
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
                              onPressed: () {
                                _showChoiceDialog(context);
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('Add Photos'),
                                  Icon(
                                    Icons.add_photo_alternate_outlined,
                                    color: Colors.white,
                                  ),
                                ],
                              )),
                    ),
                  ),
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
                              "وصف الإعلان",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : const Text(
                              "Descriptions",
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
                          ? 'أدخل وصف الإعلان هنا'
                          : 'Enter the description here',
                      fillColor: Colors.transparent,
                      filled: true,
                      border: InputBorder.none,
                    ),
                  ),
                  Align(
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.width * 0.10,
                          left: MediaQuery.of(context).size.width * 0.02,
                          right: MediaQuery.of(context).size.width * 0.02),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          maximumSize: Size(
                              MediaQuery.of(context).size.height * .22,
                              MediaQuery.of(context).size.height * .07),
                          minimumSize: Size(
                              MediaQuery.of(context).size.height * .22,
                              MediaQuery.of(context).size.height * .07),
                          primary: Colors.black,
                          shape: StadiumBorder(),
                        ),
                        onPressed: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                                isArabic(context) ? 'إضافة الإعلان' : 'Submit'),
                            Icon(
                              Icons.done_outline,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: ConvexAppBar(
          style: TabStyle.fixed,
          color: CupertinoColors.white,
          backgroundColor: Colors.deepPurpleAccent,
          items: [
            TabItem(
                icon: Icons.home,
                title: isArabic(context) ? 'الرئيسية' : 'Home'),
            TabItem(
                icon: Icons.camera_alt,
                title: isArabic(context) ? 'إضافة' : 'Add'),
            TabItem(
                icon: Icons.people,
                title: isArabic(context) ? 'الحساب' : 'Profile'),
          ],
          initialActiveIndex: 1, //optional, default as 0
          onTap: (int i) => {
            if (i == 0)
              {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                ),
                //_showChoiceDialog(context),
              }
            else if (i == 2)
              {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const profilepage()),
                ),
              }
          },
        ),
      ),
    );
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: ListBody(
              children: [
                Divider(
                  height: MediaQuery.of(context).size.height * .01,
                  color: Colors.deepPurpleAccent,
                ),
                ListTile(
                  onTap: () {
                    _openGallery(context);
                  },
                  title: Text(isArabic(context) ? 'الاستوديو' : 'Gallery'),
                  leading: Icon(
                    Icons.account_box,
                    color: Colors.deepPurpleAccent,
                  ),
                ),
                Divider(
                  height: 1,
                  color: Colors.deepPurpleAccent,
                ),
                ListTile(
                  onTap: () {
                    _openCamera(context);
                  },
                  title: Text(isArabic(context) ? 'الكاميرا' : 'Camera'),
                  leading: Icon(
                    Icons.camera,
                    color: Colors.deepPurpleAccent,
                  ),
                ),
              ],
            ),
          );
        });
  }

  void _openGallery(BuildContext context) async {
    final pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );
    setState(() {
      imageFile = pickedFile!;
    });

    Navigator.pop(context);
  }

  void _openCamera(BuildContext context) async {
    final pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
    );
    setState(() {
      imageFile = pickedFile!;
    });
    Navigator.pop(context);
  }

  bool isArabic(BuildContext context) {
    return context.locale.languageCode == 'ar';
  }

  showCategoryAlertDialog(BuildContext context) {
    Widget okButton = FlatButton(
      child: isArabic(context) ? const Text("إلغاء") : const Text("Dismiss"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );

    AlertDialog alert = AlertDialog(
      actions: [
        okButton,
      ],
      title: isArabic(context) ? const Text("اللغة") : const Text("Language"),
      content: SizedBox(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height / 5,
        child: ListView(
          children: <Widget>[
            ListTile(
                title: Text(
                  'العربية',
                  style: TextStyle(fontSize: 17),
                ),
                trailing: Image(
                    width: MediaQuery.of(context).size.width * 0.09,
                    image: NetworkImage(
                        'https://icons.iconarchive.com/icons/wikipedia/flags/1024/JO-Jordan-Flag-icon.png')),
                onTap: () => {
                      context.setLocale(Locale('ar', 'JO')),
                      Navigator.of(context, rootNavigator: true).pop('dialog')
                    }),
            const Divider(),
            ListTile(
                title: isArabic(context)
                    ? const Text(
                        'الإنجليزية',
                        style: TextStyle(fontSize: 17),
                      )
                    : const Text(
                        'English',
                        style: TextStyle(fontSize: 17),
                      ),
                trailing: Image(
                    width: MediaQuery.of(context).size.width * 0.09,
                    image: NetworkImage(
                        'https://www.lifepng.com/wp-content/uploads/2021/03/Classic-Uk-Flag-png-hd.png')),
                onTap: () => {
                      context.setLocale(Locale('en', 'US')),
                      Navigator.of(context, rootNavigator: true).pop('dialog')
                    }),
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
