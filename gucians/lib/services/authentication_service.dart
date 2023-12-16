import "package:firebase_auth/firebase_auth.dart";
import "package:gucians/common/error_messages.dart";

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future signup(String email, String password, String name) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future login(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found" || e.code == "wrong-password") {
        return ErrorMessages.login;
      }
      return e.message;
    }
  }

  Future logout() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      return null;
    }
  }

  Future sendVerificationEmail() async {
    try {
      final user = _auth.currentUser!;
      await user.sendEmailVerification();
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
