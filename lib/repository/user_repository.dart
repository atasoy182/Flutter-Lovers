import 'package:flutter_lovers/locator.dart';
import 'package:flutter_lovers/model/app_user_model.dart';
import 'package:flutter_lovers/services/auth_base.dart';
import 'package:flutter_lovers/services/fake_auth_service.dart';
import 'package:flutter_lovers/services/firebase_auth_service.dart';

enum AppMode { DEBUG, RELEASE }

class UserRepository implements AuthBase {
  FirebaseAuthService _firebaseAuthService = locator.get<FirebaseAuthService>();
  FakeAuthService _fakeAuthService = locator.get<FakeAuthService>();

  AppMode appMode = AppMode.RELEASE;

  @override
  Future<AppUser> getCurrentUser() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.getCurrentUser();
    } else {
      return await _firebaseAuthService.getCurrentUser();
    }
  }

  @override
  Future<AppUser> signInAnonymously() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signInAnonymously();
    } else {
      return await _firebaseAuthService.signInAnonymously();
    }
  }

  @override
  Future<bool> signOut() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signOut();
    } else {
      return await _firebaseAuthService.signOut();
    }
  }
}
