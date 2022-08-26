import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
class CategoryList {

  String name;
  dynamic value;

  // 2
  CategoryList(this.name,this.value);

  static List<CategoryList> categoryListFromJson(Map<String, dynamic> json) {
    List<CategoryList> list = [];
    for (var entry in json.entries) { list.add(CategoryList(entry.key,entry.value)); }
    print(list.first.name);
    return list;
  }

}



