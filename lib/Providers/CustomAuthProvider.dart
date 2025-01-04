import 'package:app/Components/MainLayout.dart';
import 'package:app/app.dart';
import 'package:app/pages/RegisterPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CustomAuthProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = true;

  // Public getters for user and loading state
  User? get user => _user;
  bool get isLoading => _isLoading;

  // Constructor to initialize and listen to auth state changes
  CustomAuthProvider() {
    _initializeAuthState();
  }

  void _initializeAuthState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      _user = user;
      _isLoading = false;
      notifyListeners(); // Notify listeners when auth state changes
      navigateBasedOnAuthState(); // Automatically navigate based on auth state
    });
  }

  void navigateBasedOnAuthState() {
    if (_user != null) {
      navigatorKey.currentState?.pushReplacement(
        MaterialPageRoute(builder: (context) => const MainLayout()),
      );
    } else {
      navigatorKey.currentState?.pushReplacement(
        MaterialPageRoute(builder: (context) => const RegisterPage()),
      );
    }
  }
}
