import 'package:flutter/material.dart';
import 'package:flutter_lovers/locator.dart';
import 'package:flutter_lovers/model/app_user_model.dart';
import 'package:flutter_lovers/model/mesaj_model.dart';
import 'package:flutter_lovers/repository/user_repository.dart';

enum ChatViewState { Idle, Busy, Loaded }

class ChatViewModel with ChangeNotifier {
  List<Mesaj> _tumMesajlar;
  ChatViewState _state = ChatViewState.Idle;
  static final sayfaBasinaGonderiSayisi = 10;
  Mesaj _enSonGetirilenMesaj;

  UserRepository _userRepository = locator.get<UserRepository>();

  final AppUser currentUser;
  final AppUser sohbetEdilenUser;

  ChatViewModel({this.currentUser, this.sohbetEdilenUser}) {
    _tumMesajlar = [];
    getMessageWithPagination();
  }

  List<Mesaj> get mesajlarListesi => _tumMesajlar;
  ChatViewState get state => _state;

  set state(ChatViewState value) {
    _state = value;
    notifyListeners();
  }

  void getMessageWithPagination() async {
    state = ChatViewState.Busy;
    var _getirilenMesajlar = await _userRepository.getMessagesWithPagination(
        currentUser.userID,
        sohbetEdilenUser.userID,
        _enSonGetirilenMesaj,
        sayfaBasinaGonderiSayisi);
    _tumMesajlar.addAll(_getirilenMesajlar);
    state = ChatViewState.Loaded;
  }
}
