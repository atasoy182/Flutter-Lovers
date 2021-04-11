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

    if (_enSonGetirilenUser == null) {
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
    if (_tumKullanicilar.length > 1) {
      return RefreshIndicator(
        onRefresh: _kullaniciListesiRefresh,
        child: ListView.builder(
          itemBuilder: (context, index) {
            if (index == _tumKullanicilar.length) {
              return _yeniElemanlarYukleniyor();
            }

            return appUserListeElemaniOlustur(index);
          },
          itemCount: _tumKullanicilar.length + 1,
          controller: _scrollController,
        ),
      );
    } else {
      return RefreshIndicator(
        onRefresh: _kullaniciListesiRefresh,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.supervised_user_circle,
                      color: Theme.of(context).primaryColor, size: 80),
                  Text(
                    "Henüz Kullanıcı Yok",
                    style: TextStyle(fontSize: 36),
                  ),
                ],
              ),
            ),
            height: MediaQuery.of(context).size.height - 150,
          ),
        ),
      );
    }

    // wait
  }

  Widget appUserListeElemaniOlustur(int index) {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    var satirdakiAppUser = _tumKullanicilar[index];

    if (satirdakiAppUser.userID == _userModel.user.userID) {
      return Container();
    }

    return GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
            builder: (context) => KonusmaPage(
                  currentUser: _userModel.user,
                  sohbetEdilenUser: satirdakiAppUser,
                )));
      },
      child: Card(
        child: ListTile(
          title: Text(satirdakiAppUser.userName),
          subtitle: Text(satirdakiAppUser.email),
          leading: CircleAvatar(
            backgroundColor: Colors.grey.withAlpha(40),
            backgroundImage: NetworkImage(satirdakiAppUser.profileURL),
          ),
        ),
      ),
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

  Future<Null> _kullaniciListesiRefresh() async {
    _enSonGetirilenUser = null;
    _hasMore = true;
    getAppUser();
  }
}
