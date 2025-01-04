import 'package:app/Components/MainLayout.dart';
import 'package:app/pages/RegisterPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/Providers/CustomAuthProvider.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<CustomAuthProvider>(context);

    // Display a loading screen while determining the user's auth state
    if (authProvider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // The user state and navigation are managed in CustomAuthProvider
    return authProvider.user != null ? MainLayout() : RegisterPage();
  }
}
