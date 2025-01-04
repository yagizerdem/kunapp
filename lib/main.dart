import 'package:app/Providers/CustomAuthProvider.dart';
import 'package:app/Providers/MainScreenProvider.dart';
import 'package:app/Providers/ProfileProvider.dart';
import 'package:app/app.dart';
import 'package:app/utils/RestartWidget.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:toastification/toastification.dart';

import 'package:provider/provider.dart';

import 'package:cloudinary_url_gen/cloudinary.dart';

var cloudinary = Cloudinary.fromStringUrl(
    'cloudinary://886452983873293:DG27kaeVO9j_Tx1ymIfSYLDYOk4@dx9eu6m3u');

void main() async {
  cloudinary.config.urlConfig.secure = true;

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print("Firebase initialized");

  runApp(RestartWidget(
    child: MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MainScreenProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => CustomAuthProvider()),
      ],
      child: const ToastificationWrapper(
        child: App(),
      ),
    ),
  ));
}
