import 'package:app/Providers/MainScreenProvider.dart';
import 'package:app/Providers/ProfileProvider.dart';
import 'package:app/app.dart';
import 'package:app/utils/AuthWrapper.dart';
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
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MainScreenProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
      ],
      child: const ToastificationWrapper(
        child: App(),
      ),
    ),
  );
}
