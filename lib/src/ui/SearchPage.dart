
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:easy_localization/easy_localization.dart';
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
            title: Container(
              //isArabic(context) ? const Text('الرئيسية') :const Text('Home'),
              width: double.infinity,
              height: 35,
              color: Colors.white,
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




