import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:souq/Helpers/GEnums.dart';
import 'package:souq/src/Services/AuthenticationService.dart';
import 'package:souq/src/blocs/StoreRepository.dart';
import 'package:souq/src/models/CategoryWidget.dart';
import 'package:souq/src/models/Store.dart';
import 'package:souq/src/models/StoryItem.dart';
import 'package:souq/src/models/UserModel.dart';
import 'package:souq/src/ui/SearchPage.dart';
import 'package:flutter_stories/flutter_stories.dart';
import '../../Helpers/LoginHelper.dart';
import 'AddPostScreen.dart';
import 'SideBar Home.dart';
import 'ProfilePage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  final myController = TextEditingController();
  PickedFile? imageFile = null;
  late int roleId;
  final box = GetStorage();
  @override
  void initState() {
    super.initState();
  }

  String dropdownValue = 'Amman';

  @override
  Widget build(BuildContext context) {
    //
    // roleId = box.read("roleID");

    /*
            title: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
                children:
            [
            DropdownButton(
                    value: dropdownValue,
                    items: const [
                      DropdownMenuItem(
                        value: "Amman",
                        child: Text("Amman"),
                      ),
                      DropdownMenuItem(
                        value: "Irbid",
                        child: Text("Irbid"),
                      ),
                      DropdownMenuItem(
                        value: "Zarqa",
                        child: Text("Zarqa"),
                      )
                    ],
                    underline: SizedBox(height: 0,),
                    onChanged: (value){
                      setState(() {
                        dropdownValue = value.toString();
                      });
                    },
                    style: TextStyle(fontSize: 20, color: Colors.white),
                    dropdownColor: Colors.deepPurpleAccent,
                    iconEnabledColor: Colors.white, //Icon color
                  ),*/
    StoreRepository repository = StoreRepository();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        drawer: SideDrawer(),
        backgroundColor: CupertinoColors.white,
        appBar: AppBar(
          backgroundColor: Colors.deepPurpleAccent,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(35),
                  bottomLeft: Radius.circular(35))),
          title: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.05,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: CupertinoColors.white,
            ),
            child: Center(
              child: TextField(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SearchPage()),
                  );
                },
                controller: myController,
                showCursor: false,
                readOnly: true,
                decoration: InputDecoration(
                  hintText: isArabic(context) ? 'إبحث عن متجر' : 'Search Store',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      myController.text = "";
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
        body: SafeArea(
            child: Column(
          children: [
            LimitedBox(
              maxHeight: MediaQuery.of(context).size.height * 0.25,
              maxWidth: MediaQuery.of(context).size.width,
              child: StreamBuilder<QuerySnapshot>(
                  stream: repository.getStores(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return const LinearProgressIndicator();
                    return _buildList(context, snapshot.data?.docs ?? []);
                  }),
            ),
            Align(
                alignment: isArabic(context)
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.02,
                      right: MediaQuery.of(context).size.width * 0.02),
                  child: isArabic(context)
                      ? const Text(
                          "التصنيفات",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : const Text(
                          "Categories",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                )),
            LimitedBox(
              maxHeight: MediaQuery.of(context).size.height * 0.25,
              maxWidth: MediaQuery.of(context).size.width,
              child: StreamBuilder<QuerySnapshot>(
                  stream: repository.getStores(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return const LinearProgressIndicator();
                    return _buildCategoryList(
                        context, snapshot.data?.docs ?? []);
                  }),
            ),
          ],
        )),
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
                title: isArabic(context) ? 'الحساب' : 'Account'),
          ],
          initialActiveIndex: 0, //optional, default as 0
          onTap: (int i) => {
            if (i == 1)
              {
                if (AuthenticationService.isCurrentUserLoggedIn())
                  {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddPostPage()),
                    ),
                  }
                else
                  {
                    LoginHelper.showLoginAlertDialog(context),
                  }

                //_showChoiceDialog(context),
              }
            else if (i == 2)
              {
                if (AuthenticationService.isCurrentUserLoggedIn())
                  {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const profilepage()),
                    ),
                  }
                else
                  {
                    LoginHelper.showLoginAlertDialog(context),
                  }
              }
          },
        ),
      ),
    );
  }
}

Widget _buildCategoryList(
    BuildContext context, List<DocumentSnapshot>? snapshot) {
  List<Store> storesList = [];
  List<int> categories = [];
  List<CategoryWidget> categoryWidgets = [];
  List<StoryContent> storyByCategory = [];
  List<Widget> widgetsList = [];
  snapshot!
      .map((data) => {
            storesList.add(Store.fromSnapshot(data)),
            if (!categories.contains(Store.fromSnapshot(data).category))
              {categories.add(Store.fromSnapshot(data).category)}
          })
      .toList();

  for (int category in categories) {
    for (Store store in storesList) {
      if (store.isApprovedByAdmin) {
        storyByCategory.addAll(
            store.stories.where((e) => e.category == category).toList());
      }
    }
    if (storyByCategory.isEmpty) {
      continue;
    }
    List<String> imgs = [];
    for (StoryContent sc in storyByCategory) {
      imgs.add(sc.img);
    }
    CategoryWidget categoryWidget = new CategoryWidget(
        storyByCategory.last.img, Category.fromId(category).name, imgs);
    categoryWidgets.add(categoryWidget);
    storyByCategory.clear();
  }

  for (CategoryWidget cw in categoryWidgets) {
    widgetsList.add(CupertinoPageScaffold(
      backgroundColor: CupertinoColors.white,
      child: Padding(
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.004,
            right: MediaQuery.of(context).size.width * 0.004),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(60.0),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: Image.memory(base64Decode(cw.thumbnailImage)).image,
                  ),
                  border: Border.all(
                    color: CupertinoColors.activeOrange,
                    width: 2.0,
                    style: BorderStyle.solid,
                  ),
                ),
                width: MediaQuery.of(context).size.height * 0.12,
                height: MediaQuery.of(context).size.height * 0.12,
                child: GestureDetector(
                  onTap: () {
                    showCupertinoDialog(
                      context: context,
                      builder: (context) {
                        return CupertinoPageScaffold(
                          child: Story(
                            fullscreen: false,
                            topOffset:
                                MediaQuery.of(context).size.height * 0.06,
                            onFlashForward: Navigator.of(context).pop,
                            onFlashBack: Navigator.of(context).pop,
                            momentCount: cw.images.length,
                            momentDurationGetter: (idx) => Duration(seconds: 5),
                            momentBuilder: (context, index) => Scaffold(
                              body: Container(
                                decoration: BoxDecoration(
                                  color: CupertinoColors.darkBackgroundGray,
                                  image: DecorationImage(
                                    fit: BoxFit.contain,
                                    image: Image.memory(
                                            base64Decode(cw.images[index]))
                                        .image,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.005),
                child: Text(cw.categoryName),
              ),
            ],
          ),
        ),
      ),
    ));
  }
  return ListView(
    scrollDirection: Axis.horizontal,
    padding: const EdgeInsets.only(top: 20.0),
    children: List.of(widgetsList),
  );
}

Widget _buildList(BuildContext context, List<DocumentSnapshot>? snapshot) {
  print(context.locale.languageCode);
  return ListView(
    scrollDirection: Axis.horizontal,
    padding: EdgeInsets.only(
        right: MediaQuery.of(context).size.width * 0.01,
        left: MediaQuery.of(context).size.width * 0.01),
    children: snapshot!
        .map((data) => _buildListItem(
            context, data, Store.fromSnapshot(data).stories.length))
        .toList(),
  );
}

bool isArabic(BuildContext context) {
  return context.locale.languageCode == 'ar';
}

Widget _buildListItem(
    BuildContext context, DocumentSnapshot snapshot, int length) {
  final store = Store.fromSnapshot(snapshot);

  return CupertinoPageScaffold(
    backgroundColor: CupertinoColors.white,
    child: Padding(
      padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.004,
          right: MediaQuery.of(context).size.width * 0.004),
      child: Center(
        child: store.stories.isNotEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60.0),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image:
                            Image.memory(base64Decode(store.stories.last.img))
                                .image,
                      ),
                      border: Border.all(
                        color: CupertinoColors.activeOrange,
                        width: 2.0,
                        style: BorderStyle.solid,
                      ),
                    ),
                    width: MediaQuery.of(context).size.height * 0.12,
                    height: MediaQuery.of(context).size.height * 0.12,
                    child: GestureDetector(
                      onTap: () {
                        showCupertinoDialog(
                          context: context,
                          builder: (context) {
                            return CupertinoPageScaffold(
                              child: Story(
                                fullscreen: false,
                                topOffset:
                                    MediaQuery.of(context).size.height * 0.06,
                                onFlashForward: Navigator.of(context).pop,
                                onFlashBack: Navigator.of(context).pop,
                                momentCount: store.stories.length,
                                momentDurationGetter: (idx) =>
                                    Duration(seconds: 5),
                                momentBuilder: (context, index) => Scaffold(
                                  body: Container(
                                    decoration: BoxDecoration(
                                      color: CupertinoColors.darkBackgroundGray,
                                      image: DecorationImage(
                                        fit: BoxFit.contain,
                                        image: Image.memory(base64Decode(
                                                store.stories[index].img))
                                            .image,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.005),
                    child: isArabic(context)
                        ? Text(store.nameAr)
                        : Text(store.nameEn),
                  ),
                ],
              )
            : Container(),
      ),
    ),
  );
}
