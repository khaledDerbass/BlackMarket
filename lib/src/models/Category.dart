import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  String type;
  String value;

  CategoryModel(this.type,this.value);
  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _categoryFromJson(json);

  Map<String, dynamic> toJson() => _categoryToJson(this);

  factory CategoryModel.fromSnapshot(DocumentSnapshot snapshot) {
    final category = CategoryModel.fromJson(snapshot.data() as Map<String, dynamic>);
    return category;
  }
}
CategoryModel _categoryFromJson(Map<String, dynamic> json) {
  return CategoryModel(

    json['type'] as String,
    json['value'] as String,
  );
}
Map<String, dynamic> _categoryToJson(CategoryModel instance) =>
    <String, dynamic>{
      'type' : instance.type,
      'value' : instance.type,
    };
