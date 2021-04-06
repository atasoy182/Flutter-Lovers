import 'package:cloud_firestore_platform_interface/src/timestamp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lovers/model/app_user_model.dart';
import 'package:flutter_lovers/model/mesaj_model.dart';
import 'package:flutter_lovers/viewmodel/user_model.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class KonusmaPage extends StatefulWidget {
  final AppUser currentUser;
  final AppUser sohbetEdilenUser;

  KonusmaPage({this.currentUser, this.sohbetEdilenUser});

  @override
  _KonusmaPageState createState() => _KonusmaPageState();
}

class _KonusmaPageState extends State<KonusmaPage> {
  var _messageController = TextEditingController();
  var _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    AppUser _currentUser = widget.currentUser;
    AppUser _sohbetEdilenUser = widget.sohbetEdilenUser;

    final _userModel = Provider.of<UserModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Sohbet"),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
                child: StreamBuilder<List<Mesaj>>(
              stream: _userModel.getMessages(
                  _currentUser.userID, _sohbetEdilenUser.userID),
              builder: (context, streamMesajlarListesi) {
                if (!streamMesajlarListesi.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                var tumMesajlar = streamMesajlarListesi.data;
                return ListView.builder(
                  reverse: true,
                  controller: _scrollController,
                  itemBuilder: (context, index) {
                    return _konusmaBalonuOlustur(tumMesajlar[index]);
                  },
                  itemCount: tumMesajlar.length,
                );
              },
            )),
            Container(
              padding: EdgeInsets.only(bottom: 8, left: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      cursorColor: Colors.blueGrey,
                      style: TextStyle(fontSize: 16.0, color: Colors.black),
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          hintText: "Mesajınızı Yazın",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: BorderSide.none)),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    child: FloatingActionButton(
                      elevation: 1,
                      backgroundColor: Colors.blue,
                      child: Icon(
                        Icons.send,
                        size: 30,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        if (_messageController.text.trim().length > 0) {
                          Mesaj _kaydedilecekMesaj = Mesaj(
                            kimden: _currentUser.userID,
                            kime: _sohbetEdilenUser.userID,
                            bendenMi: true,
                            mesaj: _messageController.text,
                          );
                          var sonuc =
                              await _userModel.saveMessage(_kaydedilecekMesaj);
                          if (sonuc) {
                            _messageController.clear();
                            _scrollController.animateTo(0.0,
                                duration: const Duration(milliseconds: 10),
                                curve: Curves.easeOut);
                          }
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _konusmaBalonuOlustur(Mesaj satirdakiMesaj) {
    Color _gelenMesajRenk = Colors.blue;
    Color _gidenMesajRenk = Theme.of(context).primaryColor;
    var _saatDakikaDegeri = "";

    try {
      _saatDakikaDegeri = _saatDakikaGoster(satirdakiMesaj.date);
    } catch (e) {
      print("HATA " + e.toString());
    }

    var _benimMesajimMi = satirdakiMesaj.bendenMi;

    if (_benimMesajimMi) {
      return Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: _gidenMesajRenk),
                    child: Text(
                      satirdakiMesaj.mesaj,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Text(_saatDakikaDegeri),
              ],
            )
          ],
        ),
      );
    } else {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage:
                      NetworkImage(widget.sohbetEdilenUser.profileURL),
                ),
                Flexible(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: _gelenMesajRenk),
                    child: Text(satirdakiMesaj.mesaj),
                  ),
                ),
                Text(_saatDakikaDegeri),
              ],
            ),
          )
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      );
    }
  }

  String _saatDakikaGoster(Timestamp date) {
    var _formatter = DateFormat.Hm();
    var _formatlanmisTarih = _formatter.format(date.toDate());
    return _formatlanmisTarih;
  }
}
