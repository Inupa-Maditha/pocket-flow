import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static Future<bool> emailRegistration(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      if (!userCredential.user!.emailVerified) {
        await userCredential.user!.sendEmailVerification();
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  static bool get isGoogleUser => FirebaseAuth.instance.currentUser!.providerData.any(
    (p) => p.providerId == 'google.com',
  );

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
      User user = FirebaseAuth.instance.currentUser!;
      await user.reload();
      return (user.emailVerified) ? true : false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> signInWithGoogle() async {
    try {
      await GoogleSignIn.instance.initialize();
      final idToken = (await GoogleSignIn.instance.authenticate()).authentication.idToken;
      await FirebaseAuth.instance.signInWithCredential(
        GoogleAuthProvider.credential(idToken: idToken),
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> signOutUser() async {
    try {
      try {
        await GoogleSignIn.instance.signOut();
      } catch (_) {}
      await FirebaseAuth.instance.signOut();
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> deleteAccount({String? password}) async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      final db = FirebaseFirestore.instance;
      final userDoc = db.collection('users').doc(user.uid);

      // 1. Re-authenticate
      final isGoogle = user.providerData.any((p) => p.providerId == 'google.com');
      if (isGoogle) {
        await GoogleSignIn.instance.initialize();
        final idToken =
            (await GoogleSignIn.instance.authenticate()).authentication.idToken;
        await user.reauthenticateWithCredential(
          GoogleAuthProvider.credential(idToken: idToken),
        );
      } else {
        await user.reauthenticateWithCredential(
          EmailAuthProvider.credential(email: user.email!, password: password!),
        );
      }

      // 2 & 3. Erase the transactions, categories documents
      for (final name in ['transactions', 'categories']) {
        QuerySnapshot<Map<String, dynamic>> snap;
        do {
          snap = await userDoc.collection(name).limit(400).get();
          final batch = db.batch();
          for (final d in snap.docs) {
            batch.delete(d.reference);
          }
          await batch.commit();
        } while (snap.docs.length == 400);
      }

      // 4. remove user document
      await userDoc.delete();

      // 5. Auth user
      await user.delete();
      try {
        await GoogleSignIn.instance.signOut();
      } catch (_) {}
      return true;
    } catch (e) {
      debugPrint('delete account failed: $e');
      return false;
    }
  }
}
