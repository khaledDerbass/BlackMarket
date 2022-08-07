import 'package:cloud_firestore/cloud_firestore.dart';
import 'Store.dart';

class UserModel {

  String name;
  String email;
  String phoneNumber;
  String password;
  String profilePicture;
  List<Store> followedStores;

  UserModel(this.name,this.email,this.phoneNumber,this.password,this.profilePicture,this.followedStores);
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _userFromJson(json);

  Map<String, dynamic> toJson() => _userToJson(this);

  factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    final user = UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
    return user;
  }
}
UserModel _userFromJson(Map<String, dynamic> json) {
  return UserModel(
    json['name'] as String,
    json['email'] as String,
    json['phoneNumber'] as String,
    json['password'] as String,
    json['profilePicture'] as String,
    List<Store>.from(json["followedStores"].map((x) => UserModel.fromJson(x))),
  );
}
Map<String, dynamic> _userToJson(UserModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'password': instance.password,
      'profilePicture' : instance.profilePicture,
      'followedStores' : instance.followedStores,
    };
