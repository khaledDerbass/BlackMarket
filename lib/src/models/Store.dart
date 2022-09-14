import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:souq/src/models/StoryItem.dart';

class Store {
  String nameAr;
  String nameEn;
  int category;
  bool isApprovedByAdmin;
  List<StoryContent> stories;
  int numOfFollowers;
  String storeId;
  // 2
  Store(this.nameAr,this.nameEn,this.category,this.isApprovedByAdmin,this.stories,this.numOfFollowers,{this.storeId = ""});
  // 3
  factory Store.fromJson(Map<String, dynamic> json) =>
      _storeFromJson(json);

  Map<String, dynamic> toJson() => _storeToJson(this);


  factory Store.fromSnapshot(DocumentSnapshot snapshot) {
    final store = Store.fromJson(snapshot.data() as Map<String, dynamic>);
    return store;
  }



}

Store _storeFromJson(Map<String, dynamic> json) {
  return Store(
    json['NameAr'] as String,
    json['NameEn'] as String,
    json['Category'] as int,
    json['isApprovedByAdmin'] as bool, json["Stories"] != null ? List<StoryContent>.from(json["Stories"].map((x) => StoryContent.fromJson(x))) : [],
    json['numOfFollowers'] ?? 0 as int,
    storeId:  json['storeId'] ?? "" as String
  );
}

Map<String, dynamic> _storeToJson(Store instance) =>
    <String, dynamic>{
      'NameAr': instance.nameAr,
      'NameEn': instance.nameEn,
      'Category': instance.category,
      'isApprovedByAdmin': instance.isApprovedByAdmin,
      'Stories' : instance.stories,
      'numOfFollowers' : instance.numOfFollowers,
      'storeId' : instance.storeId
    };
