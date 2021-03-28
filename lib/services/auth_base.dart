import 'package:flutter_lovers/model/app_user_model.dart';

abstract class AuthBase {
  Future<AppUser> getCurrentUser();
  Future<AppUser> signInAnonymously();
  Future<bool> signOut();
  Future<AppUser> signInWithGmail();
  Future<AppUser> signInWithFacebook();
  Future<AppUser> signInEmailAndPassword(String email, String password);
  Future<AppUser> createUserWithEmailAndPassword(String email, String password);
}
