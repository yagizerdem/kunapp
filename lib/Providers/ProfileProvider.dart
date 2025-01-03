import 'dart:io';

import 'package:app/pages/HomePage.dart';
import 'package:app/pages/ProfilePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ProfileProvider with ChangeNotifier {
  File? _profileImage = null;
  String _username = "";
  String _email = "";
  int _followerCount = 0;
  int _followingCount = 0;
  bool _isInitialized = false;

  get profileImage => _profileImage;
  get userName => _username;
  get email => _email;
  get followerCount => _followerCount;
  get followingCount => _followingCount;
  bool get isInitialized => _isInitialized;

  ProfileProvider() {
    var user = FirebaseAuth.instance.currentUser;
    String? uid = null;
    if (user != null) {
      uid = user.uid;
    }
    if (uid != null) {
      initialize(uid);
    }
  }

  Future<void> initialize(String userId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (snapshot.exists) {
        _followerCount = snapshot.data()?['followerCount'] ?? 0;
        _followingCount = snapshot.data()?['followingCount'] ?? 0;
        _username = snapshot.data()?['username'] ?? "";
        _email = snapshot.data()?['email'] ?? "";
      }
      _isInitialized = true;
      notifyListeners();
    } catch (error) {
      debugPrint('Error initializing profile data: $error');
    }
  }

  void setProfileImage(File file) {
    _profileImage = file;
    notifyListeners(); // Notify widgets listening to this state
  }

  void setUserName(String username) {
    this._username = username;
    notifyListeners(); // Notify widgets listening to this state
  }

  void setFollowerCount(int followerCount) {
    this._followerCount = followerCount;
    notifyListeners(); // Notify widgets listening to this state
  }

  void setFollowingCount(int followingCount) {
    this._followingCount = followingCount;
    notifyListeners(); // Notify widgets listening to this state
  }
}
