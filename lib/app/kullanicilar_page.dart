import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

    getAppUser(_enSonGetirilenUser);

    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels == 0) {
          print(" liste başındayız");
        } else {
          // listenin sonu
          print(" liste sonundayız");
          getAppUser(_enSonGetirilenUser);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserModel>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text("Kullanıcılar"),
          actions: [
            FlatButton(
                onPressed: () async {
                  await getAppUser(_enSonGetirilenUser);
                },
                child: Text("Next Users"))
          ],
        ),
        body: _tumKullanicilar == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : _kullaniciListesiniOlustur());
  }

  getAppUser(AppUser enSonGetirilenUser) async {
    if (!_hasMore) {
      print("GETİRİLECEK ELEMAN KALMADI");
      return;
    }

    if (_isLoading) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    QuerySnapshot _querySnapshot;
    if (enSonGetirilenUser == null) {
      print("------------ ilk 10 geliyor.");
      _tumKullanicilar = [];
      _querySnapshot = await FirebaseFirestore.instance
          .collection("users")
          .orderBy("userName")
          .limit(_getirilecekElemanSayisi)
          .get();
    } else {
      print("------------ diğer 10 geliyor.");

      _querySnapshot = await FirebaseFirestore.instance
          .collection("users")
          .orderBy("userName")
          .startAfter([enSonGetirilenUser.userName])
          .limit(_getirilecekElemanSayisi)
          .get();
    }

    if (_querySnapshot.docs.length < _getirilecekElemanSayisi) {
      _hasMore = false;
    }

    for (DocumentSnapshot snap in _querySnapshot.docs) {
      AppUser _tekUser = AppUser.fromMap(snap.data());
      _tumKullanicilar.add(_tekUser);
      print("------------ tek user " + _tekUser.email.toString());
    }

    _enSonGetirilenUser = _tumKullanicilar.last;
    print("------------- en son gelen user " +
        _enSonGetirilenUser.email.toString());

    setState(() {
      _isLoading = false;
    });
  }

  _kullaniciListesiniOlustur() {
    return ListView.builder(
      itemBuilder: (context, index) {
        if (index == _tumKullanicilar.length) {
          print("**************** yeni elemanlar bekliyor");
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
