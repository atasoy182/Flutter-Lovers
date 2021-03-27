import 'package:flutter/material.dart';
import 'package:flutter_lovers/home_page.dart';
import 'package:flutter_lovers/model/app_user_model.dart';
import 'package:flutter_lovers/services/auth_base.dart';
import 'package:flutter_lovers/services/firebase_auth_service.dart';
import 'package:flutter_lovers/sign_in_page.dart';

import 'locator.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  AppUser _user;
  AuthBase authService = locator<FirebaseAuthService>();

  Future<void> _checkUser() async {
    _user = await authService.getCurrentUser();
  }

  void _updateUser(AppUser user) {
    setState(() {
      _user = user;
    });
  }

  @override
  void initState() {
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
        onSignOut: () => _updateUser(null),
        user: _user,
      );
    }
  }
}
