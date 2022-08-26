import 'package:flutter/cupertino.dart';

class ImageStoreModel{
  String img;
  String storeName;
  String storeId;
  ValueNotifier<bool> isFollowButtonVisible = ValueNotifier(true);

  ImageStoreModel(this.img,this.storeName,this.storeId);
}