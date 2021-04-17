import 'package:flutter/material.dart';
import 'package:flutter_lovers/app/konusma_page.dart';
import 'package:flutter_lovers/model/app_user_model.dart';
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
            if (tumKonusmalar.length > 0) {
              return RefreshIndicator(
                onRefresh: _konusmalarimiYenile,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    var satirdakiKonusma = tumKonusmalar[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true)
                            .push(MaterialPageRoute(
                                builder: (context) => KonusmaPage(
                                    /*
                                      currentUser: _userModel.user,
                                      sohbetEdilenUser: AppUser.IdveResim(
                                          userID:
                                              satirdakiKonusma.kimle_konusuyor,
                                          profileURL: satirdakiKonusma
                                              .konusulanUserProfilURL),*/
                                    )));
                      },
                      child: ListTile(
                        title: Text(satirdakiKonusma.son_yollanan_mesaj),
                        subtitle: Text(satirdakiKonusma.konusulanUserName +
                            "  (" +
                            satirdakiKonusma.aradakiFark.toString() +
                            ")"),
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey.withAlpha(40),
                          backgroundImage: NetworkImage(
                              satirdakiKonusma.konusulanUserProfilURL),
                        ),
                      ),
                    );
                  },
                  itemCount: tumKonusmalar.length,
                ),
              );
            } else {
              return RefreshIndicator(
                onRefresh: _konusmalarimiYenile,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Container(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.chat,
                              color: Theme.of(context).primaryColor, size: 80),
                          Text(
                            "Henüz Konuşma Yapılmamış",
                            textAlign: TextAlign.center,
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

  Future<Null> _konusmalarimiYenile() async {
    setState(() {});
    await Future.delayed(Duration(seconds: 1));
    return null;
  }
}
