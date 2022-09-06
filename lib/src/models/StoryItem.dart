import 'package:cloud_firestore/cloud_firestore.dart';

class StoryContent {

  String id;
  String img;
  int category;
  String description;
  int duration;
  int createdAt;
  List<String> seenBy;

  late String storeName;
  late String storeId;

  // 2
  StoryContent(this.id,this.img,this.category,this.description,this.duration,this.createdAt,this.seenBy);
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
      'id': id,
      'img': img,
      'Category':category,
      'description':description,
      'duration' :duration,
      'createdAt' : createdAt,
      'seenBy': seenBy
    };}}



StoryContent _StoryItemFromJson(Map<String, dynamic> json) {
  return StoryContent(
      json['id']  ?? "",
      json['img'] as String,
      json['Category'] as int,
      json['description'] ?? "",
      json['duration'] ?? 1,
      json['createdAt']  ?? DateTime.now().millisecondsSinceEpoch,
      List.from(json["seenBy"]),
  );
}
// 2
Map<String, dynamic> _StoryItemToJson(StoryContent instance) =>
    <String, dynamic>{
      'id' : instance.id,
      'Category': instance.category,
      'description' : instance.description,
      'duration' : instance.duration,
      'createdAt' : instance.createdAt,
      'img': instance.img,
      'seenBy': instance.seenBy
    };
