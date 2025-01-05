import 'package:app/models/PostModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class PostGrid extends StatefulWidget {
  final String uid;
  const PostGrid({super.key, required this.uid});

  @override
  State<PostGrid> createState() => _PostGridState();
}

class _PostGridState extends State<PostGrid> {
  List<PostModel> postModels = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    try {
      final docRef = await FirebaseFirestore.instance
          .collection("posts")
          .where("userUid", isEqualTo: widget.uid)
          .get();

      final postsFromDb = docRef.docs.map((doc) {
        return PostModel.fromJson(doc.data());
      }).toList();

      setState(() {
        this.postModels = postsFromDb;
      });
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Number of items per row
          crossAxisSpacing: 8, // Space between columns
          mainAxisSpacing: 8, // Space between rows
          childAspectRatio: 1, // Aspect ratio for items
        ),
        itemCount: postModels.length,
        itemBuilder: (BuildContext context, int index) {
          PostModel model = postModels[index];
          return Column(
            children: [
              Expanded(
                child: Image.network(
                  model.postUrl,
                  fit: BoxFit.cover, // Make image cover the available space
                ),
              ),
              Text(
                model.message,
                style: const TextStyle(fontSize: 12), // Optional styling
                overflow: TextOverflow.ellipsis, // Truncate if too long
              ),
            ],
          );
        },
      ),
    );
  }
}
