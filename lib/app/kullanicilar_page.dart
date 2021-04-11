import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_lovers/app/konusma_page.dart';
import 'package:flutter_lovers/model/app_user_model.dart';
import 'package:flutter_lovers/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

class KullanicilarPage extends StatefulWidget {
  @override
  _KullanicilarPageState createState() => _KullanicilarPageState();
}

class _KullanicilarPageState extends State<KullanicilarPage> {
  List<AppUser> _tumKullanicilar;
  bool _isLoading = false;
  bool _hasMore = true;
  int _getirilecekElemanSayisi = 12;
  AppUser _enSonGetirilenUser;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Context oluşmadan dinlendiğinde hataya sebep oluyor, bu yüzden provider da ya listen false geçilmeli, yada schedulerbinding ile buildden sonra çalıştırılmalı.
//    SchedulerBinding.instance.addPostFrameCallback((_) {
//      getAppUser();
//    });

    getAppUser();

    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels == 0) {
          // listenin başı
        } else {
          // listenin sonu
          getAppUser();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Kullanıcılar"),
        ),
        body: _tumKullanicilar == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : _kullaniciListesiniOlustur());
  }

  getAppUser() async {
    // listen false geçersek sorun olmuyor.
    final _userModel = Provider.of<UserModel>(context, listen: false);

    if (!_hasMore) {
      return;
    }

    if (_isLoading) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    List<AppUser> _users = await _userModel.getUserWithPagination(
        _enSonGetirilenUser, _getirilecekElemanSayisi);

    if (_tumKullanicilar == null) {
      _tumKullanicilar = [];
      _tumKullanicilar.addAll(_users);
    } else {
      _tumKullanicilar.addAll(_users);
    }

    if (_users.length < _getirilecekElemanSayisi) {
      _hasMore = false;
    }

    _enSonGetirilenUser = _tumKullanicilar.last;

    setState(() {
      _isLoading = false;
    });
  }

  _kullaniciListesiniOlustur() {
    return ListView.builder(
      itemBuilder: (context, index) {
        if (index == _tumKullanicilar.length) {
          return _yeniElemanlarYukleniyor();
        }

        return ListTile(
          title: Text(_tumKullanicilar[index].userName),
        );
      },
      itemCount: _tumKullanicilar.length + 1,
      controller: _scrollController,
    );
  }

  _yeniElemanlarYukleniyor() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Center(
        child: Opacity(
          opacity: _isLoading ? 1 : 0,
          child: _isLoading ? CircularProgressIndicator() : null,
        ),
      ),
    );
  }
}
