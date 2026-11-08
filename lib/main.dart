import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pocket_flow/firebase_options.dart';
import 'package:pocket_flow/pages/login_register_page.dart';
import 'package:pocket_flow/pages/route_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isValidUser = false;
  @override
  Widget build(BuildContext context) {
    return (isValidUser) ? RoutePage() : LoginRegisterPage();
  }
}
