import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_lovers/model/app_user_model.dart';
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
}
