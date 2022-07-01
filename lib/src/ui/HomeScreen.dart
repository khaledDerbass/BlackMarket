import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:souq/Helpers/GEnums.dart';
import 'package:souq/src/blocs/StoreRepository.dart';
import 'package:souq/src/blocs/StoryRepository.dart';
import 'package:souq/src/models/Store.dart';
import 'package:souq/src/models/StoryItem.dart';
import 'package:souq/src/ui/SearchPage.dart';
import 'package:stories_for_flutter/stories_for_flutter.dart' as s;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {

   return _HomeScreenState();
  }

}


class _HomeScreenState extends State<HomeScreen>{
  final myController = TextEditingController();

  @override
  void initState() {
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    context.setLocale(Locale('en', 'US'));
    StoreRepository repository = StoreRepository();
    //repository.addStoreFuture();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: Container(
            //isArabic(context) ? const Text('الرئيسية') :const Text('Home'),
            width: double.infinity,
            height: 35,
           color: Colors.white,
            child:  Center(
              child: TextField(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SearchPage()),
                  );
                },
                controller: myController,
                  showCursor: false,
                  readOnly: true,
              decoration: InputDecoration(
                  hintText: isArabic(context) ? 'إبحث عن متجر' :'Search Store',
                  prefixIcon: Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    myController.text = "";
                  },
                ),),
            ),
          ),
        ),
        ),

          // third overwrite to show query result

        body: Column(
          children: [
            LimitedBox(
              maxHeight: MediaQuery.of(context).size.height * 0.25,
              maxWidth: MediaQuery.of(context).size.width ,
              child: StreamBuilder <QuerySnapshot>(
                  stream: repository.getStores(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const LinearProgressIndicator();
                    return _buildList(context, snapshot.data?.docs ?? []);
                  }),
            ),
            Align(
              alignment: isArabic(context) ? Alignment.centerRight : Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left:  MediaQuery.of(context).size.width * 0.02 , right: MediaQuery.of(context).size.width * 0.02),
                  child: isArabic(context) ? const Text("التصنيفات", style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),): const Text("Categories", style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),),
                )
            ),
            Expanded(
              child: StreamBuilder <QuerySnapshot>(
                  stream: repository.getStores(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const LinearProgressIndicator();
                    return _buildCategoryList(context, snapshot.data?.docs ?? []);
                  }),
            ),
          ],
        ),
          bottomNavigationBar: ConvexAppBar(
            style: TabStyle.fixed,
            color: Colors.yellow.shade600,
            backgroundColor: Colors.deepPurple,
            items:  [
              TabItem(icon: Icons.home, title: isArabic(context) ? 'الرئيسية':'Home'),
              TabItem(icon: Icons.camera_alt, title: isArabic(context) ? 'إضافة' :'Add'),
              TabItem(icon: Icons.people, title: isArabic(context) ? 'الحساب' :'Profile'),
            ],
            initialActiveIndex: 0,//optional, default as 0
            onTap: (int i) => print('click index=$i'),
          )
      ),
    );

  }
}
/*
@override
Widget buildResults(BuildContext context) {
  List<String> matchQuery = [];
  for(Store store in storesList){

      matchQuery.add(fruit);
    }

  return ListView.builder(
    itemCount: matchQuery.length,
    itemBuilder: (context, index) {
      var result = matchQuery[index];
      return ListTile(
        title: Text(result),
      );
    },
  );
}

// last overwrite to show the
// querying process at the runtime
@override
Widget buildSuggestions(BuildContext context) {

  List<String> matchQuery = [];
  for(Store store in storesList){
    {
      matchQuery.add(store.toString());
    }
  }
  return ListView.builder(
    itemCount: matchQuery.length,
    itemBuilder: (context, index) {
      var result = matchQuery[index];
      return ListTile(
        title: Text(result),
      );
    },
  );
}
*/
Widget _buildCategoryList(BuildContext context, List<DocumentSnapshot>? snapshot) {
  List<Store> storesList = [];
  List<int> categories = [];
  List<Widget> categoryWidgets = [];
  List<StoryContent> storyByCategory = [];
  snapshot!.map((data) => {
    storesList.add(Store.fromSnapshot(data)),
    if(!categories.contains(Store.fromSnapshot(data).category)){
          categories.add(Store.fromSnapshot(data).category)
    }
  }).toList();

  for (int category in categories){
    print("category " + category.toString());
    for(Store store in storesList){
      if(store.isApprovedByAdmin){
        storyByCategory.addAll(store.stories.where((e) => e.category == category).toList());
      }
    }
    if(storyByCategory.isEmpty)
      continue;

    categoryWidgets.add(
        s.Stories(
        autoPlayDuration: const Duration(seconds: 5),
        displayProgress: true,
        circlePadding: 2,
        circleRadius: MediaQuery.of(context).size.width / 9,
        storyItemList: [
          s.StoryItem(
              name: Category.fromId(category).name,
              thumbnail: Image.memory(base64Decode(storyByCategory.last.img)).image,
              stories: List.generate(storyByCategory.length, (index) => Scaffold(
                body: Container(
                  decoration:  BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fitWidth,
                      image: Image.memory(base64Decode(storyByCategory[index].img)).image,
                    ),
                  ),
                ),
              ),)),
        ]
    ));
    storyByCategory.clear();
    print("categoryWidgets " + categoryWidgets.length.toString());
  }
  return ListView(
    scrollDirection: Axis.horizontal,
    padding: const EdgeInsets.only(top: 20.0),
    children: categoryWidgets,
  );
}

Widget _buildList(BuildContext context, List<DocumentSnapshot>? snapshot) {
  print(context.locale.languageCode);
  return ListView(
    scrollDirection: Axis.horizontal,
    padding: const EdgeInsets.only(top: 20.0),
    children: snapshot!.map((data) => _buildListItem(context, data,Store.fromSnapshot(data).stories.length)).toList(),
  );
}

bool isArabic(BuildContext context){
  return context.locale.languageCode == 'ar';
}

bool isPortrait (BuildContext context){
  return MediaQuery.of(context).orientation == Orientation.portrait;
}
Widget _buildListItem(BuildContext context, DocumentSnapshot snapshot, int length) {
  final store = Store.fromSnapshot(snapshot);

  return  s.Stories(
    autoPlayDuration: const Duration(seconds: 5),
    displayProgress: true,
    circlePadding: 2,
    circleRadius: MediaQuery.of(context).size.width / 9,
    storyItemList: [
      s.StoryItem(
          name: isArabic(context) ?  store.nameAr : store.nameEn,
          thumbnail: Image.memory(base64Decode(store.stories.last.img)).image,
          stories: List.generate(length, (index) => Scaffold(
            body: Container(
              decoration:  BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fitWidth,
                  image: Image.memory(base64Decode(store.stories[index].img)).image,
                ),
              ),
            ),
          ),)),
    ]
  );
}



