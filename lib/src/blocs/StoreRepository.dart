import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:souq/src/models/Store.dart';

class StoreRepository {
  final CollectionReference collection =
  FirebaseFirestore.instance.collection('Store');

  Stream<QuerySnapshot> getStores() {
    return collection.snapshots();
  }

  Future<DocumentReference> addStore(Store store) {
    return collection.add(store.toJson());
  }

  void updatePet(Store store) async {
    await collection.doc(store.id.toString()).update(store.toJson());
  }

  void deletePet(Store store) async {
    await collection.doc(store.id.toString()).delete();
  }
}