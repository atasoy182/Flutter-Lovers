import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_lovers/model/app_user_model.dart';
import 'package:flutter_lovers/model/mesaj_model.dart';
import 'package:flutter_lovers/services/database_base.dart';

class FireStoreDBService implements DBBase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<bool> saveUser(AppUser appUser) async {
    await _firestore
        .collection("users")
        .doc(appUser.userID)
        .set(appUser.toMap());

    DocumentSnapshot _okunanUserBilgileriMap =
        await FirebaseFirestore.instance.doc("users/${appUser.userID}").get();

    AppUser _okunanUser = AppUser.fromMap(_okunanUserBilgileriMap.data());
    print("Okunan Appuser =" + _okunanUser.toString());

    return true;
  }

  @override
  Future<AppUser> readUser(String UserID) async {
    DocumentSnapshot _okunanUser =
        await _firestore.collection("users").doc(UserID).get();
    Map<String, dynamic> _okunanUserBilgileri = _okunanUser.data();

    AppUser _okunanUserNesnesi = AppUser.fromMap(_okunanUserBilgileri);
    print("Okunan User Nesnesi : " + _okunanUserNesnesi.toString());
    return _okunanUserNesnesi;
  }

  @override
  Future<bool> updateUserName(String UserID, String yeniUserName) async {
    var users = await _firestore
        .collection("users")
        .where("userName", isEqualTo: yeniUserName)
        .get();
    if (users.docs.length >= 1) {
      return false;
    } else {
      await _firestore
          .collection("users")
          .doc(UserID)
          .update({'userName': yeniUserName});
      return true;
    }
  }

  @override
  Future<bool> updateProfilFoto(String userID, String profilFotoUrl) async {
    await _firestore
        .collection("users")
        .doc(userID)
        .update({'profileURL': profilFotoUrl});
    return true;
  }

  @override
  Future<List<AppUser>> getAllUser() async {
    QuerySnapshot _querySnapshot = await _firestore.collection("users").get();
    List<AppUser> tumKullanicilar;
    tumKullanicilar =
        _querySnapshot.docs.map((e) => AppUser.fromMap(e.data())).toList();
    return tumKullanicilar;
  }

  @override
  Stream<List<Mesaj>> getMessages(
      String currentUserID, String konusulanUserID) {
    var _querysnapshot = _firestore
        .collection("konusmalar")
        .doc(currentUserID + '--' + konusulanUserID)
        .collection("mesajlar")
        .orderBy("date")
        .snapshots();
    return _querysnapshot.map((mesajListesi) =>
        mesajListesi.docs.map((mesaj) => Mesaj.fromMap(mesaj.data())).toList());
  }
}
