import 'package:app/Components/MainLayout.dart';
import 'package:app/models/PostModel.dart';
import 'package:app/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

const limit = 10;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<PostModel> postModels = [];
  QueryDocumentSnapshot? lastDoc = null;
  final ButtonStyle style =
      ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));
  @override
  void initState() {
    super.initState();
    fetchPost();
  }

  void fetchPost() async {
    try {
      QuerySnapshot querySnapshot;
      if (this.lastDoc == null) {
        // Initial fetch
        querySnapshot = await FirebaseFirestore.instance
            .collection("posts")
            .orderBy("createdAt", descending: true)
            .limit(limit)
            .get();
      } else {
        // Fetch next page
        querySnapshot = await FirebaseFirestore.instance
            .collection("posts")
            .orderBy("createdAt", descending: true)
            .startAfterDocument(this.lastDoc!)
            .limit(limit)
            .get();
      }

      if (querySnapshot.docs.isNotEmpty) {
        lastDoc = querySnapshot.docs.last;
      }
      var l = querySnapshot.docs.map((item) {
        return PostModel.fromJson(item.data() as Map<String, dynamic>);
      }).toList(); // Convert to List<PostModel>

      setState(() {
        postModels.addAll(l);
      });
    } catch (e) {
      print("Error fetching posts: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: this.postModels.length,
            itemBuilder: (BuildContext context, int index) {
              var model = this.postModels[index];
              return Container(
                child: Column(children: [
                  Image.network(model.postUrl),
                  Text(model.message)
                ]),
              );
            },
          ),
          ElevatedButton(
            style: style,
            onPressed: () {
              fetchPost();
            },
            child: const Text('LoadMore'),
          ),
        ],
      ),
    );
  }
}
