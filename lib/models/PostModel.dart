import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String message;
  final DateTime createdAt;
  final String userUid;
  final String postUrl;

  // Constructor
  PostModel(
      {required this.message,
      required this.createdAt,
      required this.userUid,
      required this.postUrl});

  // Convert Firebase document (JSON) to PostModel
  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
        message: json['message'] ?? '',
        createdAt: (json['createdAt'] as Timestamp)
            .toDate(), // Convert Firestore Timestamp to DateTime
        userUid: json['userUid'] ?? '',
        postUrl: json['postUrl'] ?? '');
  }

  // Convert PostModel to Firebase-compatible JSON
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'createdAt': Timestamp.fromDate(
          createdAt), // Convert DateTime to Firestore Timestamp
      'userUid': userUid,
      'postUrl': postUrl
    };
  }
}
