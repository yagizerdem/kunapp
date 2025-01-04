import 'package:app/enums/FriendRequestState.dart';
import 'package:app/models/FriendRequestModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toastification/toastification.dart';

class FrindRequestPage extends StatefulWidget {
  const FrindRequestPage({super.key});

  @override
  State<FrindRequestPage> createState() => _FrindRequestPageState();
}

class _FrindRequestPageState extends State<FrindRequestPage> {
  List<FriendRequestModel> requestList = [];

  @override
  void initState() {
    super.initState();
    fetchRequests();
  }

  void fetchRequests() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;

      // check request exist in databaes
      final querySnapshot = await FirebaseFirestore.instance
          .collection('friendRequests')
          .where('destUid', isEqualTo: uid)
          .where('state',
              isEqualTo: FriendRequestState.Pending.toString().split('.').last)
          .get();

      List<FriendRequestModel> fetchedRequests = querySnapshot.docs.map((doc) {
        return FriendRequestModel.fromJson(doc.data());
      }).toList();

      if (mounted) {
        setState(() {
          requestList = fetchedRequests;
        });
      }
    } catch (err) {
      print(err);
      toastification.show(
        title: const Text(
          "error occured",
          maxLines: 10, // Limit to 2 lines
          overflow: TextOverflow.ellipsis, // Add ellipsis for longer text
        ),
        autoCloseDuration: const Duration(seconds: 5),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 12));

    return Scaffold(
      appBar: AppBar(
        elevation: 0, // Removes shadow for a flat look
        backgroundColor: Colors.teal, // Sets a nice background color
        title: const Text(
          "Friend Requests",
          style: TextStyle(
            color: Colors.white, // Title text color
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Expanded(
        child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: requestList.length,
          itemBuilder: (BuildContext context, int index) {
            FriendRequestModel model = requestList[index];
            return SizedBox(
              height: 80,
              child: Center(
                child: Row(
                  children: [
                    Image.network(model.fromUserProfileImageUrl),
                    Column(
                      children: [
                        Text(model.fromUserName),
                        Row(
                          children: [
                            ElevatedButton(
                              style: style,
                              onPressed: () {},
                              child: const Text('Approve'),
                            ),
                            ElevatedButton(
                              style: style,
                              onPressed: () {},
                              child: const Text('Reject'),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
