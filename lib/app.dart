import 'package:app/pages/RegisterPage.dart';
import 'package:app/utils/colors.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: AppColors.themeSwatch,
      ),
      home: RegisterPage(),
    );
  }
}
