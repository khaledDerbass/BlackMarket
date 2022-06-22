import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class Story {

  String id;
  String storeID;
  String storeName;
  int category;
  DateTime date;
  bool? seen;
  String image;
  // 2
  Story(this.id,this.storeID,this.storeName,this.category,
      {required this.date, this.seen, required this.image});
  // 3
  factory Story.fromJson(Map<String, dynamic> json) =>
      _storyFromJson(json);
  // 4
  Map<String, dynamic> toJson() => _storyToJson(this);


   factory Story.fromSnapshot(DocumentSnapshot snapshot) {
    final story = Story.fromJson(snapshot.data() as Map<String, dynamic>);
    story.id = snapshot.reference.id;
    return story;
  }



}

Story _storyFromJson(Map<String, dynamic> json) {
  return Story(
    json['id'] as String,
    json['storeID'] as String,
    json['storeName'] as String,
    json['category'] as int,
    date: (json['date'] as Timestamped).timestamp,
    seen: json['seen'] as bool,
    image: json['image'] as String,
  );
}
// 2
Map<String, dynamic> _storyToJson(Story instance) =>
    <String, dynamic>{
      'id': instance.id,
      'storeID': instance.storeID,
      'storeName': instance.storeName,
      'category': instance.category,
      'date': instance.date,
      'seen': instance.seen,
      'image' : instance.image,
    };
