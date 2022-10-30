import 'package:campusapp/custom_utils/my_custom_navi.dart';
import 'package:campusapp/custom_utils/tab_items.dart';
import 'package:campusapp/model/user.dart';
import 'package:campusapp/pages/all_clubs_page.dart';
import 'package:campusapp/pages/club_offers_page.dart';
import 'package:campusapp/pages/profil_page.dart';
import 'package:campusapp/view_model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



class HomePage2 extends StatefulWidget {
  final MyUser user;
  HomePage2({Key key, this.user}) : super(key: key);


  @override
  _HomePage2State createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {


  TabItem _currentTab = TabItem.Kategoriler;

  Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.Oneri: GlobalKey<NavigatorState>(),
    TabItem.Profil: GlobalKey<NavigatorState>(),
    TabItem.Kategoriler: GlobalKey<NavigatorState>(),
  };

  Map<TabItem, Widget> tumSayfalar() {
    return {
      TabItem.Kategoriler: ChangeNotifierProvider(
        create: (context) => UserModel(),
        child: AllCategoryPage(),//KullanicilarPage(),AllCategoryPage
      ),
      TabItem.Oneri: CategoryOffersPage(),//KonusmalarimPage(),
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
        onSelectedTab: (secilenTab) async{
          if (secilenTab == _currentTab) {

          print("secilen tab $secilenTab");
         //if(secilenTab == )
          //if(secilenTab == "")
          await Future.delayed(Duration(milliseconds: 500));
            navigatorKeys[secilenTab].currentState.popUntil((route) {
              return route.isFirst;
            }

            );
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
