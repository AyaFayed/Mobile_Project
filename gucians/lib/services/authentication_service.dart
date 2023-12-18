import "package:firebase_auth/firebase_auth.dart";
import "package:gucians/common/error_messages.dart";
import "package:gucians/controllers/user_controller.dart";
import "package:gucians/database/reads/user_reads.dart";
import "package:gucians/services/messaging_service.dart";

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserController _user = UserController();
  final UserReads _userReads = UserReads();
  final MessagingService _messaging = MessagingService();

  Future signup(
      String email, String password, String name, String handle) async {
    try {
      bool handleAlreadyExit = await _userReads.handleAlreadyExist(handle);
      if (handleAlreadyExit) {
        return 'This handle is already taken.';
      }
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      await _user.createUser(user?.uid, name, email, handle);

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
      if (e.code == 'user-not-found' ||
          e.code == 'wrong-password' ||
          e.code == 'account-exists-with-different-credential' ||
          e.code == 'invalid-credential') {
        return ErrorMessages.login;
      }
      return e.message;
    }
  }

  Future logout() async {
    try {
      await _messaging.removeToken();
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
