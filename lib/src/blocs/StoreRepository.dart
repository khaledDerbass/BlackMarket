import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:souq/src/models/Store.dart';
import 'package:souq/src/models/StoryItem.dart';

class StoreRepository {
  final CollectionReference collection =
  FirebaseFirestore.instance.collection('Store');

  Stream<QuerySnapshot> getStores() {
    return collection.snapshots();
  }


  Future<DocumentReference> addStore(Store store) {
    return collection.add(store.toJson());
  }

  getCollection(){
    return collection;
}


  Map<String, dynamic> storeToJson(Store instance) =>
      <String, dynamic>{
        'NameAr': instance.nameAr,
        'NameEn': instance.nameEn,
        'Category': instance.category,
        'isApprovedByAdmin': instance.isApprovedByAdmin,
        'Stories' : instance.stories.map((i) => i.toMap()).toList(),
      };
}