import 'package:flutter_lovers/model/app_user_model.dart';
import 'package:flutter_lovers/model/konusma_model.dart';
import 'package:flutter_lovers/model/mesaj_model.dart';

abstract class DBBase {
  Future<bool> saveUser(AppUser appUser);
  Future<AppUser> readUser(String UserID);
  Future<bool> updateUserName(String UserID, String yeniUserName);
  Future<bool> updateProfilFoto(String userID, String profilFotoUrl);
  Future<List<AppUser>> getAllUser();
  Future<List<Konusma>> getAllConversations(String userID);
  Stream<List<Mesaj>> getMessages(String currentUserID, String konusulanUserID);
  Future<bool> saveMessage(Mesaj kaydedilcekMesaj);
}
