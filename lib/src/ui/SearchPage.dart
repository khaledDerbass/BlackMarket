import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:souq/src/models/UserStore.dart';
import '../blocs/StoreRepository.dart';
import '../models/Store.dart';
import '../models/UserModel.dart';
import 'ProfilePage.dart';

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
  List<Store> stores = [];
  List<Store> filteredStore = [];
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Colors.deepPurple,
            shape: const RoundedRectangleBorder(

                borderRadius:  BorderRadius.only(

                    bottomRight: Radius.circular(28),

                    bottomLeft: Radius.circular(28))

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
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.06,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: CupertinoColors.white,
              ),
              child:  Center(
                child: TextField(
                    autofocus:true,
                onChanged: (x) {
                  stores.clear();
                  filteredStore.clear();
                   repository.collection.get().then((value) async => {
                   setState(()  {
                     stores.addAll(value.docs.map((e) => Store.fromSnapshot(e)));
                     filteredStore.addAll(stores.where((element) => element.nameAr.toLowerCase().startsWith(x.toLowerCase()) || element.nameEn.toLowerCase().startsWith(x.toLowerCase())));
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
              itemCount: filteredStore.length,
              itemBuilder: (context, index){
                return ListTile(
                  title:  Text(isArabic(context) ? filteredStore[index].nameAr : filteredStore[index].nameEn,style: const TextStyle(fontSize: 20),),
                  onTap: (){


                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>  profilepage(searchStore: filteredStore[index])),
                    );
                  },
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




