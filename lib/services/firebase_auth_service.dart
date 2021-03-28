import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_lovers/model/app_user_model.dart';
import 'package:flutter_lovers/services/auth_base.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
      final _googleSignIn = GoogleSignIn();
      await _googleSignIn.signOut();
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

  @override
  Future<AppUser> signInWithGmail() async {
    try {
      GoogleSignIn _googleSignIn = GoogleSignIn();
      GoogleSignInAccount _googleUser = await _googleSignIn.signIn();
      if (_googleUser != null) {
        GoogleSignInAuthentication _googleAuth =
            await _googleUser.authentication;
        if (_googleAuth.accessToken != null && _googleAuth.idToken != null) {
          UserCredential authResult = await _firebaseAuth.signInWithCredential(
              GoogleAuthProvider.credential(
                  idToken: _googleAuth.idToken,
                  accessToken: _googleAuth.accessToken));
          User user = authResult.user;
          return _userFromFirebase(user);
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      print("Gmail oturum açma hatası " + e.toString());
    }
  }
}
