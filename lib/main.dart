import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:services_catalog/authentication/home_page.dart';
import 'package:services_catalog/firebase_options.dart';
import 'package:services_catalog/injection.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage());
  }
}
