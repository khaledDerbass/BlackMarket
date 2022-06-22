import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:souq/src/blocs/StoryRepository.dart';
import 'package:souq/src/models/Story.dart';
import 'package:souq/src/ui/HomeScreen.dart';
import 'package:stories_for_flutter/stories_for_flutter.dart' as s;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
   return _HomeScreenState();
  }

}


class _HomeScreenState extends State<HomeScreen>{

  @override
  Widget build(BuildContext context) {
    StoryRepository repository = StoryRepository();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Home Screen'),
        ),
        body: StreamBuilder <QuerySnapshot>(
            stream: repository.getStream(),
            builder: (context, snapshot) {
              print(snapshot.connectionState);
              if (!snapshot.hasData) return LinearProgressIndicator();

              return _buildList(context, snapshot.data?.docs ?? []);
            }),
      ),
    );

  }
}
// 1
Widget _buildList(BuildContext context, List<DocumentSnapshot>? snapshot) {
  return ListView(
    padding: const EdgeInsets.only(top: 20.0),
    // 2
    children: snapshot!.map((data) => _buildListItem(context, data,snapshot.length)).toList(),
  );
}
// 3
Widget _buildListItem(BuildContext context, DocumentSnapshot snapshot, int length) {
  // 4
  final story = Story.fromSnapshot(snapshot);

  return  s.Stories(
    autoPlayDuration: const Duration(seconds: 7),
    displayProgress: true,
    circlePadding: 2,
    storyItemList: [
      s.StoryItem(
          name: story.storeName,
          thumbnail: const NetworkImage(
            "https://assets.materialup.com/uploads/82eae29e-33b7-4ff7-be10-df432402b2b6/preview",
          ),
          stories: List.generate(length, (index) => Scaffold(
            body: Container(
              decoration:  BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: Image.memory(base64Decode(story.image)).image,
                ),
              ),
            ),
          ),)),
    ]
  );
}

/**
 * Column(
    children: [
    s.Stories(
    autoPlayDuration: const Duration(seconds: 7),
    displayProgress: true,
    circlePadding: 2,
    storyItemList: [
    s.StoryItem(
    name: "First Story",
    thumbnail: const NetworkImage(
    "https://assets.materialup.com/uploads/82eae29e-33b7-4ff7-be10-df432402b2b6/preview",
    ),
    stories: [
    Scaffold(
    body: Container(
    decoration: const BoxDecoration(
    image: DecorationImage(
    fit: BoxFit.cover,
    image: NetworkImage(
    "https://wallpaperaccess.com/full/16568.png",
    ),
    ),
    ),
    ),
    ),
    Scaffold(
    body: Container(
    decoration: const BoxDecoration(
    image: DecorationImage(
    fit: BoxFit.cover,
    image: NetworkImage(
    "https://i.pinimg.com/originals/2e/c6/b5/2ec6b5e14fe0cba0cb0aa5d2caeeccc6.jpg",
    ),
    ),
    ),
    ),
    ),
    Scaffold(
    body: Container(
    decoration: const BoxDecoration(
    image: DecorationImage(
    fit: BoxFit.cover,
    image: NetworkImage(
    "https://wallpaperaccess.com/full/16568.png",
    ),
    ),
    ),
    ),
    ),
    Scaffold(
    body: Container(
    decoration: const BoxDecoration(
    image: DecorationImage(
    fit: BoxFit.cover,
    image: NetworkImage(
    "https://i.pinimg.com/originals/2e/c6/b5/2ec6b5e14fe0cba0cb0aa5d2caeeccc6.jpg",
    ),
    ),
    ),
    ),
    ),
    ]),
    s.StoryItem(
    name: "2nd",
    thumbnail: const NetworkImage(
    "https://www.shareicon.net/data/512x512/2017/03/29/881758_cup_512x512.png",
    ),
    stories: [
    Scaffold(
    body: Container(
    decoration: const BoxDecoration(
    image: DecorationImage(
    fit: BoxFit.cover,
    image: NetworkImage(
    "https://i.pinimg.com/originals/31/bc/a9/31bca95ba39157a6cbf53cdf09dda672.png",
    ),
    ),
    ),
    ),
    ),
    const Scaffold(
    backgroundColor: Colors.black,
    body: Center(
    child: Text(
    "That's it, Folks !",
    style: TextStyle(
    color: Color(0xffffffff),
    fontSize: 25,
    ),
    ),
    ),
    ),
    ],
    ),
    ],
    ),
    SizedBox(height: 30,),



    ],
    ),
 */