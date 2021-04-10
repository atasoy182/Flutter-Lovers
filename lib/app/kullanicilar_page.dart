import 'package:flutter/foundation.dart';
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
  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserModel>(context);
    _userModel.getAllUser();

    return Scaffold(
      appBar: AppBar(
        title: Text("Kullanıcılar"),
      ),
      body: FutureBuilder<List<AppUser>>(
        future: _userModel.getAllUser(),
        builder: (context, sonuc) {
          if (sonuc.hasData) {
            var tumKullanicilar = sonuc.data;

            if (tumKullanicilar.length - 1 > 0) {
              return RefreshIndicator(
                onRefresh: _kullanicilariyenile,
                child: ListView.builder(
                    itemCount: tumKullanicilar.length,
                    itemBuilder: (context, index) {
                      var satirdakiUser = sonuc.data[index];
                      if (satirdakiUser.userID != _userModel.user.userID) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context, rootNavigator: true)
                                .push(MaterialPageRoute(
                                    builder: (context) => KonusmaPage(
                                          currentUser: _userModel.user,
                                          sohbetEdilenUser: satirdakiUser,
                                        )));
                          },
                          child: ListTile(
                            title: Text(satirdakiUser.userName),
                            subtitle: Text(satirdakiUser.email),
                            leading: CircleAvatar(
                              backgroundColor: Colors.grey.withAlpha(40),
                              backgroundImage:
                                  NetworkImage(satirdakiUser.profileURL),
                            ),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    }),
              );
            } else {
              return RefreshIndicator(
                onRefresh: _kullanicilariyenile,
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
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Future<Null> _kullanicilariyenile() async {
    setState(() {});
    Future.delayed(Duration(seconds: 1));
    return null;
  }
}
