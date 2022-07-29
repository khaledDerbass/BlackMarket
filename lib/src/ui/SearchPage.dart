
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../blocs/StoreRepository.dart';
import '../models/Store.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {

    return _SearchPageState();
  }

}


class _SearchPageState extends State<SearchPage>{
  final myController = TextEditingController();
  StoreRepository repository = StoreRepository();
  late Stream streamQuery;
  List<Store> storesList = [];
  List<String> storeNames = [];
  List<String> filteredStoreNames = [];
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    print("xxxxxxx " + filteredStoreNames.toString());
    return MaterialApp(
      home: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Colors.deepPurple,
            shape: const RoundedRectangleBorder(

                borderRadius:  BorderRadius.only(

                    bottomRight: Radius.circular(35),

                    bottomLeft: Radius.circular(35))

            ),
            leading: Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
              child:IconButton(
                  onPressed:() => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back_ios,
                  )),

            ),
            leadingWidth: MediaQuery.of(context).size.width * 0.07,
            title: Container(
              //isArabic(context) ? const Text('الرئيسية') :const Text('Home'),
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.05,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: CupertinoColors.white,
              ),
              child:  Center(
                child: TextField(
                    autofocus:true,
                onChanged: (x) {
                      storeNames.clear();
                      filteredStoreNames.clear();
                   repository.collection.get().then((value) => {
                   setState(() {
                     storeNames.addAll(value.docs.map((e) => Store.fromSnapshot(e).nameEn));
                     filteredStoreNames.addAll(storeNames.where((element) => element.toLowerCase().startsWith(x.toLowerCase())));
                   }),
                   });



                },
                  controller: myController,
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

          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: ListView.separated(
              scrollDirection: Axis.vertical,
              itemCount: filteredStoreNames.length,
              itemBuilder: (context, index){
                return ListTile(
                  title:  Text(filteredStoreNames[index],style: const TextStyle(fontSize: 20),),

                );
              }, separatorBuilder: (context,index) {
              return const Divider();
            },
            ),
          ),
      ),
    );

  }
}

bool isArabic(BuildContext context){
  return context.locale.languageCode == 'ar';
}




