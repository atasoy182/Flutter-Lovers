import 'package:cloud_firestore_platform_interface/src/timestamp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lovers/model/app_user_model.dart';
import 'package:flutter_lovers/model/mesaj_model.dart';
import 'package:flutter_lovers/viewmodel/chat_view_model.dart';
import 'package:flutter_lovers/viewmodel/user_model.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class KonusmaPage extends StatefulWidget {
  @override
  _KonusmaPageState createState() => _KonusmaPageState();
}

class _KonusmaPageState extends State<KonusmaPage> {
  var _messageController = TextEditingController();
  var _scrollController = ScrollController();
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    final _chatModel = Provider.of<ChatViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Sohbet"),
      ),
      body: Center(
        child: _chatModel.state == ChatViewState.Busy
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  _buildMesajListesi(),
                  _buildYeniMesajGir(),
                ],
              ),
      ),
    );
  }

  Widget _buildMesajListesi() {
    return Consumer<ChatViewModel>(
      builder: (context, chatModel, child) {
        return Expanded(
          child: ListView.builder(
            reverse: true,
            controller: _scrollController,
            itemBuilder: (context, index) {
              if (chatModel.hasMoreLoading &&
                  chatModel.mesajlarListesi.length == index) {
                return _yeniElemanlarYukleniyor();
              } else {
                return _konusmaBalonuOlustur(chatModel.mesajlarListesi[index]);
              }
            },
            itemCount: chatModel.hasMoreLoading
                ? chatModel.mesajlarListesi.length + 1
                : chatModel.mesajlarListesi.length,
          ),
        );
      },
    );
  }

  Widget _buildYeniMesajGir() {
    final _chatModel = Provider.of<ChatViewModel>(context);

    return Container(
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
                    kimden: _chatModel.currentUser.userID,
                    kime: _chatModel.sohbetEdilenUser.userID,
                    bendenMi: true,
                    mesaj: _messageController.text,
                  );
                  _messageController.clear();
                  var sonuc = await _chatModel.saveMessage(_kaydedilecekMesaj);
                  if (sonuc) {
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
    );
  }

  Widget _konusmaBalonuOlustur(Mesaj satirdakiMesaj) {
    Color _gelenMesajRenk = Colors.blue;
    Color _gidenMesajRenk = Theme.of(context).primaryColor;
    var _saatDakikaDegeri = "";
    final _chatModel = Provider.of<ChatViewModel>(context);

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
                  backgroundColor: Colors.grey.withAlpha(40),
                  backgroundImage:
                      NetworkImage(_chatModel.sohbetEdilenUser.profileURL),
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

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      eskiMesajlariGetir();
    }
  }

  void eskiMesajlariGetir() async {
    print("Listenin en üstündeyiz !!!!!! eski mesajları getir");
    final _chatModel = Provider.of<ChatViewModel>(context, listen: false);

    if (!_isLoading) {
      _isLoading = true;
      final _tumKullanicilarUserModel = await _chatModel.dahaFazlaMesajGetir();
      _isLoading = false;
    }
  }

  _yeniElemanlarYukleniyor() {
    return Padding(
        padding: EdgeInsets.all(8),
        child: Center(child: CircularProgressIndicator()));
  }
}
