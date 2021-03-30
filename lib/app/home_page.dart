import 'package:flutter/material.dart';
import 'package:flutter_lovers/app/kullanicilar_page.dart';
import 'package:flutter_lovers/app/my_custom_bottom_navi.dart';
import 'package:flutter_lovers/app/profil_page.dart';
import 'package:flutter_lovers/app/tab_items.dart';
import 'package:flutter_lovers/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

import '../model/app_user_model.dart';

class HomePage extends StatefulWidget {
  final AppUser user;

  HomePage({Key key, @required this.user}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.Kullanicilar;
  Map<TabItem, Widget> tumSayfalar() {
    return {
      TabItem.Kullanicilar: KullanicilarPage(),
      TabItem.Profil: ProfilPage(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: MyCustomBottomNavigation(
        currentTab: _currentTab,
        onSelectedTab: (secilenTab) {
          setState(() {
            _currentTab = secilenTab;
          });
        },
        sayfaOlusturucu: tumSayfalar(),
      ),
    );
  }
}
/*
   Future<void> _cikisYap(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    bool result = await _userModel.signOut();
    return result;
  }
 */
