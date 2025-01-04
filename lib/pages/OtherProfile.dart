import 'package:app/Components/ProfileImage.dart';
import 'package:app/Components/ProfileStats.dart';
import 'package:app/models/UserModel.dart';
import 'package:flutter/material.dart';

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

    ImageProvider getProfileImage() {
      String profileImage = widget.usermodel.profileImageUrl;
      return NetworkImage(profileImage);
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
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
