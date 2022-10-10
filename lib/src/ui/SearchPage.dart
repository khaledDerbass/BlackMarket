import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:souq/Helpers/LoginHelper.dart';
import 'package:souq/src/models/UserStore.dart';
import '../Services/AuthenticationService.dart';
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
    return  Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            toolbarHeight: MediaQuery.of(context).size.height * 0.1,
            backgroundColor: Colors.deepPurpleAccent,
            shape: const RoundedRectangleBorder(
                borderRadius:  BorderRadius.only(
                    bottomRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15))
            ),
            leading: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    onPressed:() => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_ios,
                    )),
              ],
            ),
            leadingWidth: MediaQuery.of(context).size.width * 0.15,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  height: MediaQuery.of(context).size.height * 0.055,
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
                         for(Store s in stores){
                           if(s.isApprovedByAdmin && (s.nameAr.toLowerCase().startsWith(x.toLowerCase()) || s.nameEn.toLowerCase().startsWith(x.toLowerCase()))){
                             if(filteredStore.where((element) => element.storeId == s.storeId).toList().isEmpty){
                                filteredStore.add(s);
                             }
                           }

                         }
                         //filteredStore.addAll(stores.where((element) =>  element.isApprovedByAdmin && (element.nameAr.toLowerCase().startsWith(x.toLowerCase()) || element.nameEn.toLowerCase().startsWith(x.toLowerCase()))));
                         filteredStore = filteredStore.toSet().toList();
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
              ],
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
                  onTap: () async{
                    if(AuthenticationService.isCurrentUserLoggedIn()){
                      late UserModel user;
                      late UserModel currentUser;
                      await FirebaseFirestore.instance.collection('Users').where(
                          'storeId', isEqualTo:filteredStore[index].storeId.trim())
                          .get()
                          .then((value) =>
                          value.docs.forEach((doc) {
                            user = UserModel.fromJson(value.docs.first.data());
                            print(user.name);
                          }));

                      await FirebaseFirestore.instance.collection('Users').where(
                          'email', isEqualTo:AuthenticationService.getAuthInstance().currentUser!.email)
                          .get()
                          .then((value) =>
                          value.docs.forEach((doc) {
                            currentUser = UserModel.fromJson(value.docs.first.data());
                            print(user.name);
                          }));

                      if (user != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>  profilepage(searchStore: UserStore(user,filteredStore[index],),currentUser: currentUser,)),
                        );
                      }else{
                        LoginHelper.showErrorAlertDialog(context, "Error");
                      }
                    }else{
                      LoginHelper.showLoginAlertDialog(context);
                    }


                  },
                );
              }, separatorBuilder: (context,index) {
              return const Divider();
            },
            ),
          ),
    );

  }
}

bool isArabic(BuildContext context){
  return context.locale.languageCode == 'ar';
}




