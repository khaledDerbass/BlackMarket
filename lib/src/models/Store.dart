import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:souq/src/models/StoryItem.dart';
import 'package:stories_for_flutter/stories_for_flutter.dart';

class Store {

  String nameAr;
  String nameEn;
  int category;
  bool isApprovedByAdmin;
  List<StoryContent> stories;
  // 2
  Store(this.nameAr,this.nameEn,this.category,this.isApprovedByAdmin,this.stories);
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
    json['isApprovedByAdmin'] as bool,
    List<StoryContent>.from(json["Stories"].map((x) => StoryContent.fromJson(x))),
  );
}

Map<String, dynamic> _storeToJson(Store instance) =>
    <String, dynamic>{
      'NameAr': instance.nameAr,
      'NameEn': instance.nameEn,
      'Category': instance.category,
      'isApprovedByAdmin': instance.isApprovedByAdmin,
      'Stories' : instance.stories,
    };
