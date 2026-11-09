import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pocket_flow/constants/app_theme.dart';

class AuthService {
  static Future<bool> emailRegistration(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      if (!userCredential.user!.emailVerified) {
        await userCredential.user!.sendEmailVerification();
      }
      return true;
    } on FirebaseException catch (e) {
      debugPrint('FIREBASE ERROR: ${e.code} | ${e.message}');
      return false;
    } catch (e) {
      debugPrint('OTHER ERROR: $e');
      await Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 3,
        backgroundColor: AppColors.primaryContainer,
        textColor: AppColors.textPrimary,
        fontSize: 16.0,
      );
      return false;
    }
  }

  static Future<bool> resendVerificationEmail() async {
    try {
      await FirebaseAuth.instance.currentUser!.sendEmailVerification();
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> isEmailVerified() async {
    User user = FirebaseAuth.instance.currentUser!;
    await user.reload();
    if (user.emailVerified) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> isUserVerified(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } catch (e) {
      return false;
    }
  }
}
