import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/Category.dart';

class CategoriesRepository {
  final CollectionReference collection =
  FirebaseFirestore.instance.collection('Categories');

  Stream<QuerySnapshot> getCategoriesStream() {
    return collection.snapshots();
  }

  Future<DocumentReference> addCategory(CategoryModel category) {
    return collection.add(category.toJson());
  }
}
