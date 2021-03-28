import 'package:flutter_lovers/model/app_user_model.dart';
import 'package:flutter_lovers/services/auth_base.dart';

class FakeAuthService implements AuthBase {
  String userID = "12345678910";

  @override
  Future<AppUser> getCurrentUser() async {
    return await Future.value(AppUser(userID: userID));
  }

  @override
  Future<AppUser> signInAnonymously() async {
    return await Future.delayed(
        Duration(seconds: 2), () => AppUser(userID: userID));
  }

  @override
  Future<bool> signOut() async {
    return Future.value(true);
  }

  @override
  Future<AppUser> signInWithGmail() {
    // TODO: implement signInWithGmail
    throw UnimplementedError();
  }
}
