import 'package:campusapp/custom_utils/platform_duyarli_alert_dialog.dart';
import 'package:campusapp/view_model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  Future _cikisIcinOnayIste(BuildContext context) async {
    final sonuc = await PlatformDuyarliAlertDialog(
        baslik: "Çıkış",
        icerik: "Çıkış Yapmak İstediğinizden Emin Misiniz?",
        anaButonYazisi: "Evet",
        iptalButonYazisi: "Vazgeç")
        .goster(context);

    if (sonuc == true) {
      _cikisYap(context);
    }
  }

  Future<bool> _cikisYap(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    bool sonuc = await _userModel.signOut();

    return sonuc;
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        automaticallyImplyLeading: false,
        backgroundColor:  Colors.purple.shade600,
        actions: <Widget>[
          FlatButton(
              onPressed: () => _cikisIcinOnayIste(context),
              child: Icon(
                Icons.logout,
                color: Colors.white,
                size: 27,
              ))
        ],
        title: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Text(
                  "Profil",
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Lobster",
                    color: Colors.white,
                    letterSpacing: 3,
                  ),
                ),
              ],
            ),
          ],
        ),),
      body: Container(child: Center(child: Text("profil page"),),),
    );
  }
}
