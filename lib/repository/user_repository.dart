import 'dart:io';

import 'package:flutter_lovers/locator.dart';
import 'package:flutter_lovers/model/app_user_model.dart';
import 'package:flutter_lovers/model/konusma_model.dart';
import 'package:flutter_lovers/model/mesaj_model.dart';
import 'package:flutter_lovers/services/auth_base.dart';
import 'package:flutter_lovers/services/fake_auth_service.dart';
import 'package:flutter_lovers/services/firebase_auth_service.dart';
import 'package:flutter_lovers/services/firebase_storage_service.dart';
import 'package:flutter_lovers/services/firestore_db_service.dart';
import 'package:timeago/timeago.dart' as timeago;

enum AppMode { DEBUG, RELEASE }

class UserRepository implements AuthBase {
  FirebaseAuthService _firebaseAuthService = locator.get<FirebaseAuthService>();
  FakeAuthService _fakeAuthService = locator.get<FakeAuthService>();
  FireStoreDBService _fireStoreDBService = locator.get<FireStoreDBService>();
  FirebaseStorageService _firebaseStorageService =
      locator.get<FirebaseStorageService>();

  AppMode appMode = AppMode.RELEASE;

  List<AppUser> tumKullanicilarListesi = [];

  @override
  Future<AppUser> getCurrentUser() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.getCurrentUser();
    } else {
      AppUser _appUser = await _firebaseAuthService.getCurrentUser();
      return await _fireStoreDBService.readUser(_appUser.userID);
    }
  }

  @override
  Future<AppUser> signInAnonymously() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signInAnonymously();
    } else {
      return await _firebaseAuthService.signInAnonymously();
    }
  }

  @override
  Future<bool> signOut() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signOut();
    } else {
      return await _firebaseAuthService.signOut();
    }
  }

  @override
  Future<AppUser> signInWithGmail() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signInWithGmail();
    } else {
      AppUser _appuser = await _firebaseAuthService.signInWithGmail();
      bool _result = await _fireStoreDBService.saveUser(_appuser);

      if (_result) {
        return await _fireStoreDBService.readUser(_appuser.userID);
      } else
        return null;
    }
  }

  @override
  Future<AppUser> signInWithFacebook() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signInWithFacebook();
    } else {
      AppUser _appuser = await _firebaseAuthService.signInWithFacebook();
      bool _result = await _fireStoreDBService.saveUser(_appuser);

      if (_result) {
        return await _fireStoreDBService.readUser(_appuser.userID);
      } else
        return null;
    }
  }

  @override
  Future<AppUser> createUserWithEmailAndPassword(
      String email, String password) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.createUserWithEmailAndPassword(
          email, password);
    } else {
      AppUser _appuser = await _firebaseAuthService
          .createUserWithEmailAndPassword(email, password);

      bool _result = await _fireStoreDBService.saveUser(_appuser);

      if (_result) {
        return await _fireStoreDBService.readUser(_appuser.userID);
      } else
        return null;
    }
  }

  @override
  Future<AppUser> signInEmailAndPassword(String email, String password) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signInEmailAndPassword(email, password);
    } else {
      AppUser _user =
          await _firebaseAuthService.signInEmailAndPassword(email, password);
      return await _fireStoreDBService.readUser(_user.userID);
    }
  }

  Future<bool> updateUserName(String userID, String yeniUserName) async {
    if (appMode == AppMode.DEBUG) {
      return true;
    } else {
      return await _fireStoreDBService.updateUserName(userID, yeniUserName);
    }
  }

  Future<String> updateFile(
      String userID, String fileType, File yeniImage) async {
    if (appMode == AppMode.DEBUG) {
      return 'indirme linki geldi';
    } else {
      var _profilFotoUrl =
          await _firebaseStorageService.uploadFile(userID, fileType, yeniImage);
      await _fireStoreDBService.updateProfilFoto(userID, _profilFotoUrl);
      return _profilFotoUrl;
    }
  }

//  Future<List<AppUser>> getAllUser() async {
//    if (appMode == AppMode.DEBUG) {
//      return [];
//    } else {
//      tumKullanicilarListesi = await _fireStoreDBService.getAllUser();
//      return tumKullanicilarListesi;
//    }
//  }

  Stream<List<Mesaj>> getMessages(
      String currentUserID, String sohbetEdilenUserId) {
    if (appMode == AppMode.DEBUG) {
      return Stream.empty();
    } else {
      return _fireStoreDBService.getMessages(currentUserID, sohbetEdilenUserId);
    }
  }

  Future<bool> saveMessage(Mesaj kaydedilecekMesaj) async {
    if (appMode == AppMode.DEBUG) {
      return true;
    } else {
      return _fireStoreDBService.saveMessage(kaydedilecekMesaj);
    }
  }

  Future<List<Konusma>> getAllConversations(String userID) async {
    if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      DateTime _zaman = await _fireStoreDBService.saatiGoster(userID);

      var konusmaListesi =
          await _fireStoreDBService.getAllConversations(userID);

      for (var satirdakiKonusma in konusmaListesi) {
        var userListesindekiKullanici =
            listedenBul(satirdakiKonusma.kimle_konusuyor);

        if (userListesindekiKullanici != null) {
          print("CACHEDEN GETIRILDI");
          // Veriler cacheden geliyor
          satirdakiKonusma.konusulanUserName =
              userListesindekiKullanici.userName;
          satirdakiKonusma.konusulanUserProfilURL =
              userListesindekiKullanici.profileURL;
          satirdakiKonusma.sonOkunmaZamani = _zaman;

          timeago.setLocaleMessages("tr", timeago.TrMessages());
          var _duration =
              _zaman.difference(satirdakiKonusma.olusturulma_tarihi.toDate());

          satirdakiKonusma.aradakiFark =
              timeago.format(_zaman.subtract(_duration), locale: "tr");
        } else {
          print("DATABASEDEN GETIRILDI");
          // appuser getirilmemiş, readuser ile alalım.
          var veritabanindanOkunanUser = await _fireStoreDBService
              .readUser(satirdakiKonusma.kimle_konusuyor);
          satirdakiKonusma.konusulanUserName =
              veritabanindanOkunanUser.userName;
          satirdakiKonusma.konusulanUserProfilURL =
              veritabanindanOkunanUser.profileURL;
        }

        timeAgoHesapla(satirdakiKonusma, _zaman);
      }
      return konusmaListesi;
    }
  }

  AppUser listedenBul(String userID) {
    for (int i = 0; i < tumKullanicilarListesi.length; i++) {
      if (tumKullanicilarListesi[i].userID == userID) {
        // kullanıcı var app user nesnesini geri döndür.
        return tumKullanicilarListesi[i];
      }
    }
    return null;
  }

  void timeAgoHesapla(Konusma satirdakiKonusma, DateTime zaman) {
    satirdakiKonusma.sonOkunmaZamani = zaman;

    timeago.setLocaleMessages("tr", timeago.TrMessages());

    var _duration =
        zaman.difference(satirdakiKonusma.olusturulma_tarihi.toDate());

    satirdakiKonusma.aradakiFark =
        timeago.format(zaman.subtract(_duration), locale: "tr");
  }

  Future<List<AppUser>> getUserWithPagination(
      AppUser enSonGetirilenUser, int getirilecekElemanSayisi) async {
    if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      List<AppUser> _userList = await _fireStoreDBService.getUserwithPagination(
          enSonGetirilenUser, getirilecekElemanSayisi);

      tumKullanicilarListesi.addAll(_userList);

      return _userList;
    }
  }
}
