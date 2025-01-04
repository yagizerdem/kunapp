import 'dart:io';

import 'package:app/Providers/CustomAuthProvider.dart';
import 'package:app/Providers/ProfileProvider.dart';
import 'package:app/main.dart';
import 'package:app/utils/RestartWidget.dart';
import 'package:app/utils/SD.dart';
import 'package:app/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_api/uploader/cloudinary_uploader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import 'package:path/path.dart' as path;

import 'package:cloudinary_api/src/request/model/uploader_params.dart';
import 'package:uuid/uuid.dart';

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

      // Restart the app to reset provider states
      RestartWidget.restartApp(context);
    } catch (e) {
      print('Error during logout: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<CustomAuthProvider>(context);
    final profileProvider = Provider.of<ProfileProvider>(context);
    final ImagePicker _picker = ImagePicker();

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

    Future<void> pickImage() async {
      try {
        final XFile? pickedFile = await _picker.pickImage(
          source:
              ImageSource.gallery, // Change to ImageSource.camera for camera
          imageQuality: 80, // Adjust the quality of the image
          maxHeight: 1024, // Resize the image (optional)
          maxWidth: 1024, // Resize the image (optional)
        );

        if (pickedFile != null) {
          final storageRef = FirebaseStorage.instance.ref();
          // extension
          String fileExtension = path.extension(pickedFile.path);
          // Convert the picked file to a File object
          File imageFile = File(pickedFile.path);

          final Uuid uuid = Uuid();
          String publicId = uuid.v4();
          // upload img to cloud
          var response = await cloudinary.uploader().upload(
              File(imageFile.path),
              params: UploadParams(
                  publicId: publicId, uniqueFilename: true, overwrite: true));
          print(response?.data?.publicId);
          print(response?.data?.secureUrl);

          User? currentUser = FirebaseAuth.instance.currentUser;
          if (currentUser == null) {
            toastification.show(
                context: context, // optional if you use ToastificationWrapper
                title: const Text(
                  "user dont exist",
                  maxLines: 10, // Limit to 2 lines
                  overflow:
                      TextOverflow.ellipsis, // Add ellipsis for longer text
                ));
            return;
          }
          String uid = currentUser.uid;

          // fetch docs
          DocumentReference docRef =
              FirebaseFirestore.instance.collection('users').doc(uid);

          // upsert field
          await docRef.set({
            "profileImageUrl": response?.data?.secureUrl, // The field to upsert
          }, SetOptions(merge: true)); // Ensures upsert behavior

          if (response?.data?.secureUrl != null) {
            profileProvider
                .setProfileImage(response!.data!.secureUrl.toString());
          }

          // successfully completed
          toastification.show(
              context: context, // optional if you use ToastificationWrapper
              title: const Text(
                "profile image updated successfully",
                maxLines: 10, // Limit to 2 lines
                overflow: TextOverflow.ellipsis, // Add ellipsis for longer text
              ));
        }
      } catch (e) {
        print('Image picking error: $e');
      }
    }

    void delteImage() async {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        toastification.show(
            context: context, // optional if you use ToastificationWrapper
            title: const Text(
              "user dont exist",
              maxLines: 10, // Limit to 2 lines
              overflow: TextOverflow.ellipsis, // Add ellipsis for longer text
            ));
        return;
      }
      String uid = currentUser.uid;

      // fetch docs
      DocumentReference docRef =
          FirebaseFirestore.instance.collection('users').doc(uid);

      await docRef.set({
        "profileImageUrl":
            SD["anonimousProfileImage"].toString(), // The field to upsert
      }, SetOptions(merge: true)); // Ensures upsert behavior

      profileProvider.setProfileImage(SD["anonimousProfileImage"].toString());

      // successfully completed
      toastification.show(
          context: context, // optional if you use ToastificationWrapper
          title: const Text(
            "profile image deleted successfully",
            maxLines: 10, // Limit to 2 lines
            overflow: TextOverflow.ellipsis, // Add ellipsis for longer text
          ));
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
            OutlinedButton(
              onPressed: () {
                pickImage();
              },
              child: const Text('select profile  image'),
            ),
            OutlinedButton(
              onPressed: () {
                delteImage();
              },
              child: const Text('delte proifle image'),
            ),
          ],
        ),
      ),
    );
  }
}
