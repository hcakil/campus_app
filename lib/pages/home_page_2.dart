import 'package:campusapp/custom_utils/my_custom_navi.dart';
import 'package:campusapp/custom_utils/tab_items.dart';
import 'package:campusapp/model/user.dart';
import 'package:campusapp/pages/category_offers_page.dart';
import 'package:campusapp/pages/profil_page.dart';
import 'package:campusapp/view_model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'all_categories_page.dart';

class HomePage2 extends StatefulWidget {
  final MyUser user;
  HomePage2({Key key, this.user}) : super(key: key);


  @override
  _HomePage2State createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {


  TabItem _currentTab = TabItem.Kullanicilar;

  Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.Kullanicilar: GlobalKey<NavigatorState>(),
    TabItem.Profil: GlobalKey<NavigatorState>(),
    TabItem.Konusmalarim: GlobalKey<NavigatorState>(),
  };

  Map<TabItem, Widget> tumSayfalar() {
    return {
      TabItem.Kullanicilar: ChangeNotifierProvider(
        create: (context) => UserModel(),
        child: CategoryOffersPage(),//KullanicilarPage(),
      ),
      TabItem.Konusmalarim: AllCategoryPage(),//KonusmalarimPage(),
      TabItem.Profil: ProfilePage(),////ProfilPage(),
    };
  }
  @override
  Widget build(BuildContext context) {
    return   WillPopScope(
      onWillPop: () async =>
      !await navigatorKeys[_currentTab].currentState.maybePop(),
      child: MyCustomBottomNavigator(
        navigatorKeys: navigatorKeys,
        sayfaOlusturucu: tumSayfalar(),
        currentTab: _currentTab,
        onSelectedTab: (secilenTab) {
          if (secilenTab == _currentTab) {
            navigatorKeys[_currentTab]
                .currentState
                .popUntil((route) => route.isFirst);
          } else {
            setState(() {
              _currentTab = secilenTab;
            });
            print(
              "secilen tab == " + secilenTab.toString(),
            );
          }
        },
      ),
    );



  }
}
