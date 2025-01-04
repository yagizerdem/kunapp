import 'package:app/enums/FriendRequestState.dart';
import 'package:app/models/FriendRequestModel.dart';
import 'package:app/utils/AppError.dart';
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

  void Reject(int requestIndex) async {
    try {
      FriendRequestModel model = requestList[requestIndex];
      // get request form db
      final querySnapshot = await FirebaseFirestore.instance
          .collection('friendRequests')
          .where('fromUid', isEqualTo: model.fromUid)
          .where('destUid', isEqualTo: model.destUid)
          .where('state',
              isEqualTo: FriendRequestState.Pending.toString().split('.').last)
          .get();
      if (!querySnapshot.docs.isNotEmpty) {
        throw CustomException("friend request dont exist in database");
      }
      String modelFromDbUid = querySnapshot.docs.first.id;
      FriendRequestModel modelFromDb =
          FriendRequestModel.fromJson(querySnapshot.docs.first.data());

      // update FrindRequest status to rejected
      await FirebaseFirestore.instance
          .collection('friendRequests') // Specify the collection
          .doc(modelFromDbUid) // Provide the document ID
          .update({
        'state': FriendRequestState.Rejected.toString().split('.').last,
      });

      toastification.show(
        title: const Text(
          "rejected successfully",
          maxLines: 10,
          overflow: TextOverflow.ellipsis,
        ),
        autoCloseDuration: const Duration(seconds: 5),
      );

      // remove from list
      setState(() {
        requestList.removeAt(requestIndex);
      });
      // done
    } catch (err) {
      toastification.show(
        title: const Text(
          "internal server error",
          maxLines: 10,
          overflow: TextOverflow.ellipsis,
        ),
        autoCloseDuration: const Duration(seconds: 5),
      );
    }
  }

  void Approve(int requestIndex) async {
    try {
      FriendRequestModel model = requestList[requestIndex];
      // get request form db
      final querySnapshot = await FirebaseFirestore.instance
          .collection('friendRequests')
          .where('fromUid', isEqualTo: model.fromUid)
          .where('destUid', isEqualTo: model.destUid)
          .where('state',
              isEqualTo: FriendRequestState.Pending.toString().split('.').last)
          .get();
      if (!querySnapshot.docs.isNotEmpty) {
        throw CustomException("friend request dont exist in database");
      }
      String modelFromDbUid = querySnapshot.docs.first.id;
      FriendRequestModel modelFromDb =
          FriendRequestModel.fromJson(querySnapshot.docs.first.data());

      // update FrindRequest status to rejected
      await FirebaseFirestore.instance
          .collection('friendRequests') // Specify the collection
          .doc(modelFromDbUid) // Provide the document ID
          .update({
        'state': FriendRequestState.Approved.toString().split('.').last,
      });

      // append to friends  list

      // append to followings
      var user1DocSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(modelFromDb.fromUid) // Query by the 'uid' field
          .get();

      // append to followers
      var user2DocSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(modelFromDb.destUid) // Query by the 'uid' field
          .get();

      if (!user1DocSnapshot.exists || !user2DocSnapshot.exists) {
        throw CustomException("users not exist in database");
      }

      var user1Doc = user1DocSnapshot.reference;
      var user2Doc = user2DocSnapshot.reference;

      final batch = FirebaseFirestore.instance.batch();

      batch.update(user1Doc, {
        'followings': FieldValue.arrayUnion([user2Doc.id]), // Add new follower
        "followingCount": FieldValue.increment(1),
      });

      batch.update(user2Doc, {
        'followers': FieldValue.arrayUnion([user1Doc.id]), // Add new follower
        "followerCount": FieldValue.increment(1),
      });

      await batch.commit();

      // successfully done
      toastification.show(
        title: const Text(
          "approved successfully",
          maxLines: 10,
          overflow: TextOverflow.ellipsis,
        ),
        autoCloseDuration: const Duration(seconds: 5),
      );

      // remove from list
      setState(() {
        requestList.removeAt(requestIndex);
      });
    } catch (err) {
      toastification.show(
        title: const Text(
          "internal server error",
          maxLines: 10,
          overflow: TextOverflow.ellipsis,
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
                              onPressed: () {
                                Approve(index);
                              },
                              child: const Text('Approve'),
                            ),
                            ElevatedButton(
                              style: style,
                              onPressed: () {
                                Reject(index);
                              },
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
