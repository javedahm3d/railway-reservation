import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:railways/pages/homepage.dart';
import 'package:railways/pages/train_list_page.dart';
import 'firebase_options.dart';
import 'login/auth_page.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      // themeMode: ThemeData(),
      home: AuthPage(),
    );
  }
}
