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

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.usermodel.username}'), // Title of the AppBar
        centerTitle: true, // Center the title
      ),
      body: Container(
        child: Text("ohter proifle  $email"),
      ),
    );
  }
}
