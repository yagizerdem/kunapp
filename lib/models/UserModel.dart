import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String username;
  final String email;
  final int followerCount;
  final int followingCount;
  final DateTime createdAt;
  final String profileImageUrl;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.createdAt,
    required this.profileImageUrl,
    required this.followerCount,
    required this.followingCount,
  });

  // Factory constructor to create a User object from Firestore data
  factory UserModel.fromJson(String id, Map<String, dynamic> json) {
    return UserModel(
      id: id,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      followerCount: json['followerCount'] ?? 0,
      followingCount: json['followingCount'] ?? 0,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      profileImageUrl: json['profileImageUrl'] ?? '',
    );
  }
}
