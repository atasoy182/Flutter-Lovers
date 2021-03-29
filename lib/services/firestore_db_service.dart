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
}
