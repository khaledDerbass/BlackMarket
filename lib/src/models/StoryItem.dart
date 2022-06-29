import 'package:cloud_firestore/cloud_firestore.dart';

class StoryContent {

  String img;
  int category;

  // 2
  StoryContent(this.img,this.category);
  // 3
  factory StoryContent.fromJson(Map<String, dynamic> json) =>
      _StoryItemFromJson(json);
  // 4
  Map<String, dynamic> toJson() => _StoryItemToJson(this);


  factory StoryContent.fromSnapshot(DocumentSnapshot snapshot) {
    final storyItem = StoryContent.fromJson(snapshot.data() as Map<String, dynamic>);
    return storyItem;
  }

  Map<String, dynamic> toMap() {
    return {
      'img': img,
      'Category':category,
    };}}



StoryContent _StoryItemFromJson(Map<String, dynamic> json) {
  return StoryContent(
      json['img'] as String,
      json['Category'] as int,
  );
}
// 2
Map<String, dynamic> _StoryItemToJson(StoryContent instance) =>
    <String, dynamic>{
      'img': instance.img,
      'Category': instance.category,
    };
