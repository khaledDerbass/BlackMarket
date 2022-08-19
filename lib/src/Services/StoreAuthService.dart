import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';
import 'package:souq/src/models/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/Store.dart';


class StoreAuthService{

  static FirebaseAuth getAuthInstance(){
    return FirebaseAuth.instance;
  }
  static int ROLEID = 2;
  static bool isCurrentUserLoggedIn() {
    final User? user = getAuthInstance().currentUser;
    if (user == null) {
      return false;
    }
    return true;
  }
  static Future<bool> register(String email , String password,String phone,String NameAr,String NameEn,String Category) async {
    try{
      final User? user = (await
      getAuthInstance().createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
      ).user;
      Store store = Store(NameAr,NameEn,int.tryParse(Category)?.toInt() ?? 1,false,[],0);
      DocumentReference storeId = await FirebaseFirestore.instance.collection('Store').add(store.toJson());
      UserModel userModel = UserModel(email,email,phone,password,"",[],ROLEID,storeId.id);
      await FirebaseFirestore.instance.collection('Users').add(userModel.toJson()).then((value) => print(value));
      await FirebaseFirestore.instance.collection('Store').doc(storeId.id).update({'storeId' : storeId.id.replaceAll(" ", "")});
      return true;
    }on FirebaseAuthException{
      return false;
    }
  }

  static Future<bool> signInWithEmailAndPassword(String email , String password) async {
    try{
      final User? user = (await getAuthInstance().signInWithEmailAndPassword(
        email: email,
        password: password,
      )).user;

      if(user != null) {
        final box = GetStorage();
        box.write("roleID",ROLEID);
        return true;
      }

      return false;
    }on FirebaseAuthException{
      return false;
    }
  }

  static Future signOut()  async{
    await getAuthInstance().signOut();
  }
}