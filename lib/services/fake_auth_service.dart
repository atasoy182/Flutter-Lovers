import 'package:flutter_lovers/model/app_user_model.dart';
import 'package:flutter_lovers/services/auth_base.dart';

class FakeAuthService implements AuthBase {
  @override
  Future<AppUser> getCurrentUser() {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }

  @override
  Future<AppUser> signInAnonymously() {
    // TODO: implement signInAnonymously
    throw UnimplementedError();
  }

  @override
  Future<bool> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }
}
