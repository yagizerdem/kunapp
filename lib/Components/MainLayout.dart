import 'package:app/Components/Footer.dart';
import 'package:app/Providers/MainScreenProvider.dart';
import 'package:app/pages/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainLayout extends StatelessWidget {
  const MainLayout({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mainScreenProvider = Provider.of<MainScreenProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "kun app",
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: mainScreenProvider.mainScreen),
      bottomNavigationBar: const Footer(), // Footer widget applied here
    );
  }
}
