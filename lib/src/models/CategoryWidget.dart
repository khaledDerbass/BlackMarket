import 'package:flutter/cupertino.dart';

import 'ImageStoreModel.dart';

class CategoryWidget{
   late AssetImage thumbnailImage;
   late String categoryName;
   late int categoryID;
   late List<ImageStoreModel> images;

   CategoryWidget(this.thumbnailImage,this.categoryName,this.categoryID,this.images);
}