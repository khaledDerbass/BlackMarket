import 'package:cloud_firestore/cloud_firestore.dart';


class CategoriesRepository {
  final CollectionReference collection =
  FirebaseFirestore.instance.collection('Categories');

  Stream<QuerySnapshot> getCategoriesStream() {
    return collection.snapshots();
  }
}
