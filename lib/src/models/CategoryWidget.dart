import 'ImageStoreModel.dart';

class CategoryWidget{
   late String thumbnailImage;
   late String categoryName;
   late List<ImageStoreModel> images;

   CategoryWidget(this.thumbnailImage,this.categoryName,this.images);
}