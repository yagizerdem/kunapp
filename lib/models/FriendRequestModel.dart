import 'package:app/enums/FriendRequestState.dart';

class FriendRequestModel {
  String fromUid = "";
  String destUid = "";
  String fromUserName = "";
  String fromUserProfileImageUrl = "";
  String message = "";
  FriendRequestState state = FriendRequestState.Pending;

  FriendRequestModel();

  // Convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      "fromUid": fromUid,
      "destUid": destUid,
      "fromUserName": fromUserName,
      "fromUserProfileImageUrl": fromUserProfileImageUrl,
      "message": message,
      "state": state.toString().split('.').last, // Convert enum to string
    };
  }

  // Optional: Create a factory constructor to build an object from JSON
  factory FriendRequestModel.fromJson(Map<String, dynamic> json) {
    return FriendRequestModel()
      ..fromUid = json['fromUid'] ?? ""
      ..destUid = json['destUid'] ?? ""
      ..fromUserName = json['fromUserName'] ?? ""
      ..fromUserProfileImageUrl = json['fromUserProfileImageUrl'] ?? ""
      ..message = json['message'] ?? ""
      ..state = FriendRequestState.values.firstWhere(
          (e) => e.toString().split('.').last == json['state'],
          orElse: () => FriendRequestState.Pending);
  }
}
