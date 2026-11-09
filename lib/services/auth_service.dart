import 'package:firebase_auth/firebase_auth.dart';
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
}
