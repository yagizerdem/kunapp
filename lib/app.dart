import 'package:app/Components/MainLayout.dart';
import 'package:app/Providers/CustomAuthProvider.dart';
import 'package:app/pages/RegisterPage.dart';
import 'package:app/utils/AuthWrapper.dart';
import 'package:app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<CustomAuthProvider>(context);

    // Show a loading screen while authentication state is being determined
    if (authProvider.isLoading) {
      return MaterialApp(
        title: 'initilizing app ...',
        theme: ThemeData(
          primarySwatch: AppColors.themeSwatch,
        ),
        home: const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: AppColors.themeSwatch,
        ),
        home: const AuthWrapper());
  }
}
