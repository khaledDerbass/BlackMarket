import 'package:souq/src/models/CategoryWidget.dart';

class SeenImageModel{
  int imageIndex;
  CategoryWidget categoryWidget;
  String storeId;
  String imageId;

  SeenImageModel(this.imageIndex,this.categoryWidget,this.storeId,this.imageId);
}