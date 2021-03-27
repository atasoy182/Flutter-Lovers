import 'package:flutter/material.dart';
import 'package:flutter_lovers/services/firebase_auth_service.dart';

import 'locator.dart';
import 'model/app_user_model.dart';
import 'services/auth_base.dart';

class HomePage extends StatelessWidget {
  final Function onSignOut;
  AuthBase authService = locator<FirebaseAuthService>();
  final AppUser user;

  HomePage({Key key, @required this.onSignOut, @required this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ana sayfa"),
        actions: [
          FlatButton(
              onPressed: _cikisYap,
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

  Future<void> _cikisYap() async {
    bool result = await authService.signOut();
    onSignOut();
    return result;
  }
}
