import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final User user;
  final Function onSignOut;

  const HomePage({Key key, this.user, @required this.onSignOut})
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
        child: Text("Hoş Geldiniz ${user.uid}"),
      ),
    );
  }

  Future<void> _cikisYap() async {
    await FirebaseAuth.instance.signOut();
    onSignOut();
  }
}
