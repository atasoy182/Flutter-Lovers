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

  ViewState get state => _state;

  set state(ViewState value) {
    _state = value;
    notifyListeners();
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
      return await _userRepository.signOut();
    } catch (e) {
      debugPrint("View modeldeki signOut hatası ${e.toString()}");
      return false;
    } finally {
      state = ViewState.Idle;
    }
  }

//
}
