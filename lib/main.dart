import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pocket_flow/constants/app_theme.dart';
import 'package:pocket_flow/firebase_options.dart';
import 'package:pocket_flow/pages/login_register_page.dart';
import 'package:pocket_flow/pages/route_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: buildAppTheme(),
      debugShowCheckedModeBanner: false,
      title: 'pocket flow app',
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(body: Center(child: const CircularProgressIndicator()));
          } else if ((snapshot.data != null && snapshot.data!.emailVerified)) {
            return RoutePage();
          } else {
            return LoginRegisterPage();
          }
        },
      ),
    );
  }
}
