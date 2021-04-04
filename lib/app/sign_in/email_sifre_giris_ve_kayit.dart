import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lovers/common_widgets/platform_duyarli_alert_dialog.dart';
import 'package:flutter_lovers/common_widgets/social_login_button.dart';
import 'package:flutter_lovers/hatalar.dart';
import 'package:flutter_lovers/model/app_user_model.dart';
import 'package:flutter_lovers/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

enum FormType { Register, LogIn }

class EmailveSifreLoginPage extends StatefulWidget {
  @override
  _EmailveSifreLoginPageState createState() => _EmailveSifreLoginPageState();
}

class _EmailveSifreLoginPageState extends State<EmailveSifreLoginPage> {
  String _email, _sifre;
  String _buttonText, _linkText;
  var _formType = FormType.LogIn;

  final _formKey = GlobalKey<FormState>();

  void _formSubmit() async {
    _formKey.currentState.save();
    print("email:" + _email + " Şifre:" + _sifre);

    final _userModel = Provider.of<UserModel>(context, listen: false);

    if (_formType == FormType.LogIn) {
      try {
        AppUser _girisYapanUser =
            await _userModel.signInEmailAndPassword(_email, _sifre);
        if (_girisYapanUser != null)
          print("Giriş yapan user id : " + _girisYapanUser.userID.toString());
      } on FirebaseAuthException catch (e) {
        print(
            "---------------------- widget oturum acma hatasi:" + e.toString());
      }
    } else {
      try {
        AppUser _olusturulanUser =
            await _userModel.createUserWithEmailAndPassword(_email, _sifre);
        if (_olusturulanUser != null)
          print("Giriş yapan user id : " + _olusturulanUser.userID.toString());
      } on FirebaseAuthException catch (e) {
        PlatformDuyarliAlertDialog(
          baslik: "Hata !",
          icerik: Hatalar.goster(e.code.toString()),
          anaButtonYazisi: "Ok",
        ).goster(context);
      }
    }
  }

  void _degistir() {
    setState(() {
      _formType =
          _formType == FormType.LogIn ? FormType.Register : FormType.LogIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    _buttonText = _formType == FormType.LogIn ? "Giriş Yap" : "Kayıt Ol";
    _linkText = _formType == FormType.LogIn
        ? "Hesabınız yok mu ? Kayıt Olun"
        : "Hesabınız var mı ? Giriş Yapın";
    final _userModel = Provider.of<UserModel>(context);

    if (_userModel.user != null) {
      Future.delayed(Duration(microseconds: 10), () {
        Navigator.of(context).pop();
      });
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("Giriş / Kayıt"),
        ),
        body: Center(
          child: _userModel.state == ViewState.Idle
              ? SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            initialValue: "james@metallica.com",
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.email_outlined),
                              hintText: "E mail",
                              labelText: "E mail",
                              errorText: _userModel.mailHataMesaji != null
                                  ? _userModel.mailHataMesaji
                                  : null,
                              border: OutlineInputBorder(),
                            ),
                            onSaved: (String girilenEmail) {
                              _email = girilenEmail;
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            obscureText: true,
                            initialValue: "123456",
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.email_outlined),
                              hintText: "Şifre",
                              labelText: "Şifre",
                              errorText: _userModel.sifreHataMesaji != null
                                  ? _userModel.sifreHataMesaji
                                  : null,
                              border: OutlineInputBorder(),
                            ),
                            onSaved: (String girilenSifre) {
                              _sifre = girilenSifre;
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          SocialLoginButton(
                            buttonText: _buttonText,
                            onPressed: () => _formSubmit(),
                            buttonColor: Theme.of(context).primaryColor,
                            radius: 10,
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          FlatButton(
                              onPressed: () => _degistir(),
                              child: Text(_linkText))
                        ],
                      ),
                    ),
                  ),
                )
              : CircularProgressIndicator(),
        ));
  }
}
