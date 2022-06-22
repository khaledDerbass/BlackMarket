import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:souq/src/models/Story.dart';

class StoryRepository {
  final CollectionReference collection =
  FirebaseFirestore.instance.collection('story');

  Stream<QuerySnapshot> getStream() {
    return collection.snapshots();
  }

  Future<DocumentReference> addStory(Story story) {
    return collection.add(story.toJson());
  }

  void updatePet(Story story) async {
    await collection.doc(story.id.toString()).update(story.toJson());
  }

  void deletePet(Story story) async {
    await collection.doc(story.id.toString()).delete();
  }
}
