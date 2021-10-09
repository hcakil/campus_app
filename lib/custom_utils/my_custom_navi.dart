
import 'package:campusapp/custom_utils/tab_items.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyCustomBottomNavigator extends StatefulWidget {
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectedTab;
  final Map<TabItem, Widget> sayfaOlusturucu;
  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys;

  const MyCustomBottomNavigator(
      {Key key,
        @required this.currentTab,
        @required this.onSelectedTab,
        @required this.navigatorKeys,
        @required this.sayfaOlusturucu})
      : super(key: key);

  @override
  _MyCustomBottomNavigatorState createState() =>
      _MyCustomBottomNavigatorState();
}

class _MyCustomBottomNavigatorState extends State<MyCustomBottomNavigator> {
//  NativeAdmob nativeAdmob;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    // NativeAdmobController _controller = AdMobIslemleri.admobInitialize();

    // nativeAdmob = AdMobIslemleri.buildNativeAdMob(_controller);
  }

  @override
  void dispose() {
    // TODO: implement dispose"
    //  nativeAdmob.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
        child: CupertinoTabScaffold(
          tabBar: CupertinoTabBar(
            items: [
              _navItemOlustur(TabItem.Oneri),
              _navItemOlustur(TabItem.Kategoriler),
              _navItemOlustur(TabItem.Profil),
            ],
            onTap: (index) => widget.onSelectedTab(TabItem.values[index]),
          ),
          tabBuilder: (context, index) {
            final gosterilecekItem = TabItem.values[index];

            return CupertinoTabView(
              navigatorKey: widget.navigatorKeys[gosterilecekItem],
              builder: (context) {
                return widget.sayfaOlusturucu[gosterilecekItem];
              },
            );
          },
        ),
      ),
      /* Container(
        margin: EdgeInsets.only(bottom: 20.0),
        height: 40.0,
        child: NativeAdmob(
          // Your ad unit id
          adUnitID: banner1Canli,
          controller: _nativeAdController,
          type: NativeAdmobType.banner,

          // Don't show loading widget when in loading state
          loading: Center(child: CircularProgressIndicator()),
        ), /* nativeAdmob,*/
      ),*/
    ]);
  }

  BottomNavigationBarItem _navItemOlustur(TabItem tabItem) {
    final olusturulacakTab = TabItemData.tumTablar[tabItem];

    return BottomNavigationBarItem(
        icon: Icon(olusturulacakTab.icon), label: (olusturulacakTab.title));
  }
}
