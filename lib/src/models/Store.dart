import 'package:cloud_firestore/cloud_firestore.dart';

class Store {

  String id;
  String nameAr;
  String nameEn;
  int category;
  bool isApprovedByAdmin;
  List<dynamic> stories;
  // 2
  Store(this.id,this.nameAr,this.nameEn,this.category,this.isApprovedByAdmin,this.stories);
  // 3
  factory Store.fromJson(Map<String, dynamic> json) =>
      _storeFromJson(json);
  // 4
  Map<String, dynamic> toJson() => _storeToJson(this);


  factory Store.fromSnapshot(DocumentSnapshot snapshot) {
    final store = Store.fromJson(snapshot.data() as Map<String, dynamic>);
    store.id = snapshot.reference.id;
    return store;
  }



}

Store _storeFromJson(Map<String, dynamic> json) {
  return Store(
    json['ID'] as String,
    json['NameAr'] as String,
    json['NameEn'] as String,
    json['Category'] as int,
    json['isApprovedByAdmin'] as bool,
    json['Stories'] as List<dynamic>
  );
}
// 2
Map<String, dynamic> _storeToJson(Store instance) =>
    <String, dynamic>{
      'ID': instance.id,
      'NameAr': instance.nameAr,
      'NameEn': instance.nameEn,
      'Category': instance.category,
      'isApprovedByAdmin': instance.isApprovedByAdmin,
      'Stories' : instance.stories,
    };
