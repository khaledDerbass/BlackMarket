import 'package:flutter/cupertino.dart';

class ImageStoreModel{
  String img;
  String storeName;
  String storeId;
  ValueNotifier<bool> isFollowButtonVisible = ValueNotifier(true);
  bool isSeen;
  String imageId;
  List<String> seenbyUserIds;
  String description;

  ImageStoreModel(this.img,this.storeName,this.storeId,this.isSeen,this.imageId,this.seenbyUserIds,this.description);
}