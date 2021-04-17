import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lovers/app/konusma_page.dart';
import 'package:flutter_lovers/viewmodel/all_users_view_model.dart';
import 'package:flutter_lovers/viewmodel/chat_view_model.dart';
import 'package:flutter_lovers/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

class KullanicilarPage extends StatefulWidget {
  @override
  _KullanicilarPageState createState() => _KullanicilarPageState();
}

class _KullanicilarPageState extends State<KullanicilarPage> {
  bool _isLoading = false;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.offset >=
              _scrollController.position.minScrollExtent &&
          !_scrollController.position.outOfRange) {
        dahaFazlaKullaniciGetir();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kullanıcılar"),
      ),
      body: Consumer<AllUserViewModel>(
        builder: (context, model, child) {
          if (model.state == AllUserViewState.Busy) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (model.state == AllUserViewState.Loaded) {
            return RefreshIndicator(
              onRefresh: model.onRefresh,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  if (model.kullanicilarListesi.length == 1) {
                    return kullaniciYokUi();
                  }

                  if (model.hasMoreLoading &&
                      index == model.kullanicilarListesi.length) {
                    return _yeniElemanlarYukleniyor();
                  } else {
                    return appUserListeElemaniOlustur(index);
                  }
                },
                itemCount: model.hasMoreLoading
                    ? model.kullanicilarListesi.length + 1
                    : model.kullanicilarListesi.length,
                controller: _scrollController,
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget appUserListeElemaniOlustur(int index) {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    final _tumKullanicilarUserModel =
        Provider.of<AllUserViewModel>(context, listen: false);
    var satirdakiAppUser = _tumKullanicilarUserModel.kullanicilarListesi[index];

    if (satirdakiAppUser.userID == _userModel.user.userID) {
      return Container();
    }

    return GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
                  create: (context) => ChatViewModel(
                      currentUser: _userModel.user,
                      sohbetEdilenUser: satirdakiAppUser),
                  child: KonusmaPage(),
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
        child: Center(child: CircularProgressIndicator()));
  }

  void dahaFazlaKullaniciGetir() async {
    if (!_isLoading) {
      _isLoading = true;
      final _tumKullanicilarUserModel =
          Provider.of<AllUserViewModel>(context, listen: false);
      await _tumKullanicilarUserModel.dahaFazlaKullaniciGetir();
      _isLoading = false;
    }
  }

  Widget kullaniciYokUi() {
    final _tumKullanicilarUserModel =
        Provider.of<AllUserViewModel>(context, listen: false);
    return RefreshIndicator(
      onRefresh: _tumKullanicilarUserModel.onRefresh,
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
}
