import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lovers/app/tab_items.dart';

class MyCustomBottomNavigation extends StatelessWidget {
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectedTab;
  final Map<TabItem, Widget> sayfaOlusturucu;

  const MyCustomBottomNavigation(
      {Key key,
      @required this.currentTab,
      @required this.onSelectedTab,
      @required this.sayfaOlusturucu})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          items: [
            _navItemOlustur(TabItem.Kullanicilar),
            _navItemOlustur(TabItem.Profil),
          ],
          onTap: (index) => onSelectedTab(TabItem.values[index]),
        ),
        tabBuilder: (context, index) {
          return CupertinoTabView(builder: (context) {
            final gosterilecekItem = TabItem.values[index];
            return sayfaOlusturucu[gosterilecekItem];
          });
        });
  }

  BottomNavigationBarItem _navItemOlustur(TabItem tabItem) {
    final olusturalacakTab = TabItemData.tumTablar[tabItem];
    return BottomNavigationBarItem(
        icon: Icon(olusturalacakTab.icon), label: olusturalacakTab.title);
  }
}
