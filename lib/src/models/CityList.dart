import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
class CityList {

  String name;
  dynamic value;

  // 2
  CityList(this.name,this.value);

  static List<CityList> cityListFromJson(Map<String, dynamic> json) {
    List<CityList> list = [];
    for (var entry in json.entries) { list.add(CityList(entry.key,entry.value)); }
    print(list.first.name);
    return list;
  }

}



