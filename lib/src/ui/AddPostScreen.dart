import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../blocs/CategoriesRepoitory.dart';
import '../blocs/StoryTimeRepo.dart';
import '../models/CategoryList.dart';
import '../models/CategoryModel.dart';
import '../models/StoryTimeList.dart';
import '../models/StoryTimeModel.dart';
import 'HomeScreen.dart';
import 'ProfilePage.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({Key? key}) : super(key: key);

  @override
  _AddPostPageState createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  PickedFile? imageFile = null;
  final box = GetStorage();
  CategoriesRepository repository = CategoriesRepository();
  StoryTimeRepo repositoryStoryTimeRepo = StoryTimeRepo();
  @override
  void initState() {
    super.initState();
  }

  int dropdownvalue = 1;
  int dropdownDaysvalue = 1;


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
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  LimitedBox(
                    maxHeight: MediaQuery.of(context).size.height * 0.25,
                    maxWidth: MediaQuery.of(context).size.width,
                    child: StreamBuilder<QuerySnapshot>(
                        stream: repository.getCategoriesStream(),
                        builder: (context, snapshot) {

                          if (!snapshot.hasData)
                            return const LinearProgressIndicator();
                          return _buildCategoriesList(context, snapshot.data?.docs ?? []);
                        }),
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height * .05),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.width * 0.05,
                            left: MediaQuery.of(context).size.width * 0.2,
                            right: MediaQuery.of(context).size.width * 0.1,
                            bottom: MediaQuery.of(context).size.width * 0.05),
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
                                  children: const [
                                    Text('Add Photos'),
                                    Icon(
                                      Icons.add_photo_alternate_outlined,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                      ),
                      imageFile !=  null ? LimitedBox(
                        maxHeight: MediaQuery.of(context).size.height * 0.2,
                        maxWidth: MediaQuery.of(context).size.width * 0.25,
                        child: Container(
                          child: Image(
                            image: FileImage(File(imageFile!.path.toString())),
                          ),
                        ),
                      ):Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        width: MediaQuery.of(context).size.width * 0.25,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/placeholder.png'),
                            fit: BoxFit.fill,
                          ),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
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
                        "عدد أيام القصة",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                          : const Text(
                        "Day of story",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  LimitedBox(
                    maxHeight: MediaQuery.of(context).size.height * 0.25,
                    maxWidth: MediaQuery.of(context).size.width,
                    child: StreamBuilder<QuerySnapshot>(
                        stream: repositoryStoryTimeRepo.getStoryTimeStream(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData)
                            return const LinearProgressIndicator();
                          return _buildDaysList(context, snapshot.data?.docs ?? []);
                        }),
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
  Widget _buildCategoriesList(BuildContext context, List<DocumentSnapshot>? snapshot) {
    var snapshots = snapshot?.first;
    var list = snapshot!
        .map((data) => CategoryList.fromJson(snapshots!['CategoryList']))
        .toList();

    List<CategoryModel> listOfCategories = [];
    for(int i =0 ;i < list.first.toJson().entries.length; i++){
      if(list.first.toJson().entries.toList().elementAt(i).value != null)
      listOfCategories.add(CategoryModel(list.first.toJson().entries.toList().elementAt(i).key,list.first.toJson().entries.toList().elementAt(i).value));
    }
    return DropdownButton(
      // Down Arrow Icon
        icon: const Icon(Icons.keyboard_arrow_down),
        value:  dropdownvalue,

        items: listOfCategories.map((CategoryModel item) {
          return DropdownMenuItem(
            value: item.value,
            child: Text(item.type),
          );
        }).toList(),

        onChanged: (int? newValue) {
          setState(() {
            dropdownvalue = newValue!;
          });
        });
  }
  Widget _buildDaysList(BuildContext context, List<DocumentSnapshot>? snapshot) {
    var snapshots = snapshot?.first;

    print(snapshot?.first.data());
    var list = snapshot!
        .map((data) => StoryDurration.fromJson(snapshots!['StoryDurration']))
        .toList();

    print(list.first.toJson());
    List<StoryTimeModel> listOfDurrations = [];
    for(int i =0 ;i < list.first.toJson().entries.length; i++){
      if(list.first.toJson().entries.toList().elementAt(i).value != null)
      listOfDurrations.add(StoryTimeModel(list.first.toJson().entries.toList().elementAt(i).key,list.first.toJson().entries.toList().elementAt(i).value));
    }
    return DropdownButton(
      // Down Arrow Icon
        icon: const Icon(Icons.keyboard_arrow_down),
        value:  dropdownDaysvalue,

        items: listOfDurrations.map((StoryTimeModel item) {
          return DropdownMenuItem(
            value: item.value,
            child: Text(item.Day),
          );
        }).toList(),

        onChanged: (int? newValue) {
          setState(() {
            dropdownDaysvalue = newValue!;
          });
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
