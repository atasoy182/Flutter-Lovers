import 'package:flutter/material.dart';
import 'package:flutter_lovers/model/app_user_model.dart';
import 'package:flutter_lovers/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

class KullanicilarPage extends StatelessWidget {
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
              return ListView.builder(
                  itemCount: tumKullanicilar.length,
                  itemBuilder: (context, index) {
                    var satirdakiUser = sonuc.data[index];
                    if (satirdakiUser.userID != _userModel.user.userID) {
                      return ListTile(
                        title: Text(satirdakiUser.userName),
                        subtitle: Text(satirdakiUser.email),
                        leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage(satirdakiUser.profileURL),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  });
            } else {
              return Center(
                child: Text("Kayıtlı kullanıcı Yok"),
              );
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
