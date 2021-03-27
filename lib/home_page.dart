import 'package:flutter/material.dart';
import 'package:flutter_lovers/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

import 'model/app_user_model.dart';

class HomePage extends StatelessWidget {
  final AppUser user;

  HomePage({Key key, @required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ana sayfa"),
        actions: [
          FlatButton(
              onPressed: () => _cikisYap(context),
              child: Text(
                "Çıkış Yap",
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: Center(
        child: Text("Hoş Geldiniz ${user.userID}"),
      ),
    );
  }

  Future<void> _cikisYap(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    bool result = await _userModel.signOut();
    return result;
  }
}
