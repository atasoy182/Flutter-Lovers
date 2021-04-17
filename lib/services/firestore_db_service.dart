import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_lovers/model/app_user_model.dart';
import 'package:flutter_lovers/model/konusma_model.dart';
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

//  @override
//  Future<List<AppUser>> getAllUser() async {
//    QuerySnapshot _querySnapshot = await _firestore.collection("users").get();
//    List<AppUser> tumKullanicilar;
//    tumKullanicilar =
//        _querySnapshot.docs.map((e) => AppUser.fromMap(e.data())).toList();
//    return tumKullanicilar;
//  }

  @override
  Future<List<Konusma>> getAllConversations(String userID) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection("konusmalar")
        .where("konusma_sahibi", isEqualTo: userID)
        .orderBy("olusturulma_tarihi", descending: true)
        .get();
    List<Konusma> tumKonusmalar = [];

    for (DocumentSnapshot tekKonusma in querySnapshot.docs) {
      tumKonusmalar.add(Konusma.fromMap(tekKonusma.data()));
    }

    return tumKonusmalar;
  }

  @override
  Stream<List<Mesaj>> getMessages(
      String currentUserID, String konusulanUserID) {
    var _querysnapshot = _firestore
        .collection("konusmalar")
        .doc(currentUserID + '--' + konusulanUserID)
        .collection("mesajlar")
        .orderBy("date", descending: true)
        .snapshots();
    return _querysnapshot.map((mesajListesi) =>
        mesajListesi.docs.map((mesaj) => Mesaj.fromMap(mesaj.data())).toList());
  }

  Future<bool> saveMessage(Mesaj kaydedilecekMesaj) async {
    var _messageID = _firestore.collection("konusmalar").doc().id;
    var _documentID = kaydedilecekMesaj.kimden + "--" + kaydedilecekMesaj.kime;
    var _receiverDocumentID =
        kaydedilecekMesaj.kime + "--" + kaydedilecekMesaj.kimden;
    var _kaydedilecekMesajYapisi = kaydedilecekMesaj.toMap();

    await _firestore
        .collection("konusmalar")
        .doc(_documentID)
        .collection("mesajlar")
        .doc(_messageID)
        .set(_kaydedilecekMesajYapisi);

    await _firestore.collection("konusmalar").doc(_documentID).set({
      'konusma_sahibi': kaydedilecekMesaj.kimden,
      'kimle_konusuyor': kaydedilecekMesaj.kime,
      'son_yollanan_mesaj': kaydedilecekMesaj.mesaj,
      'konusma_goruldu': false,
      'olusturulma_tarihi': FieldValue.serverTimestamp(),
    });

    _kaydedilecekMesajYapisi.update('bendenMi', (value) => false);

    await _firestore
        .collection("konusmalar")
        .doc(_receiverDocumentID)
        .collection("mesajlar")
        .doc(_messageID)
        .set(_kaydedilecekMesajYapisi);

    await _firestore.collection("konusmalar").doc(_receiverDocumentID).set({
      'konusma_sahibi': kaydedilecekMesaj.kime,
      'kimle_konusuyor': kaydedilecekMesaj.kimden,
      'son_yollanan_mesaj': kaydedilecekMesaj.mesaj,
      'konusma_goruldu': false,
      'olusturulma_tarihi': FieldValue.serverTimestamp(),
    });

    return true;
  }

  @override
  Future<DateTime> saatiGoster(String userID) async {
    await _firestore
        .collection("server")
        .doc(userID)
        .set({'saat': FieldValue.serverTimestamp()});

    var okunanMap = await _firestore.collection("server").doc(userID).get();
    Timestamp okunanTarih = okunanMap.data()['saat'];

    return okunanTarih.toDate();
  }

  @override
  Future<List<AppUser>> getUserwithPagination(
      AppUser enSonGetirilenUser, int getirilecekElemanSayisi) async {
    QuerySnapshot _querySnapshot;
    List<AppUser> _tumKullanicilar = [];

    if (enSonGetirilenUser == null) {
      _querySnapshot = await FirebaseFirestore.instance
          .collection("users")
          .orderBy("userName")
          .limit(getirilecekElemanSayisi)
          .get();
    } else {
      _querySnapshot = await FirebaseFirestore.instance
          .collection("users")
          .orderBy("userName")
          .startAfter([enSonGetirilenUser.userName])
          .limit(getirilecekElemanSayisi)
          .get();

      await Future.delayed(Duration(seconds: 1));
    }

    for (DocumentSnapshot snap in _querySnapshot.docs) {
      AppUser _tekUser = AppUser.fromMap(snap.data());
      _tumKullanicilar.add(_tekUser);
    }

    return _tumKullanicilar;
  }

  Future<List<Mesaj>> getMessagesWithPagination(
      String currentUserID,
      String sohbetEdilenUserID,
      Mesaj enSonGetirilenMesaj,
      int getirilecekElemanSayisi) async {
    QuerySnapshot _querySnapshot;
    List<Mesaj> _tumMesajlar = [];

    if (enSonGetirilenMesaj == null) {
      _querySnapshot = await FirebaseFirestore.instance
          .collection("konusmalar")
          .doc(currentUserID + '--' + sohbetEdilenUserID)
          .collection("mesajlar")
          .orderBy("date", descending: true)
          .limit(getirilecekElemanSayisi)
          .get();
    } else {
      _querySnapshot = await FirebaseFirestore.instance
          .collection("konusmalar")
          .doc(currentUserID + '--' + sohbetEdilenUserID)
          .collection("mesajlar")
          .orderBy("date", descending: true)
          .startAfter([enSonGetirilenMesaj.date])
          .limit(getirilecekElemanSayisi)
          .get();

      await Future.delayed(Duration(seconds: 1));
    }

    for (DocumentSnapshot snap in _querySnapshot.docs) {
      Mesaj _tekMesaj = Mesaj.fromMap(snap.data());
      _tumMesajlar.add(_tekMesaj);
    }

    return _tumMesajlar;
  }
}
