import 'package:flutter/material.dart';
import 'package:flutter_lovers/locator.dart';
import 'package:flutter_lovers/model/app_user_model.dart';
import 'package:flutter_lovers/repository/user_repository.dart';

enum AllUserViewState { Idle, Loaded, Busy }

class AllUserViewModel extends ChangeNotifier {
  AllUserViewState _state = AllUserViewState.Idle;
  UserRepository _userRepository = locator.get<UserRepository>();
  bool _hasMore = true;

  bool get hasMoreLoading => _hasMore;

  List<AppUser> _tumKullanicilar;
  AppUser _enSonGetirilenAppUser;
  static final _sayfaBasinaGonderiSayisi = 10;

  List<AppUser> get kullanicilarListesi => _tumKullanicilar;
  AllUserViewState get state => _state;

  set state(AllUserViewState value) {
    _state = value;
    notifyListeners();
  }

  AllUserViewModel() {
    _tumKullanicilar = [];
    _enSonGetirilenAppUser = null;
    getAppUserWithPagination(_enSonGetirilenAppUser, false);
  }

  getAppUserWithPagination(
      AppUser enSonGetirilenAppUser, bool yeniElemanGetiriliyor) async {
    if (_tumKullanicilar.length > 0) {
      _enSonGetirilenAppUser = _tumKullanicilar.last;
    }

    if (!yeniElemanGetiriliyor) {
      state = AllUserViewState.Busy;
    }

    var _yeniListe = await _userRepository.getUserWithPagination(
        _enSonGetirilenAppUser, _sayfaBasinaGonderiSayisi);

    if (_yeniListe.length < _sayfaBasinaGonderiSayisi) {
      _hasMore = false;
    }

    _tumKullanicilar.addAll(_yeniListe);
    state = AllUserViewState.Loaded;
  }

  void dahaFazlaKullaniciGetir() async {
    if (_hasMore) {
      getAppUserWithPagination(_enSonGetirilenAppUser, true);
    } else {
      print("Daha fazla eleman yok !");
    }
    await Future.delayed(Duration(seconds: 2));
  }

  Future<Null> onRefresh() async {
    _enSonGetirilenAppUser = null;
    _hasMore = true;
    _tumKullanicilar = [];
    await getAppUserWithPagination(_enSonGetirilenAppUser, true);
  }
}
