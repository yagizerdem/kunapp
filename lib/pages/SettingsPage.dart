import 'package:app/Providers/CustomAuthProvider.dart';
import 'package:app/Providers/ProfileProvider.dart';
import 'package:app/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final userNameControl = TextEditingController();

  void logOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      print('User logged out');
      toastification.show(
        context: context, // optional if you use ToastificationWrapper
        title: const Text(
          "user logged out",
          maxLines: 10, // Limit to 2 lines
          overflow: TextOverflow.ellipsis, // Add ellipsis for longer text
        ),
        autoCloseDuration: const Duration(seconds: 5),
      );
    } catch (e) {
      print('Error during logout: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<CustomAuthProvider>(context);
    final profileProvider = Provider.of<ProfileProvider>(context);

    void showToastHelper(String message) {
      toastification.show(
        context: context, // optional if you use ToastificationWrapper
        title: Text(
          message,
          maxLines: 10, // Limit to 2 lines
          overflow: TextOverflow.ellipsis, // Add ellipsis for longer text
        ),
      );
    }

    void updateUserName() async {
      String newUserName = userNameControl.text;
      if (newUserName.length < 3 || newUserName.length > 30) {
        showToastHelper("username should be between 3 and 30 characters long");
        return;
      }
      User? curUser = authProvider.user;
      if (curUser != null) {
        String uid = curUser.uid;
        try {
          DocumentSnapshot userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(uid) // Use the uid directly as the document ID
              .get();

          // Check if a document exists
          if (userDoc.exists) {
            print('Document found: ${userDoc.data()}');

            // You can now access the DocumentReference
            DocumentReference docRef = userDoc.reference;
            print('Document ID: ${docRef.id}');

            await docRef.update({
              'username': newUserName,
            });
            showToastHelper('username updated');
            profileProvider.setUserName(newUserName);
          } else {
            showToastHelper('No document found with uid: $uid');
            print('No document found with uid: $uid');
          }
        } catch (err) {
          showToastHelper("server error !");
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "settings",
        ),
      ),
      body: Container(
        color: AppColors.backgroundSwatch.shade500,
        width: double.infinity, // Full width
        height: double.infinity, // Full height
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                logOut();
              },
              child: const Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "log out",
                  style: TextStyle(
                    color: AppColors.error,
                    fontSize: 15, // Font size
                    fontWeight: FontWeight.w600, // Bold font weight
                    fontStyle: FontStyle.italic, // Italic text
                    decoration: TextDecoration.underline, // Underline text
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: userNameControl,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter new user name',
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            OutlinedButton(
              onPressed: () {
                updateUserName();
              },
              child: const Text('update user name'),
            ),
          ],
        ),
      ),
    );
  }
}
