import 'package:firebase_auth/firebase_auth.dart';
import 'package:souq/src/models/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class AuthenticationService{

  static FirebaseAuth getAuthInstance(){
    return FirebaseAuth.instance;
  }
  static int ROLEID = 1;
  static bool isCurrentUserLoggedIn() {
    final User? user = getAuthInstance().currentUser;
    if (user == null) {
      return false;
    }
    return true;
  }
  static Future<bool> register(String email , String password,String phone,String username) async {
    try{
    final User? user = (await
    getAuthInstance().createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
    ).user;
      UserModel userModel = UserModel(username,email,phone,password,"",[],ROLEID,"");
      await FirebaseFirestore.instance.collection('Users').add(userModel.toJson()).then((value) => print(value));
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