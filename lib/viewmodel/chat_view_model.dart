import 'package:flutter/material.dart';
import 'package:flutter_lovers/locator.dart';
import 'package:flutter_lovers/model/app_user_model.dart';
import 'package:flutter_lovers/model/mesaj_model.dart';
import 'package:flutter_lovers/repository/user_repository.dart';

enum ChatViewState { Idle, Busy, Loaded }

class ChatViewModel with ChangeNotifier {
  List<Mesaj> _tumMesajlar;
  ChatViewState _state = ChatViewState.Idle;
  static final sayfaBasinaGonderiSayisi = 12;
  Mesaj _enSonGetirilenMesaj;
  Mesaj _listeyeEklenenIlkMesaj;
  bool _hasMore = true;
  bool _yeniMesajDinle = false;

  UserRepository _userRepository = locator.get<UserRepository>();

  bool get hasMoreLoading => _hasMore;

  final AppUser currentUser;
  final AppUser sohbetEdilenUser;

  ChatViewModel({this.currentUser, this.sohbetEdilenUser}) {
    _tumMesajlar = [];
    getMessageWithPagination(true);
  }

  List<Mesaj> get mesajlarListesi => _tumMesajlar;

  ChatViewState get state => _state;

  set state(ChatViewState value) {
    _state = value;
    notifyListeners();
  }

  void getMessageWithPagination(bool yeniMesajlarGetiriliyor) async {
    if (_tumMesajlar.length > 0) {
      _enSonGetirilenMesaj = _tumMesajlar.last;
    }

    if (yeniMesajlarGetiriliyor) {
      state = ChatViewState.Busy;
    }
    var _getirilenMesajlar = await _userRepository.getMessagesWithPagination(
        currentUser.userID,
        sohbetEdilenUser.userID,
        _enSonGetirilenMesaj,
        sayfaBasinaGonderiSayisi);
    _tumMesajlar.addAll(_getirilenMesajlar);
    if (_tumMesajlar.length > 0) {
      _listeyeEklenenIlkMesaj = _tumMesajlar.first;
      print("Listeye eklenen ilk mesaj" + _listeyeEklenenIlkMesaj.toString());
    }

    state = ChatViewState.Loaded;

    if (_getirilenMesajlar.length < sayfaBasinaGonderiSayisi) {
      _hasMore = false;
    }

    _getirilenMesajlar.forEach((element) {
      print("Gelen mesaj = > " + element.mesaj);
    });

    if (!_yeniMesajDinle) {
      _yeniMesajDinle = true;
      _yeniMesajListenerAta();
    }
  }

  Future<bool> saveMessage(Mesaj kaydedilecekMesaj) async {
    return await _userRepository.saveMessage(kaydedilecekMesaj);
  }

  void dahaFazlaMesajGetir() async {
    if (_hasMore) {
      getMessageWithPagination(false);
    } else {
      print("Daha fazla eleman yok !");
    }
    await Future.delayed(Duration(seconds: 2));
  }

  void _yeniMesajListenerAta() {
    print(" Yeni mesajlar için Mesajlar Atandı");
    _userRepository
        .getMessages(currentUser.userID, sohbetEdilenUser.userID)
        .listen((anlikData) {
      print("Listener tetiklendi Son getirilen veri : " +
          anlikData[0].toString());

      if (anlikData.isNotEmpty) {
        if (anlikData[0].date != null) {
          if (_listeyeEklenenIlkMesaj == null) {
            _tumMesajlar.insert(0, anlikData[0]);
          } else if (_listeyeEklenenIlkMesaj.date.millisecondsSinceEpoch !=
              anlikData[0].date.millisecondsSinceEpoch) {
            _tumMesajlar.insert(0, anlikData[0]);
          }
        }

        state = ChatViewState.Loaded;
      }
    });
  }
}
