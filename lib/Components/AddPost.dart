import 'dart:io';

import 'package:app/main.dart';
import 'package:app/models/PostModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_api/uploader/cloudinary_uploader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:toastification/toastification.dart';
import 'package:uuid/uuid.dart';
import 'package:cloudinary_api/src/request/model/uploader_params.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final ButtonStyle style =
      ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));
  final ImagePicker _picker = ImagePicker();

  final textEditingController = TextEditingController();
  XFile? pickedFile = null;

  void selectFile() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery, // Change to ImageSource.camera for camera
        imageQuality: 80, // Adjust the quality of the image
        maxHeight: 1024, // Resize the image (optional)
        maxWidth: 1024, // Resize the image (optional)
      );
      setState(() {
        this.pickedFile = pickedFile;
      });
    } catch (e) {
      print('Image picking error: $e');
    }
  }

  void Submit() async {
    String postMessage = textEditingController.text;

    try {
      if (pickedFile != null) {
        // extension
        String fileExtension = path.extension(pickedFile!.path);
        // Convert the picked file to a File object
        File imageFile = File(pickedFile!.path);
        final Uuid uuid = Uuid();
        String publicId = uuid.v4();

        var response = await cloudinary.uploader().upload(File(imageFile.path),
            params: UploadParams(
                publicId: publicId, uniqueFilename: true, overwrite: true));
        print(response?.data?.publicId);
        print(response?.data?.secureUrl);

        User? currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser == null) {
          toastification.show(
              title: const Text(
            "user dont exist",
            maxLines: 10, // Limit to 2 lines
            overflow: TextOverflow.ellipsis, // Add ellipsis for longer text
          ));
          return;
        }
        String uid = currentUser.uid;

        // crate Postmodle
        final newPost = PostModel(
          message: postMessage,
          createdAt: DateTime.now(),
          userUid: uid,
          postUrl: response?.data?.secureUrl ?? "",
        );

        // save to firebase
        await FirebaseFirestore.instance
            .collection('posts')
            .add(newPost.toJson());

        toastification.show(
          title: const Text(
            "post added successfully",
            maxLines: 10, // Limit to 2 lines
            overflow: TextOverflow.ellipsis, // Add ellipsis for longer text
          ),
          autoCloseDuration: const Duration(seconds: 5),
        );
      }
    } catch (err) {
      print(err);
      toastification.show(
        title: const Text(
          "error occured",
          maxLines: 10, // Limit to 2 lines
          overflow: TextOverflow.ellipsis, // Add ellipsis for longer text
        ),
        autoCloseDuration: const Duration(seconds: 5),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          ElevatedButton(
            style: style,
            onPressed: () {
              selectFile();
            },
            child: const Text('Select file'),
          ),
          TextField(
            controller: textEditingController,
          ),
          const SizedBox(
            height: 40,
          ),
          ElevatedButton(
            style: style,
            onPressed: () {
              Submit();
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
