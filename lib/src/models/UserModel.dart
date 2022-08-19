import 'package:cloud_firestore/cloud_firestore.dart';
import 'Store.dart';

class UserModel {

  String name;
  String email;
  String phoneNumber;
  String password;
  String profilePicture;
  List<String> followedStores;
  int RoleID;
  String storeId = "";

  UserModel(this.name,this.email,this.phoneNumber,this.password,this.profilePicture,this.followedStores,this.RoleID,this.storeId);
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
      List.from(json["followedStores"]),
    json['RoleID'] as int,
    json['storeId'] ?? "" as String
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
      'RoleID' : instance.RoleID,
      'storeId' : instance.storeId
    };
