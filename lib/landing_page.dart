import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lovers/home_page.dart';
import 'package:flutter_lovers/sign_in_page.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  User _user;

  Future<void> _checkUser() async {
    _user = FirebaseAuth.instance.currentUser;
  }

  void _updateUser(User user) {
    setState(() {
      _user = user;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkUser();
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return SignInPage(
        onSingIn: (User) => _updateUser(User),
      );
    } else {
      return HomePage(
        user: _user,
        onSignOut: () => _updateUser(null),
      );
    }
  }
}
