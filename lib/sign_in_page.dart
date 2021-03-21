import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'common_widgets/social_login_button.dart';

class SignInPage extends StatelessWidget {
  final Function(User) onSingIn;

  const SignInPage({Key key, @required this.onSingIn}) : super(key: key);

  void _misafirGirisi() async {
    UserCredential userCredential =
        await FirebaseAuth.instance.signInAnonymously();
    onSingIn(userCredential.user);
    print("Oturum açan user id : " + userCredential.user.uid.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Lovers"),
        elevation: 0,
      ),
      backgroundColor: Colors.grey.shade200,
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Oturum Açınız !",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 32,
              ),
            ),
            SocialLoginButton(
              buttonText: "Gmail ile giriş yap",
              textColor: Colors.black87,
              buttonColor: Colors.white,
              buttonIcon: Image.asset("images/google-logo.png"),
              onPressed: () {},
            ),
            SocialLoginButton(
              buttonText: "Facebook ile giriş yap",
              buttonColor: Color(0xFF334D92),
              buttonIcon: Image.asset("images/facebook-logo.png"),
              radius: 16,
              onPressed: () {},
            ),
            SocialLoginButton(
              buttonText: "Email ve şifre ile giriş yap",
              buttonIcon: Icon(
                Icons.email,
                size: 32,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
            SocialLoginButton(
              buttonText: "Misafir Girişi",
              onPressed: _misafirGirisi,
              buttonColor: Colors.teal,
              buttonIcon: Icon(Icons.supervised_user_circle),
            ),
          ],
        ),
      ),
    );
  }
}
