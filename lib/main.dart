import 'package:app/Providers/CustomAuthProvider.dart';
import 'package:app/Providers/MainScreenProvider.dart';
import 'package:app/Providers/ProfileProvider.dart';
import 'package:app/app.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:toastification/toastification.dart';

import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print("Firebase initialized");

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MainScreenProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => CustomAuthProvider()),
      ],
      child: const ToastificationWrapper(
        child: App(),
      ),
    ),
  );
}
