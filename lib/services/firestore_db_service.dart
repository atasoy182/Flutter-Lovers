import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_lovers/model/app_user_model.dart';
import 'package:flutter_lovers/services/database_base.dart';

class FireStoreDBService implements DBBase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<bool> saveUser(AppUser appUser) async {
    Map _eklenecekUser = appUser.toMap();
    _eklenecekUser['createdAt'] = FieldValue.serverTimestamp();
    _eklenecekUser['updatedAt'] = FieldValue.serverTimestamp();

    await _firestore
        .collection("users")
        .doc(appUser.userID)
        .set(_eklenecekUser);

    DocumentSnapshot _okunanUser =
        await FirebaseFirestore.instance.doc("users/${appUser.userID}").get();

    //_okunanUser.data()

    return true;
  }
}
