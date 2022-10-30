import 'package:campusapp/custom_utils/colors.dart';
import 'package:campusapp/custom_utils/fade_animation.dart';
import 'package:campusapp/custom_utils/platform_duyarli_alert_dialog.dart';
import 'package:campusapp/model/activity.dart';
import 'package:campusapp/model/club.dart';
import 'package:campusapp/model/clubRequest.dart';
import 'package:campusapp/pages/activity_feed_page.dart';
import 'package:campusapp/pages/activity_general_info_page.dart';
import 'package:campusapp/view_model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClubActivitiesInfo extends StatelessWidget {
  ClubActivitiesInfo({Key key, this.gelenClub}) : super(key: key);

  final Club gelenClub;
  String clubName = "Club Name";
  String clubTagLine = "Club Slogan";
  String clubDescription = "Club Description";
  String dialogString = "İlk Katılma İsteğiniz Alınmıştır";

  final Shader linearGradient = LinearGradient(
    colors: <Color>[gradientStart, gradientEnd],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  Future<String> _submitRequest(
      String activityId,
      String activityName,
      String clubId,
      String userId,
      String clubName,
      String userName,
      String userProfileUrl,
      BuildContext dialogContext) async {
    // oAnkiKlup.name,_userModel.user.userName,_userModel.user.profilURL

    print("id of a rewuested activity -> $activityId  // user id --> $userId");
    if (userId != null) {
      final _userModel = Provider.of<UserModel>(dialogContext, listen: false);
      try {
        var sonuc = await _userModel.addRequestForActivity(activityId,
            activityName, clubId, userId, clubName, userName, userProfileUrl);
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
                  gelenClub.name, // "Campus App",
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              height: 110,
              child: FutureBuilder<List<ClubRequest>>(
                future: _userModel.getClubAttendants(gelenClub.id),
                builder: (context, userList) {
                  if (!userList.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    var tumKatilanlar = userList.data;
                    return Container(
                      height: 85,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: tumKatilanlar.length,
                        itemBuilder: (context, index) {
                          var oAnkiKisi = userList.data[index];

                          return FadeAnimation(
                            2,
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Center(
                                  child: Container(
                                    width: 100, //double.infinity,

                                    //height: 85,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 5),

                                    child: Container(
                                      //color: Colors.red,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.blueAccent,
                                              width: 1),
                                          boxShadow: const [
                                            BoxShadow(
                                                color: Colors.blueAccent,
                                                blurRadius: 10,
                                                offset: Offset(1, 1)),
                                          ],
                                          color: Colors.white,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20))),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: CircleAvatar(
                                              backgroundColor:
                                                  Colors.greenAccent,
                                              backgroundImage: NetworkImage(
                                                  oAnkiKisi.userPhotoUrl),
                                              radius: 30,
                                            ),
                                          ),
                                          Center(
                                              child:
                                                  oAnkiKisi.userName.length <= 7
                                                      ? Text(oAnkiKisi.userName)
                                                      : Text(oAnkiKisi.userName
                                                          .substring(0, 7))),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ),
            Container(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Text(
                        "Aktiviteler", //gelenClub.subtitle, // "Slogan Text",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Lobster",
                            // color: Colors.white,
                            letterSpacing: 3,
                            foreground: Paint()..shader = linearGradient),
                      ),
                    ),
                  ],
                ),
              ),
              height: 80,
            ),
            Container(
              // height: double.infinity,
              width: double.infinity,
              child: FutureBuilder<List<Activity>>(
                future: _userModel.getClubBasedActivities(gelenClub.id),
                builder: (context, activityList) {
                  if (!activityList.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    var tumKatilanlar = activityList.data;
                    return Container(
                      height: 400,
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: tumKatilanlar.length,
                        itemBuilder: (context, index) {
                          var oAnkiAktivite = activityList.data[index];

                          return FadeAnimation(
                            2,
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: double.infinity,

                                  //height: 85,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 5),

                                  child: Column(
                                    children: [
                                      Container(
                                        height: 250,
                                        child: Stack(children: <Widget>[
                                          Column(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.transparent,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(20)),
                                                  boxShadow: const [
                                                    BoxShadow(
                                                        color:
                                                            Colors.blueAccent,
                                                        blurRadius: 10,
                                                        offset: Offset(1, 1)),
                                                  ],
                                                  border: Border.all(
                                                      color: Colors.blueAccent,
                                                      width: 1),
                                                  image: DecorationImage(
                                                      image: oAnkiAktivite.photoUrl ==
                                                              null
                                                          ? NetworkImage(
                                                              "https://digitalpratix.com/wp-content/uploads/resimsec.png")
                                                          : NetworkImage(
                                                              oAnkiAktivite
                                                                  .photoUrl),
                                                      fit: BoxFit.fill),
                                                ),
                                                height: 250.0,
                                              ),
                                            ],
                                          ),
                                          Container(
                                            height: 250.0,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                gradient: LinearGradient(
                                                    begin: FractionalOffset
                                                        .topCenter,
                                                    end: FractionalOffset
                                                        .bottomCenter,
                                                    colors: [
                                                      Colors.grey
                                                          .withOpacity(0.0),
                                                      Colors.white,
                                                    ],
                                                    stops: [
                                                      0.0,
                                                      1.0
                                                    ])),
                                          )
                                        ]),
                                      ),
                                      Container(
                                        height: 90,
                                        decoration: const BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: gradientEnd,
                                              offset: Offset(0.0, 1.0), //(x,y)
                                              blurRadius: 6.0,
                                            ),
                                          ],
                                          gradient: clubDescGradient,
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(20),
                                              bottomRight: Radius.circular(20)),
                                        ),
                                        width: double.infinity,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, top: 5),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                oAnkiAktivite.name
                                                    .toUpperCase(),
                                                // "Club Name",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: "Lobster",
                                                  color: Colors.white,
                                                  letterSpacing: 1,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  CircleAvatar(
                                                    backgroundColor:
                                                        Colors.white,
                                                    backgroundImage: AssetImage(
                                                        "assets/images/date_icon.png"),
                                                    //NetworkImage(oAnkiKlup.photoUrl),
                                                    radius: 20,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    oAnkiAktivite.dateTime.day
                                                            .toString() +
                                                        "/" +
                                                        oAnkiAktivite
                                                            .dateTime.month
                                                            .toString() +
                                                        "/" +
                                                        oAnkiAktivite
                                                            .dateTime.year
                                                            .toString(),
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: "OpenSans",
                                                      color: Colors.white,
                                                      letterSpacing: 1,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    oAnkiAktivite.dateTime.hour
                                                            .toString() +
                                                        ":" +
                                                        oAnkiAktivite
                                                            .dateTime.minute
                                                            .toString(),
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: "OpenSans",
                                                      color: Colors.white,
                                                      letterSpacing: 1,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 40,
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      InkWell(
                                                        onTap: () async {
                                                          print(oAnkiAktivite
                                                                  .name +
                                                              " katılma istegi");

                                                          print(
                                                              "Katılma İsteği geldi");
                                                          var result =
                                                              await _submitRequest(
                                                                  oAnkiAktivite
                                                                      .id,
                                                                  oAnkiAktivite
                                                                      .name,
                                                                  oAnkiAktivite
                                                                      .clubId,
                                                                  _userModel
                                                                      .user
                                                                      .userID,
                                                                  oAnkiAktivite
                                                                      .name,
                                                                  _userModel
                                                                      .user
                                                                      .userName,
                                                                  _userModel
                                                                      .user
                                                                      .profilURL,
                                                                  context);

                                                          if (result != null &&
                                                              !result.contains(
                                                                  "Approved")) {
                                                            //  await Future.delayed(Duration(seconds: 1));
                                                            print(result);

                                                            PlatformDuyarliAlertDialog(
                                                              baslik:
                                                                  "Katılma İsteği",
                                                              icerik:
                                                                  dialogString,
                                                              anaButonYazisi:
                                                                  "Tamam",
                                                              // iptalButonYazisi: "Vazgeç"
                                                            ).goster(context);

                                                            /* _scaffoldKey.currentState.showSnackBar(
                                             new SnackBar(
                                               content: Text("Kategori Eklendi"),
                                               duration: Duration(seconds: 2),
                                             ),
                                           );*/
                                                          } else if (result !=
                                                                  null &&
                                                              result.contains(
                                                                  "Approved")) {
                                                            Navigator.of(context).push(
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            ActivityFeedPage(
                                                                              gelenActivity: oAnkiAktivite,
                                                                            )));
                                                          } else {
                                                            PlatformDuyarliAlertDialog(
                                                              baslik:
                                                                  "Katılma İsteği",
                                                              icerik: "Hata",
                                                              anaButonYazisi:
                                                                  "Tamam",
                                                              // iptalButonYazisi: "Vazgeç"
                                                            ).goster(context);
                                                          }
                                                        },
                                                        child: Container(
                                                            //color: Colors.white,
                                                            height: 45,
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              borderRadius:
                                                                  const BorderRadius
                                                                          .all(
                                                                      Radius.circular(
                                                                          20)),
                                                            ),
                                                            child: Image.asset(
                                                                "assets/images/attendance.png")),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          print(oAnkiAktivite
                                                                  .name +
                                                              " info");
                                                          Navigator.of(context).push(
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          ActivityGeneralInfo(
                                                                            gelenActivity:
                                                                                oAnkiAktivite,
                                                                          )));
                                                        },
                                                        child: Container(
                                                            height: 45,
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              borderRadius:
                                                                  const BorderRadius
                                                                          .all(
                                                                      Radius.circular(
                                                                          20)),
                                                            ),
                                                            child: Image.asset(
                                                                "assets/images/info.png")),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ),
            SizedBox(
              height: 80,
            )
          ],
        ),
      ),
    );
  }
}
