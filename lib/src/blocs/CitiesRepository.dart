import 'package:cloud_firestore/cloud_firestore.dart';

class CitiesRepository {
  final CollectionReference collection =
  FirebaseFirestore.instance.collection('Cities');

  Stream<QuerySnapshot> getCitiesStream() {
    return collection.snapshots();
  }
}