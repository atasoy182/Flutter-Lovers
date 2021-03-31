import 'package:flutter/material.dart';
import 'package:flutter_lovers/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

class ProfilPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profil",
        ),
        actions: [
          FlatButton(
              onPressed: () => _cikisYap(context),
              child: Text(
                "Çıkış Yap",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ))
        ],
      ),
      body: Center(
        child: Text("Profil Sayfası"),
      ),
    );
  }

  Future<void> _cikisYap(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    bool result = await _userModel.signOut();
    return result;
  }
}
