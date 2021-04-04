import 'package:flutter_lovers/locator.dart';
import 'package:flutter_lovers/model/app_user_model.dart';
import 'package:flutter_lovers/services/auth_base.dart';
import 'package:flutter_lovers/services/fake_auth_service.dart';
import 'package:flutter_lovers/services/firebase_auth_service.dart';
import 'package:flutter_lovers/services/firestore_db_service.dart';

enum AppMode { DEBUG, RELEASE }

class UserRepository implements AuthBase {
  FirebaseAuthService _firebaseAuthService = locator.get<FirebaseAuthService>();
  FakeAuthService _fakeAuthService = locator.get<FakeAuthService>();
  FireStoreDBService _fireStoreDBService = locator.get<FireStoreDBService>();

  AppMode appMode = AppMode.RELEASE;

  @override
  Future<AppUser> getCurrentUser() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.getCurrentUser();
    } else {
      AppUser _appUser = await _firebaseAuthService.getCurrentUser();
      return await _fireStoreDBService.readUser(_appUser.userID);
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

  @override
  Future<AppUser> signInWithGmail() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signInWithGmail();
    } else {
      AppUser _appuser = await _firebaseAuthService.signInWithGmail();
      bool _result = await _fireStoreDBService.saveUser(_appuser);

      if (_result) {
        return await _fireStoreDBService.readUser(_appuser.userID);
      } else
        return null;
    }
  }

  @override
  Future<AppUser> signInWithFacebook() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signInWithFacebook();
    } else {
      AppUser _appuser = await _firebaseAuthService.signInWithFacebook();
      bool _result = await _fireStoreDBService.saveUser(_appuser);

      if (_result) {
        return await _fireStoreDBService.readUser(_appuser.userID);
      } else
        return null;
    }
  }

  @override
  Future<AppUser> createUserWithEmailAndPassword(
      String email, String password) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.createUserWithEmailAndPassword(
          email, password);
    } else {
      AppUser _appuser = await _firebaseAuthService
          .createUserWithEmailAndPassword(email, password);

      bool _result = await _fireStoreDBService.saveUser(_appuser);

      if (_result) {
        return await _fireStoreDBService.readUser(_appuser.userID);
      } else
        return null;
    }
  }

  @override
  Future<AppUser> signInEmailAndPassword(String email, String password) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signInEmailAndPassword(email, password);
    } else {
      AppUser _user =
          await _firebaseAuthService.signInEmailAndPassword(email, password);
      return await _fireStoreDBService.readUser(_user.userID);
    }
  }
}
