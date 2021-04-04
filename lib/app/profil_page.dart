import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_lovers/common_widgets/platform_duyarli_alert_dialog.dart';
import 'package:flutter_lovers/common_widgets/social_login_button.dart';
import 'package:flutter_lovers/viewmodel/user_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfilPage extends StatefulWidget {
  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  TextEditingController _controllerUserName;
  File _yeniImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _controllerUserName = TextEditingController();
  }

  @override
  void dispose() {
    _controllerUserName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    _controllerUserName.text = _userModel.user.userName;

    print(_userModel.toString());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profil",
        ),
        actions: [
          FlatButton(
              onPressed: () => _cikisOnayiIste(context),
              child: Text(
                "Çıkış Yap",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
            child: Column(
          children: [
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Container(
                          height: 160,
                          child: Column(
                            children: [
                              ListTile(
                                leading: Icon(Icons.camera),
                                title: Text("Kameradan Çek"),
                                onTap: () {
                                  _yeniFotoEkle(ImageSource.camera);
                                },
                              ),
                              ListTile(
                                leading: Icon(Icons.image),
                                title: Text("Galeriden Seç"),
                                onTap: () {
                                  _yeniFotoEkle(ImageSource.gallery);
                                },
                              ),
                            ],
                          ),
                        );
                      });
                },
                child: CircleAvatar(
                  radius: 75,
                  backgroundImage: _yeniImage == null
                      ? NetworkImage(_userModel.user.profileURL)
                      : FileImage(_yeniImage),
                  backgroundColor: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                initialValue: _userModel.user.email,
                readOnly: true,
                decoration: InputDecoration(
                    labelText: "E mailiniz ",
                    hintText: "Email",
                    border: OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _controllerUserName,
                decoration: InputDecoration(
                    labelText: "User Name",
                    hintText: "User Name",
                    border: OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SocialLoginButton(
                  buttonText: "Değişiklikleri Kaydet",
                  onPressed: () {
                    _userNameGuncelle(context);
                    _profilFotoGuncelle(context);
                  }),
            ),
          ],
        )),
      ),
    );
  }

  Future<void> _cikisYap(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    bool result = await _userModel.signOut();
    return result;
  }

  Future _cikisOnayiIste(BuildContext context) async {
    final sonuc = await PlatformDuyarliAlertDialog(
      baslik: "Emin misiniz ?",
      icerik: "Çıkmak istediğinizden emin misiniz ?",
      anaButtonYazisi: "Evet",
      iptalButtonYazisi: "Vazgeç",
    ).goster(context);

    if (sonuc == true) {
      _cikisYap(context);
    }
  }

  void _userNameGuncelle(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    if (_userModel.user.userName != _controllerUserName.text) {
      var updateResult = await _userModel.updateUserName(
          _userModel.user.userID, _controllerUserName.text);
      if (updateResult) {
        PlatformDuyarliAlertDialog(
          baslik: "Başarılı",
          icerik: "Username güncellendi",
          anaButtonYazisi: "Ok",
        ).goster(context);
      } else {
        _controllerUserName.text = _userModel.user.userName;
        PlatformDuyarliAlertDialog(
          baslik: "Hata",
          icerik: "Username kullanılıyor, lütfen farklı bir username giriniz !",
          anaButtonYazisi: "Ok",
        ).goster(context);
      }
    }
  }

  void _yeniFotoEkle(ImageSource source) async {
    PickedFile _pickedFoto = await _picker.getImage(source: source);

    setState(() {
      _yeniImage = File(_pickedFoto.path);
      Navigator.of(context).pop();
    });
  }

  void _profilFotoGuncelle(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    if (_yeniImage != null) {
      var url = await _userModel.uploadFile(
          _userModel.user.userID, "profil_foto", _yeniImage);

      print("gelen URL:" + url.toString());
    }
  }
}
