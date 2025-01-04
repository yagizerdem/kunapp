import 'package:app/Components/MainLayout.dart';
import 'package:app/models/UserModel.dart';
import 'package:app/pages/OtherProfile.dart';
import 'package:app/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPagePageState();
}

class _SearchPagePageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  final ButtonStyle style =
      ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));
  DocumentSnapshot? lastDocument = null;
  int limit = 10;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<UserModel> userList = [];

  void searchUser() async {
    setState(() {
      userList.clear(); // refresh
    });
    lastDocument = null;
    String query = _controller.text;
    List<QueryDocumentSnapshot>? docSnapshotList = await fetchUsers(
        limit: limit, startAfterDoc: lastDocument, searchTerm: query);

    if (docSnapshotList != null) {
      List<UserModel> list = docSnapshotList.map((doc) {
        return UserModel.fromJson(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();

      lastDocument = (docSnapshotList != null && docSnapshotList.isNotEmpty)
          ? docSnapshotList.last
          : null;

      setState(() {
        String uid = FirebaseAuth.instance.currentUser!.uid;
        list = list.where((u) => u.id != uid).toList();
        userList.addAll(list);
      });
    }
  }

  void loadMore() async {
    String query = _controller.text;
    List<QueryDocumentSnapshot>? docSnapshotList = await fetchUsers(
        limit: limit, startAfterDoc: lastDocument, searchTerm: query);

    if (docSnapshotList != null && docSnapshotList.length > 0) {
      List<UserModel> list = docSnapshotList.map((doc) {
        return UserModel.fromJson(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();

      lastDocument = (docSnapshotList != null && docSnapshotList.isNotEmpty)
          ? docSnapshotList.last
          : null;

      setState(() {
        String uid = FirebaseAuth.instance.currentUser!.uid;
        list = list.where((u) => u.id != uid).toList();
        userList.addAll(list);
      });
    }
  }

  Future<List<QueryDocumentSnapshot>?> fetchUsers({
    required int limit,
    DocumentSnapshot? startAfterDoc,
    String? searchTerm,
  }) async {
    try {
      Query query = _firestore
          .collection('users')
          .orderBy('createdAt', descending: true)
          .limit(limit);

      if (searchTerm != null && searchTerm.isNotEmpty) {
        query = query.where('username', isEqualTo: searchTerm.toLowerCase());
      }
      // Add pagination using startAfterDoc
      if (startAfterDoc != null) {
        query = query.startAfterDocument(startAfterDoc);
      }

      final QuerySnapshot querySnapshot = await query.get();
      return querySnapshot.docs;
    } catch (err) {
      toastification.show(
        title: const Text(
          "internal server error",
          maxLines: 10, // Limit to 10 lines
          overflow: TextOverflow.ellipsis, // Add ellipsis for longer text
        ),
        autoCloseDuration: const Duration(seconds: 5),
      );

      return null;
    }
  }

  void goToOtherProfilePage(String uid) {
    UserModel model = userList.firstWhere(
      (u) => u.id == uid,
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OtherProfile(
          usermodel: model,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0), // Add padding around the content
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Align items to the start
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    labelText: 'Search',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                style: style,
                onPressed: () {
                  searchUser();
                },
                child: const Text('Search'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
              child: SizedBox(
            child: ListView.builder(
              itemCount: userList.length,
              itemBuilder: (context, index) {
                final user = userList[index];
                return ListTile(
                  leading: CircleAvatar(
                    child:
                        Text(user.username[0]), // First letter of the username
                  ),
                  title: Text(user.username),
                  subtitle: Text(user.email),
                  onTap: () {
                    // Handle user tap
                    print('Tapped on: ${user.username}');
                    goToOtherProfilePage(user.id);
                  },
                );
              },
            ),
          )),
          (userList.length) > 0
              ? TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blue,
                    disabledForegroundColor: Colors.red,
                  ),
                  onPressed: () {
                    loadMore();
                  },
                  child: const Center(
                    child: Text('load more'),
                  ),
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
