import 'package:cloud_firestore/cloud_firestore.dart';


class StoryTimeRepo {
  final CollectionReference collection =
  FirebaseFirestore.instance.collection('StoryTime');

  Stream<QuerySnapshot> getStoryTimeStream() {
    return collection.snapshots();
  }
}
