import 'dart:io';

import 'package:app/Components/AddPost.dart';
import 'package:app/Components/MainLayout.dart';
import 'package:app/Components/ProfileImage.dart';
import 'package:app/Components/ProfileStats.dart';
import 'package:app/Providers/ProfileProvider.dart';
import 'package:app/pages/FriendRequestPage.dart';
import 'package:app/pages/HomePage.dart';
import 'package:app/pages/SettingsPage.dart';
import 'package:app/utils/SD.dart';
import 'package:app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isAddPostOpen = false;

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;

    ImageProvider getProfileImage() {
      String profileImage = profileProvider.profileImageUrl;
      return NetworkImage(profileImage);
    }

    void goToSettings() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SettingsPage()),
      );
    }

    void goToFriendRequests() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const FrindRequestPage()),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Column(
              children: !isAddPostOpen
                  ? [
                      ProfileImage(
                          width: width * .5,
                          height: width * .5,
                          imageProvider: getProfileImage()),
                      const SizedBox(
                        height: 30,
                      ),
                      ProfileStats(
                        followerCount: profileProvider.followerCount,
                        followingCount: profileProvider.followingCount,
                        userName: profileProvider.userName,
                        email: profileProvider.email,
                        spacing: 60,
                      ),
                    ]
                  : [
                      AddPost(),
                    ],
            ),
          ),
          (!isAddPostOpen
              ? Positioned(
                  bottom: 10, // Position the FAB relative to the bottom
                  right: 10,
                  child: FloatingActionButton(
                    onPressed: () {
                      goToSettings();
                    },
                    child: const Icon(Icons.settings),
                  ),
                )
              : const SizedBox()),
          (!isAddPostOpen
              ? Positioned(
                  bottom: 10, // Position the FAB relative to the bottom
                  left: 10,
                  child: FloatingActionButton(
                    onPressed: () {
                      goToFriendRequests();
                    },
                    child: const Icon(Icons.people),
                  ),
                )
              : const SizedBox()),
          (!isAddPostOpen
              ? Positioned(
                  bottom: 100, // Position the FAB relative to the bottom
                  left: 10,
                  child: FloatingActionButton(
                    onPressed: () {
                      setState(() {
                        isAddPostOpen = true;
                      });
                    },
                    child: const Icon(Icons.add),
                  ),
                )
              : const SizedBox()),
          (isAddPostOpen
              ? Positioned(
                  bottom: 10, // Position the FAB relative to the bottom
                  right: 10,
                  child: FloatingActionButton(
                    onPressed: () {
                      setState(() {
                        isAddPostOpen = false;
                      });
                    },
                    child: const Icon(Icons.minimize),
                  ),
                )
              : const SizedBox())
        ],
      ),
    );
  }
}
