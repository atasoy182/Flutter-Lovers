import 'package:flutter_lovers/model/app_user_model.dart';
import 'package:flutter_lovers/services/auth_base.dart';

class FakeAuthService implements AuthBase {
  String userID = "12345678910";
  String fakeEmail = "fake@fakemail.com";

  @override
  Future<AppUser> getCurrentUser() async {
    return await Future.value(AppUser(userID: userID, email: fakeEmail));
  }

  @override
  Future<AppUser> signInAnonymously() async {
    return await Future.delayed(
        Duration(seconds: 2), () => AppUser(userID: userID, email: fakeEmail));
  }

  @override
  Future<bool> signOut() async {
    return Future.value(true);
  }

  @override
  Future<AppUser> signInWithGmail() async {
    return await Future.delayed(
        Duration(seconds: 2),
        () =>
            AppUser(userID: "sign_in_with_gmail_" + userID, email: fakeEmail));
  }

  @override
  Future<AppUser> signInWithFacebook() async {
    return await Future.delayed(
        Duration(seconds: 2),
        () => AppUser(
            userID: "sign_in_with_facebook_" + userID, email: fakeEmail));
  }

  @override
  Future<AppUser> createUserWithEmailAndPassword(
      String email, String password) async {
    return await Future.delayed(
        Duration(seconds: 2),
        () => AppUser(
            userID: "createUserWithEmailAndPassword_" + userID,
            email: fakeEmail));
  }

  @override
  Future<AppUser> signInEmailAndPassword(String email, String password) async {
    return await Future.delayed(
        Duration(seconds: 2),
        () => AppUser(
            userID: "signInEmailAndPassword_" + userID, email: fakeEmail));
  }
}
