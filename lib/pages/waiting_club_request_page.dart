import 'package:campusapp/custom_utils/colors.dart';
import 'package:campusapp/custom_utils/fade_animation.dart';
import 'package:campusapp/custom_utils/platform_duyarli_alert_dialog.dart';
import 'package:campusapp/model/clubRequest.dart';
import 'package:campusapp/pages/add_activity_page.dart';
import 'package:campusapp/pages/add_club_page.dart';
import 'package:campusapp/pages/waiting_activity_request_page.dart';
import 'package:campusapp/view_model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WaitingClubRequest extends StatefulWidget {
  @override
  _WaitingClubRequestState createState() => _WaitingClubRequestState();
}

class _WaitingClubRequestState extends State<WaitingClubRequest> {
  String dialogString = "İlk Değerlendirmeniz Alınmıştır!";

  Future<String> _approveRequest(String clubId, String userId, String clubName,
      String userName, String userProfileUrl, String type) async {
    // oAnkiKlup.name,_userModel.user.userName,_userModel.user.profilURL

    print("id of a approved club -> $clubId  // user id --> $userId");
    if (userId != null) {
      final _userModel = Provider.of<UserModel>(context, listen: false);
      try {
        var sonuc = await _userModel.changeRequestTypeForClub(
            clubId, userId, clubName, userName, userProfileUrl, type);
        //var url = await _userModel.uploadCategoryFile(_clubId, "club_photo", _clubPhoto);
        //print("sonuc --> $sonuc");
        if (sonuc.contains("Approved")) {
          dialogString = "İstek ONAYLANMIŞTIR!!";
        } else if (sonuc.contains("Denied")) {
          dialogString = "İstek Reddedilmiştir.";
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
        backgroundColor: gradientEnd,
        title: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Club Requests",
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
        actions: [
          Theme(
            data: Theme.of(context).copyWith(
                textTheme: TextTheme().apply(bodyColor: Colors.black),
                dividerColor: Colors.white,
                iconTheme: IconThemeData(color: Colors.white)),
            child: PopupMenuButton<int>(
              color: Colors.blueAccent,
              itemBuilder: (context) => [
                PopupMenuItem<int>(
                    value: 0,
                    child: Row(
                      children: [
                        Icon(
                          Icons.category,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: 7,
                        ),
                        Text("Add Club"),
                      ],
                    )),
                PopupMenuItem<int>(
                    value: 1,
                    child: Row(
                      children: [
                        Icon(
                          Icons.local_activity,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: 7,
                        ),
                        Text("Add Activity"),
                      ],
                    )),
                PopupMenuDivider(),
                PopupMenuItem<int>(
                    value: 2,
                    child: Row(
                      children: [
                        Icon(
                          Icons.local_activity_rounded,
                          color: Colors.red,
                        ),
                        const SizedBox(
                          width: 7,
                        ),
                        Text("Waiting Activity Requests")
                      ],
                    )),
                PopupMenuItem<int>(
                    value: 3,
                    child: Row(
                      children: [
                        Icon(
                          Icons.category_rounded,
                          color: Colors.red,
                        ),
                        const SizedBox(
                          width: 7,
                        ),
                        Text("Waiting Club Requests")
                      ],
                    )),
              ],
              onSelected: (item) => selectedItem(context, item),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<ClubRequest>>(
        future: _userModel.getAllClubRequests(),
        builder: (context, klubListesi) {
          if (!klubListesi.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            var tumKlupler = klubListesi.data;

            if (tumKlupler.length > 0) {
              // List<ClubRequest> clubUniqueList = [];
              //List<ClubRequest> clubUniqueReqestList = [];
              //var totalList =[];

              /* for(ClubRequest i in tumKlupler)
                {
                  if(!clubUniqueList.contains(i))
                    {
                      clubUniqueList.add(i);
                      totalList.add(i);
                      print("$i eklendi club unique");
                    }
                  if(!clubUniqueReqestList.contains(i))
                    {
                      clubUniqueReqestList.add(i);
                      totalList.add(i);
                      print("$i eklendi club request unique");
                    }
                }*/

              return RefreshIndicator(
                onRefresh: _kluplerListesiniYenile,
                child: ListView.builder(
                  itemCount: tumKlupler.length,
                  itemBuilder: (context, index) {
                    var oAnkiKlup = tumKlupler[index];
                    return GestureDetector(
                      onTap: () {
                        print("category name");
                        print(oAnkiKlup.clubName);
                      },
                      child: FadeAnimation(
                        2,
                        Container(
                          width: double.infinity,
                          height: 85,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 5),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 0),
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.blueGrey, width: 1),
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.blueGrey,
                                    blurRadius: 10,
                                    offset: Offset(1, 1)),
                              ],
                              color: Colors.blueGrey.shade100,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20))),
                          child: Container(
                              child: ListTile(
                            onTap: () {},
                            title: Text(oAnkiKlup.userName.toUpperCase(),
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.purple,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                    fontFamily: "OpenSans")),
                            subtitle: Text(
                              oAnkiKlup.clubName,
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                            leading: CircleAvatar(backgroundImage:
                            NetworkImage(oAnkiKlup.userPhotoUrl),
                              radius: 30,
                              backgroundColor: Colors.white,),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    print("Onay geldi");
                                    var result = await _approveRequest(
                                        oAnkiKlup.clubId,
                                        oAnkiKlup.userId,
                                        //_userModel.user.userID,
                                        oAnkiKlup.clubName,
                                        oAnkiKlup.userName,
                                        oAnkiKlup.userPhotoUrl,
                                        // _userModel.user.userName,
                                        // _userModel.user.profilURL,
                                        "Approved");

                                    if (result != null) {
                                      //  await Future.delayed(Duration(seconds: 1));
                                      print(result);

                                      PlatformDuyarliAlertDialog(
                                        baslik: "Katılma İsteği",
                                        icerik: dialogString,
                                        anaButonYazisi: "Tamam",
                                        // iptalButonYazisi: "Vazgeç"
                                      ).goster(context);
                                    }
                                  },
                                  child: Container(
                                    height: 40,
                                    child:
                                        Image.asset("assets/images/check.png"),
                                  ),
                                ),
                                // Icon(Icons.add_box,size: 30,),
                                SizedBox(
                                  width: 15,
                                ),
                                InkWell(
                                    onTap: () async {
                                      print("Ret geldi");
                                      var result = await _approveRequest(
                                          oAnkiKlup.clubId,
                                          oAnkiKlup.userId,
                                          //_userModel.user.userID,
                                          oAnkiKlup.clubName,
                                          oAnkiKlup.userName,
                                          //_userModel.user.userName,
                                          oAnkiKlup.userPhotoUrl,
                                          //_userModel.user.profilURL,
                                          "Denied");

                                      if (result != null) {
                                        //  await Future.delayed(Duration(seconds: 1));
                                        print(result);

                                        PlatformDuyarliAlertDialog(
                                          baslik: "Katılma İsteği",
                                          icerik: dialogString,
                                          anaButonYazisi: "Tamam",
                                          // iptalButonYazisi: "Vazgeç"
                                        ).goster(context);
                                      }
                                    },
                                    child: Container(
                                        height: 40,
                                        child: Image.asset(
                                            "assets/images/denied.png"))),
                              ],
                            ), //Text(oAnkiUser.aradakiFark),
                          )),
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
                              "Henüz Klüp İsteği Yok",
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
      ),
    );
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
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => WaitingActivityRequest()));
        break;
      case 3:
        print("Waiting Club Request Clicked");
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => WaitingClubRequest()));
        break;
    }
  }

  Future<Null> _kluplerListesiniYenile() async {
    setState(() {});
    await Future.delayed(Duration(seconds: 1));

    return null;
  }


}
