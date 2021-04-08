import 'package:flutter/material.dart';
import 'package:flutter_lovers/model/konusma_model.dart';
import 'package:flutter_lovers/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

class KonusmalarimPage extends StatefulWidget {
  @override
  _KonusmalarimPageState createState() => _KonusmalarimPageState();
}

class _KonusmalarimPageState extends State<KonusmalarimPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // demo için kullanıldı
    //_konusmalarimiGetir();

    final _userModel = Provider.of<UserModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Konuşmalarım"),
      ),
      body: FutureBuilder<List<Konusma>>(
        future: _userModel.getAllConversations(_userModel.user.userID),
        builder: (context, konusmaListesi) {
          if (!konusmaListesi.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            var tumKonusmalar = konusmaListesi.data;
            return ListView.builder(
              itemBuilder: (context, index) {
                var satirdakiKonusma = tumKonusmalar[index];
                return ListTile(
                  title: Text(satirdakiKonusma.son_yollanan_mesaj),
                  subtitle: Text(satirdakiKonusma.konusulanUserName),
                  leading: CircleAvatar(
                    backgroundImage:
                        NetworkImage(satirdakiKonusma.konusulanUserProfilURL),
                  ),
                );
              },
              itemCount: tumKonusmalar.length,
            );
          }
        },
      ),
    );
  }

//  void _konusmalarimiGetir() async {
//    final _userModel = Provider.of<UserModel>(context);
//
//    var konusmalarim = await FirebaseFirestore.instance
//        .collection("konusmalar")
//        .where("konusma_sahibi", isEqualTo: _userModel.user.userID)
//        .orderBy("olusturulma_tarihi", descending: true)
//        .get();
//    for (var konusma in konusmalarim.docs) {
//      print("KONUSMA: " + konusma.data().toString());
//    }
//  }
}
