import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_lovers/model/app_user_model.dart';
import 'package:flutter_lovers/services/auth_base.dart';

class FirebaseAuthService implements AuthBase {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<AppUser> getCurrentUser() async {
    try {
      User user = _firebaseAuth.currentUser;
      return _userFromFirebase(user);
    } catch (e) {
      print("CURRENT USER HATASI ${e.toString()}");
      return null;
    }
  }

  @override
  Future<AppUser> signInAnonymously() async {
    try {
      UserCredential authResult = await _firebaseAuth.signInAnonymously();
      return _userFromFirebase(authResult.user);
    } catch (e) {
      print("SIGN IN ANONYMOUSLY HATASI ${e.toString()}");
      return null;
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return true;
    } catch (e) {
      print("SIGN OUT HATASI ${e.toString()}");
      return false;
    }
  }

  AppUser _userFromFirebase(User user) {
    if (user == null) {
      return null;
    } else {
      return AppUser(userID: user.uid);
    }
  }
}
