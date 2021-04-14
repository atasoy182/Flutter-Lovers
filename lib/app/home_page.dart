import 'package:flutter/material.dart';
import 'package:flutter_lovers/app/konusmalarim_page.dart';
import 'package:flutter_lovers/app/kullanicilar_page.dart';
import 'package:flutter_lovers/app/my_custom_bottom_navi.dart';
import 'package:flutter_lovers/app/profil_page.dart';
import 'package:flutter_lovers/app/tab_items.dart';
import 'package:flutter_lovers/viewmodel/all_users_view_model.dart';
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

  Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.Kullanicilar: GlobalKey<NavigatorState>(),
    TabItem.Konusmalarim: GlobalKey<NavigatorState>(),
    TabItem.Profil: GlobalKey<NavigatorState>(),
  };

  Map<TabItem, Widget> tumSayfalar() {
    return {
      TabItem.Kullanicilar: ChangeNotifierProvider(
        create: (context) => AllUserViewModel(),
        child: KullanicilarPage(),
      ),
      TabItem.Konusmalarim: KonusmalarimPage(),
      TabItem.Profil: ProfilPage(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          !await navigatorKeys[_currentTab].currentState.maybePop(),
      child: MyCustomBottomNavigation(
        currentTab: _currentTab,
        navigatorKeys: navigatorKeys,
        onSelectedTab: (secilenTab) {
          if (secilenTab == _currentTab) {
            try {
              navigatorKeys[secilenTab]
                  .currentState
                  .popUntil((route) => route.isFirst);
            } catch (e) {
              print("NAVIGATOR HATASI" + e.toString());
            }
          } else {
            setState(() {
              _currentTab = secilenTab;
            });
          }
        },
        sayfaOlusturucu: tumSayfalar(),
      ),
    );
  }
}
