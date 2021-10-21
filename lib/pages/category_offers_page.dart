import 'package:campusapp/custom_utils/fade_animation.dart';
import 'package:campusapp/custom_utils/platform_duyarli_alert_dialog.dart';
import 'package:campusapp/model/club.dart';
import 'package:campusapp/pages/add_activity_page.dart';
import 'package:campusapp/pages/add_category_page.dart';
import 'package:campusapp/pages/waiting_activity_request_page.dart';
import 'package:campusapp/pages/waiting_club_request_page.dart';
import 'package:campusapp/view_model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryOffersPage extends StatefulWidget {
  @override
  _CategoryOffersPageState createState() => _CategoryOffersPageState();
}

class _CategoryOffersPageState extends State<CategoryOffersPage> {
  //GlobalKey<ScaffoldState> _scaffoldKey;// = GlobalKey<ScaffoldState>();
  var _scaffoldKey = GlobalKey<ScaffoldState>();


  String dialogString="İlk Katılma İsteğiniz Alınmıştır";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //_scaffoldKey = GlobalKey<ScaffoldState>();
  }

  Future<String> _submitRequest(
      String clubId,
      String userId,
      String clubName,
      String userName,
      String userProfileUrl,
      BuildContext dialogContext) async {
    // oAnkiKlup.name,_userModel.user.userName,_userModel.user.profilURL

    print("id of a rewuested club -> $clubId  // user id --> $userId");
    if (userId != null) {
      final _userModel = Provider.of<UserModel>(context, listen: false);
      try {
        var sonuc = await _userModel.addRequestForClub(
            clubId, userId, clubName, userName, userProfileUrl);
        //var url = await _userModel.uploadCategoryFile(_clubId, "club_photo", _clubPhoto);
        //print("sonuc --> $sonuc");
        if (sonuc.contains("Waiting")) {
          dialogString =
              "İsteğiniz Onay İçin Beklemektedir Lütfen Daha Sonra Tekrar Deneyiniz !!";
        } else if (sonuc.contains("Approved")) {
          dialogString =
              "İsteğiniz Onaylanmıştır Klüp Sayfasına Gitmek İstiyor musunuz?";
        }
        return sonuc;
      } catch (e) {
        print("-->HATA $e");

      }
    }
  }

  @override
  Widget build(BuildContext context) {
    UserModel _userModel = Provider.of<UserModel>(context);


    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
            toolbarHeight: 100,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.purple.shade600,
            title: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Campus App",
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
            ),
          ),
        body: FutureBuilder<List<Club>>(
          future: _userModel.getOfferedClubs(_userModel.user.interest),
          builder: (context, klubListesi) {
            if (!klubListesi.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              var tumKlupler = klubListesi.data;

              if (tumKlupler.length > 0) {
                return RefreshIndicator(
                  onRefresh: _kluplerListesiniYenile,
                  child: ListView.builder(
                    itemCount: tumKlupler.length,
                    itemBuilder: (context, index) {
                      var oAnkiKlup = tumKlupler[index];

                      return GestureDetector(
                        onTap: () {
                          print("category name");
                          print(oAnkiKlup.name);
                          /* Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                            builder: (context) => ChangeNotifierProvider(
                              create: (context) => ChatViewModel(
                                currentUser: _userModel.user,
                                sohbetEdilenKisi: MyUser.idVeResim(
                                    userID: oAnkiUser.kimle_konusuyor,
                                    profilURL:
                                    oAnkiUser.konusulanUserProfilURL),
                              ),
                              child: SohbetPage(),
                            ),
                          ),
                        );*/
                        },
                        child: FadeAnimation(
                          2,
                          Container(
                            width: double.infinity,
                            height: 85,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.blueAccent, width: 1),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.blueAccent,
                                      blurRadius: 10,
                                      offset: Offset(1, 1)),
                                ],
                                color: Colors.white,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(20))),
                            child: Container(
                              child: ListTile(
                                title: Text(oAnkiKlup.name,
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 2,
                                        fontFamily: "OpenSans")),
                                subtitle: Text(
                                  oAnkiKlup.subtitle,
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                                leading: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  backgroundImage:
                                      NetworkImage(oAnkiKlup.photoUrl),
                                  radius: 30,
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        print("Katılma İsteği geldi");
                                        var result = await _submitRequest(
                                            oAnkiKlup.id,
                                            _userModel.user.userID,
                                            oAnkiKlup.name,
                                            _userModel.user.userName,
                                            _userModel.user.profilURL,
                                            context);

                                        if (result != null) {
                                          //  await Future.delayed(Duration(seconds: 1));
                                          print(result);

                                          PlatformDuyarliAlertDialog(
                                            baslik: "Katılma İsteği",
                                            icerik: dialogString,
                                            anaButonYazisi: "Tamam",
                                            // iptalButonYazisi: "Vazgeç"
                                          ).goster(context);

                                          /* _scaffoldKey.currentState.showSnackBar(
                                             new SnackBar(
                                               content: Text("Kategori Eklendi"),
                                               duration: Duration(seconds: 2),
                                             ),
                                           );*/
                                        }
                                      },
                                      child: Container(
                                        child: Image.asset(
                                            "assets/images/attendance.png"),
                                      ),
                                    ),
                                    // Icon(Icons.add_box,size: 30,),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    InkWell(
                                        onTap: () {
                                          print(
                                              "Klüp Bilgilerini Görme İsteği geldi");
                                        },
                                        child: Container(
                                            child: Image.asset(
                                                "assets/images/info.png"))),
                                  ],
                                ), //Text(oAnkiUser.aradakiFark),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else {
                return RefreshIndicator(
                  onRefresh: _kluplerListesiniYenile,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Container(
                      child: Center(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.chat_rounded,
                                color: Theme.of(context).primaryColor,
                                size: 80,
                              ),
                              Text(
                                "Henüz Önerilen Klüp Yok",
                                style: TextStyle(fontSize: 26),
                              ),
                            ]),
                      ),
                      height: MediaQuery.of(context).size.height - 150,
                    ),
                  ),
                );
              }
            }
          },
        ));
  }

  Future<Null> _kluplerListesiniYenile() async {
    setState(() {});
    await Future.delayed(Duration(seconds: 1));

    return null;
  }

  selectedItem(BuildContext context, int item) {
    switch (item) {
      case 0:
        print("Add Category Clicked");
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => AddCategoryPage()));
        break;
      case 1:
        print("Add Activity Clicked");
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => AddActivityPage()));
        break;
      case 2:
        print("Waiting Activity Request Clicked");
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => WaitingActivityRequest()));
        break;
      case 3:
        print("Waiting Club Request Clicked");
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => WaitingClubRequest()));
        break;
    }
  }
}
