import 'package:flutter/material.dart';
import 'package:flutter_lovers/locator.dart';
import 'package:flutter_lovers/model/app_user_model.dart';
import 'package:flutter_lovers/repository/user_repository.dart';
import 'package:flutter_lovers/services/auth_base.dart';

enum ViewState { Idle, Busy }

class UserModel with ChangeNotifier implements AuthBase {
  ViewState _state = ViewState.Idle;
  UserRepository _userRepository = locator.get<UserRepository>();
  AppUser _user;
  String sifreHataMesaji;
  String mailHataMesaji;

  ViewState get state => _state;

  set state(ViewState value) {
    _state = value;
    notifyListeners();
  }

  AppUser get user => _user;

  UserModel() {
    getCurrentUser();
  }

  @override
  Future<AppUser> getCurrentUser() async {
    try {
      state = ViewState.Busy;
      _user = await _userRepository.getCurrentUser();
      return _user;
    } catch (e) {
      debugPrint("View modeldeki getCurrentUser hatası ${e.toString()}");
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<AppUser> signInAnonymously() async {
    try {
      state = ViewState.Busy;
      _user = await _userRepository.signInAnonymously();
      return _user;
    } catch (e) {
      debugPrint("View modeldeki signInAnonymously hatası ${e.toString()}");
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      state = ViewState.Busy;
      bool result = await _userRepository.signOut();
      _user = null;
      return result;
    } catch (e) {
      debugPrint("View modeldeki signOut hatası ${e.toString()}");
      return false;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<AppUser> signInWithGmail() async {
    try {
      state = ViewState.Busy;
      _user = await _userRepository.signInWithGmail();
      return _user;
    } catch (e) {
      debugPrint(
          "UserModel View modeldeki signInWithGmail hatası ${e.toString()}");
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<AppUser> signInWithFacebook() async {
    try {
      state = ViewState.Busy;
      _user = await _userRepository.signInWithFacebook();
      return _user;
    } catch (e) {
      debugPrint(
          "UserModel View modeldeki signInWithFacebook hatası ${e.toString()}");
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<AppUser> createUserWithEmailAndPassword(
      String email, String password) async {
    if (_emailSifreKontrol(email, password)) {
      state = ViewState.Busy;
      try {
        _user = await _userRepository.createUserWithEmailAndPassword(
            email, password);
      } finally {
        state = ViewState.Idle;
      }
      return _user;
    } else
      return null;
  }

  @override
  Future<AppUser> signInEmailAndPassword(String email, String password) async {
    try {
      if (_emailSifreKontrol(email, password)) {
        state = ViewState.Busy;
        _user = await _userRepository.signInEmailAndPassword(email, password);
        return _user;
      } else
        return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  bool _emailSifreKontrol(String email, String sifre) {
    var result = true;

    if (sifre.length < 6) {
      sifreHataMesaji = "En az 6 karakter olmalı !";
      result = false;
    } else
      sifreHataMesaji = null;

    if (!email.contains("@")) {
      mailHataMesaji = "Geçersiz e mail adresi !";
      result = false;
    } else
      mailHataMesaji = null;

    return result;
  }

  Future<bool> updateUserName(String userID, String yeniUserName) async {
    var _sonuc = await _userRepository.updateUserName(userID, yeniUserName);
    if (_sonuc) {
      _user.userName = yeniUserName;
    }
    return _sonuc;
  }

//
}
