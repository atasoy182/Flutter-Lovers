import 'package:flutter_lovers/model/app_user_model.dart';

abstract class DBBase {
  Future<bool> saveUser(AppUser appUser);
  Future<AppUser> readUser(String UserID);
  Future<bool> updateUserName(String UserID, String yeniUserName);
  Future<bool> updateProfilFoto(String userID, String profilFotoUrl);
  Future<List<AppUser>> getAllUser();
}
