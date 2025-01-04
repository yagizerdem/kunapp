import 'package:app/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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
            )
          ],
        ),
      ),
    );
  }
}
