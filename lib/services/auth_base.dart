import 'package:flutter_lovers/model/app_user_model.dart';

abstract class AuthBase {
  Future<AppUser> getCurrentUser();
  Future<AppUser> signInAnonymously();
  Future<bool> signOut();
  Future<AppUser> signInWithGmail();
}
