import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:souq/Helpers/ImageHelper.dart';
import '../../Helpers/LoginHelper.dart';
import '../blocs/CategoriesRepoitory.dart';
import '../blocs/StoryTimeRepo.dart';
import '../models/CategoryList.dart';
import '../models/CategoryModel.dart';
import '../models/Store.dart';
import '../models/StoryItem.dart';
import '../models/UserModel.dart';
import '../models/UserStore.dart';
import 'HomeScreen.dart';
import 'NotificationBadge.dart';
import 'ProfilePage.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({Key? key}) : super(key: key);

  @override
  _AddPostPageState createState() => _AddPostPageState();
}
// late final FirebaseMessaging _messaging;
// PushNotification? _notificationInfo;

class _AddPostPageState extends State<AddPostPage> {
  XFile? imageFile;
  final box = GetStorage();
  CategoriesRepository repository = CategoriesRepository();
  StoryTimeRepo repositoryStoryTimeRepo = StoryTimeRepo();
  final TextEditingController _descriptionController = TextEditingController();
  int? dropdownvalue;
  //int dropdownDaysvalue = 1;
  // define a list of options for the dropdown
  final List<String> DaysList = ["1", "2", "3","4", "5", "6", "7"];

  // the selected value
  String? _selectedDays;
  bool isLoading = false;
  Timer? _timer;
  @override
  void initState() {

    super.initState();
    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurpleAccent,
          automaticallyImplyLeading: false,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(15),
                  bottomLeft: Radius.circular(15))),
          title: Center(

                child: Image.asset('assets/images/offerstorylogo.png',height: MediaQuery.of(context).size.width * 0.4,width: MediaQuery.of(context).size.width * 0.4,),



          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [

                  SizedBox(height: MediaQuery.of(context).size.height * .05),
                  LimitedBox(
                    maxHeight: MediaQuery.of(context).size.height * .05,
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
                                    Text('إضافة صور',style: TextStyle(
                                        fontWeight:FontWeight.bold ,   fontFamily:'SouqFont',fontSize: 16)),
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
                                    Text('Add Photos',style: TextStyle(
                                        fontWeight:FontWeight.bold ,   fontFamily:'SouqFont',fontSize: 16)),
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
                        height: MediaQuery.of(context).size.height * 0.05,
                        width: MediaQuery.of(context).size.width * 0.15,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/placeholder.png'),
                            fit: BoxFit.fill,
                          ),
                         // shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .05),
                  LimitedBox(
                    maxHeight: MediaQuery.of(context).size.height * 0.25,
                    maxWidth: MediaQuery.of(context).size.width,
                    child: DropdownButton<String>(
                      value: _selectedDays,
                      onChanged: (value) {
                        setState(() {
                          _selectedDays = value;
                        });
                      },
                      hint: Center(
                          child: isArabic(context)
                              ? const Text(
                            "عدد أيام القصة",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                              : Text(
                            "Day of story",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'SouqFont'),
                          )),
                      // Hide the default underline
                      underline: Container(),
                      // set the color of the dropdown menu
                      dropdownColor: Colors.white,
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.black,
                      ),
                      // isExpanded: true,

                      // The list of options
                      items: DaysList.map((e) => DropdownMenuItem(
                        value: e,
                        child: Container(
                          alignment: Alignment.center,
                          child: isArabic(context) ? Text(
                            e + " " +"يوم",
                            style: const TextStyle(fontSize: 16),
                          ) : Text(
                            e +" "+ "Day(s)",
                            style: const TextStyle(fontSize: 16),
                          ) ,
                        ),
                      )).toList(),

                      // Customize the selected item
                      selectedItemBuilder: (BuildContext context) =>
                          DaysList.map((e) => Center(
                            child: Text(
                              e,
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          )).toList(),
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
                                  fontFamily:'SouqFont'
                              ),
                            )
                          : const Text(
                              "Descriptions",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                  fontFamily:'SouqFont'
                              ),
                            ),
                    ),
                  ),
                  TextField(
                    controller: _descriptionController,
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
                              MediaQuery.of(context).size.height * .25,
                              MediaQuery.of(context).size.height * .07),
                          minimumSize: Size(
                              MediaQuery.of(context).size.height * .25,
                              MediaQuery.of(context).size.height * .07),
                          primary: Colors.black,
                          shape: StadiumBorder(),
                        ),
                        onPressed: _selectedDays == null || dropdownvalue == null || imageFile == null ? null: () async{
                          _timer?.cancel();
                          await EasyLoading.show(
                              status: 'loading...',
                              maskType: EasyLoadingMaskType.black,
                              dismissOnTap: false
                          );
                          print('EasyLoading show');
                          setState(() {
                            isLoading = true;
                          });
                          UserStore userStore = await loadStore(context);
                          File? file = await compressFile(File(imageFile!.path));
                          print("Size before : ${File(imageFile!.path).lengthSync()}");
                          print("Size After : ${File(file!.path).lengthSync()}");
                          XFile compressedImage = XFile(file.path);
                          Uint8List? bytes = await compressedImage.readAsBytes();
                          String img = base64Encode(bytes);
                          StoryContent storyContent = StoryContent(ImageHelper.idGenerator(),img, dropdownvalue!, _descriptionController.text, int.parse(_selectedDays!), DateTime.now().millisecondsSinceEpoch,[]);
                          List<dynamic> list = [];
                          list.add(storyContent.toJson());
                          print(storyContent.toJson());
                          try {
                            await FirebaseFirestore.instance
                                .collection('Store')
                                .doc(userStore.userModel.storeId)
                                .update(
                                {'Stories': FieldValue.arrayUnion(list)}).then((
                                value) async =>
                            {
                            setState(() {
                            isLoading = false;
                            }),
                              _timer?.cancel(),
                              await EasyLoading.dismiss(),
                              LoginHelper.showSuccessAlertDialog(context, isArabic(context) ? "تمت إضافة قصتك بنجاح ، يمكنك إضافة المزيد من القصص من خلال هذه الصفحة" :
                                  "Your Story has been shared successfully, you can add more stories from this page."),
                            });
                          }on FirebaseException catch  (e) {
                            LoginHelper.showErrorAlertDialog(context, e.message.toString());
                            print(e.message);
                            setState(() {
                              isLoading = false;
                            });


                             }  // show a notification at top of screen.

                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //    crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                                isArabic(context) ? 'إضافة الإعلان' : 'Submit',style: TextStyle(
                                fontWeight:FontWeight.bold ,   fontFamily:'SouqFont',fontSize: 16)),
                            isLoading ? CircularProgressIndicator() :Icon(
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
          height: MediaQuery.of(context).size.height * 0.07,
          style: TabStyle.fixedCircle,
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

  Future<UserStore> loadStore(BuildContext context)async{
    late Store store;
    late UserModel user;

    await FirebaseFirestore.instance.collection('Users').where(
        'email', isEqualTo: FirebaseAuth.instance.currentUser?.email)
        .get()
        .then((value) =>
        value.docs.forEach((doc) {
          user = UserModel.fromJson(value.docs.first.data());
          print(user.name);
        }));

    DocumentSnapshot snap;

    await FirebaseFirestore.instance.collection('Store').doc(user.storeId)
        .get().then((value) => {
      snap = value,
      store = Store.fromSnapshot(snap),
      print(store.nameAr),
    });

    UserStore userStore = UserStore(user, store);
    return userStore;
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
                  title: Text(isArabic(context) ? 'الاستوديو' : 'Gallery',style: TextStyle(
          fontFamily:'SouqFont')),
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
                  title: Text(isArabic(context) ? 'الكاميرا' : 'Camera',style: TextStyle(
          fontFamily:'SouqFont')),
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
    var list = isArabic(context) ? CategoryList.categoryListFromJson(snapshots!['CategoryListAr'] as Map<String, dynamic>)
        : CategoryList.categoryListFromJson(snapshots!['CategoryList'] as Map<String, dynamic>);
    print(list.first.name);
    print("lwngth "   + list.length.toString());
    List<CategoryModel> listOfCategories = [];
    for(int i =0 ;i < list.length; i++){
      listOfCategories.add(CategoryModel(list[i].name,list[i].value));
    }
    return DropdownButton(
      hint: Center(
          child: isArabic(context)
              ? const Text(
            "  اختر الفئة",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          )
              : Text(
            "Choose Category  ",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'SouqFont'),
          )),
      // Hide the default underline
      underline: Container(),
      // set the color of the dropdown menu
      dropdownColor: Colors.white,

      // Down Arrow Icon
      icon: const Icon(Icons.keyboard_arrow_down),
      value: dropdownvalue,
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
      },
      selectedItemBuilder: (BuildContext context) =>
          listOfCategories.map((CategoryModel item) => Center(
            child: Text(
              item.type,
              style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          )).toList(),);
  }


  void _openGallery(BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery
    );
    setState(() {
      imageFile = pickedFile!;
    });

    Navigator.pop(context);
  }

  void _openCamera(BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      imageFile = pickedFile!;
    });

    Navigator.pop(context);
  }

  bool isArabic(BuildContext context) {
    return context.locale.languageCode == 'ar';
  }

  Future<File?> compressFile(File file) async {
    final filePath = file.absolute.path;

    final lastIndex = filePath.lastIndexOf(RegExp(r'.jp'));
    final splitted = filePath.substring(0, (lastIndex));
    final outPath = "${splitted}_out${filePath.substring(lastIndex)}";
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path, outPath,
      quality: 50,
      minHeight: 700,
      minWidth: 700
    );

    print(file.lengthSync());
    print(result?.lengthSync());

    return result;
  }

  showCategoryAlertDialog(BuildContext context) {
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
////////////////////////
