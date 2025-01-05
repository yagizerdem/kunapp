import 'package:app/Components/PostGrid.dart';
import 'package:app/Components/ProfileImage.dart';
import 'package:app/Components/ProfileStats.dart';
import 'package:app/Providers/ProfileProvider.dart';
import 'package:app/enums/FriendRequestState.dart';
import 'package:app/models/FriendRequestModel.dart';
import 'package:app/models/UserModel.dart';
import 'package:app/pages/ProfilePage.dart';
import 'package:app/utils/AppError.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

class OtherProfile extends StatefulWidget {
  final UserModel usermodel;
  const OtherProfile({super.key, required this.usermodel});

  @override
  State<OtherProfile> createState() => _OtherProfileState();
}

class _OtherProfileState extends State<OtherProfile> {
  @override
  Widget build(BuildContext context) {
    String email = widget.usermodel.email; // for test
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    final profileProvider = Provider.of<ProfileProvider>(context);

    ImageProvider getProfileImage() {
      String profileImage = widget.usermodel.profileImageUrl;
      return NetworkImage(profileImage);
    }

    final ButtonStyle style =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

    void sendFrindReqest() async {
      try {
        String fromUid = FirebaseAuth.instance.currentUser!.uid;
        String destUid = widget.usermodel.id;
        String fromUserName = profileProvider.userName;
        String fromUserProfileImageUrl = profileProvider.profileImageUrl;

        FriendRequestModel requestModel = FriendRequestModel();
        requestModel.fromUid = fromUid;
        requestModel.destUid = destUid;
        requestModel.fromUserName = fromUserName;
        requestModel.fromUserProfileImageUrl = fromUserProfileImageUrl;
        requestModel.state = FriendRequestState.Pending;

        // check request exist in databaes
        final querySnapshot = await FirebaseFirestore.instance
            .collection('friendRequests')
            .where('fromUid', isEqualTo: requestModel.fromUid)
            .where('destUid', isEqualTo: requestModel.destUid)
            .where('state',
                isEqualTo:
                    FriendRequestState.Pending.toString().split('.').last)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          throw CustomException('Friend request already exists.');
        }

        // Insert into Firestore
        await FirebaseFirestore.instance
            .collection('friendRequests')
            .doc() // Auto-generate document ID
            .set(requestModel.toJson());

        toastification.show(
          title: const Text(
            "request send successfully",
            maxLines: 10, // Limit to 2 lines
            overflow: TextOverflow.ellipsis, // Add ellipsis for longer text
          ),
          autoCloseDuration: const Duration(seconds: 5),
        );
      } catch (err) {
        String errrorMessage = "";
        if (err is CustomException) {
          errrorMessage = err.cause;
        } else {
          errrorMessage = "internal server error";
        }
        print(err);
        toastification.show(
          title: Text(
            errrorMessage,
            maxLines: 10, // Limit to 2 lines
            overflow: TextOverflow.ellipsis, // Add ellipsis for longer text
          ),
          autoCloseDuration: const Duration(seconds: 5),
        );

        // showt toaster here TODO !
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.usermodel.username}'), // Title of the AppBar
        centerTitle: true, // Center the title
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              children: [
                ProfileImage(
                    width: width * .5,
                    height: width * .5,
                    imageProvider: getProfileImage()),
                const SizedBox(
                  height: 30,
                ),
                ProfileStats(
                  followerCount: widget.usermodel.followerCount,
                  followingCount: widget.usermodel.followingCount,
                  userName: widget.usermodel.username,
                  email: widget.usermodel.email,
                  spacing: 60,
                ),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  style: style,
                  onPressed: () {
                    sendFrindReqest();
                  },
                  child: const Text('Send Friend Request'),
                ),
                PostGrid(uid: widget.usermodel.id)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
