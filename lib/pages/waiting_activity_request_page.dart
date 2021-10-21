import 'package:campusapp/custom_utils/colors.dart';
import 'package:campusapp/custom_utils/fade_animation.dart';
import 'package:campusapp/model/activityRequest.dart';
import 'package:campusapp/pages/add_activity_page.dart';
import 'package:campusapp/pages/add_category_page.dart';
import 'package:campusapp/pages/waiting_club_request_page.dart';
import 'package:campusapp/view_model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



class WaitingActivityRequest extends StatefulWidget {
  @override
  _WaitingActivityRequestState createState() => _WaitingActivityRequestState();
}

class _WaitingActivityRequestState extends State<WaitingActivityRequest> {

  String dialogString="İlk Değerlendirmeniz Alınmıştır!";

  Future<String> _approveRequest(
      String clubId,
      String userId,
      String clubName,
      String userName,
      String userProfileUrl,
      String type
      ) async {
    // oAnkiKlup.name,_userModel.user.userName,_userModel.user.profilURL

    print("id of a approved club -> $clubId  // user id --> $userId");
    if (userId != null) {
      final _userModel = Provider.of<UserModel>(context, listen: false);
      try {

        var sonuc = await _userModel.changeRequestTypeForClub(
            clubId, userId, clubName, userName, userProfileUrl,type);
        //var url = await _userModel.uploadCategoryFile(_clubId, "club_photo", _clubPhoto);
        //print("sonuc --> $sonuc");
        if (sonuc.contains("Approved")) {
          dialogString =
          "İstek ONAYLANMIŞTIR!!";
        } else if (sonuc.contains("Denied")) {
          dialogString =
          "İstek Reddedilmiştir.";
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
                    "Activity Requests",
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
    body:  FutureBuilder<List<ActivityRequest>>(
        future: _userModel.getAllActivityRequests(),
        builder: (context, aktiviteListesi) {
          if (!aktiviteListesi.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            var tumKlupler = aktiviteListesi.data;

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
                onRefresh: _aktivitelerlerListesiniYenile,
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
                              border: Border.all(
                                  color: Colors.blueGrey, width: 1),
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.blueGrey,
                                    blurRadius: 10,
                                    offset: Offset(1, 1)),
                              ],
                              color: Colors.blueGrey.shade300,
                              borderRadius:
                              const BorderRadius.all(Radius.circular(20))),
                          child: Container(
                              child: ListTile(
                                title: Text(oAnkiKlup.userName.toLowerCase(),
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 2,
                                        fontFamily: "OpenSans")),
                                subtitle: Text(
                                  oAnkiKlup.activityName,
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                                leading: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  backgroundImage:
                                  NetworkImage(oAnkiKlup.userPhotoUrl),
                                  radius: 30,
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    InkWell(
                                      onTap: ()  {

                                        print("Onay geldi");/*
                                        var result = await _approveRequest(
                                            oAnkiKlup.clubId,
                                            _userModel.user.userID,
                                            oAnkiKlup.clubName,
                                            _userModel.user.userName,
                                            _userModel.user.profilURL,
                                            "Approved"
                                        );

                                        if (result != null) {
                                          //  await Future.delayed(Duration(seconds: 1));
                                          print(result);

                                          PlatformDuyarliAlertDialog(
                                            baslik: "Katılma İsteği",
                                            icerik: dialogString,
                                            anaButonYazisi: "Tamam",
                                            // iptalButonYazisi: "Vazgeç"
                                          ).goster(context);


                                        }*/
                                      },
                                      child: Container(
                                        height: 40,
                                        child: Image.asset(
                                            "assets/images/check.png"),
                                      ),
                                    ),
                                    // Icon(Icons.add_box,size: 30,),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    InkWell(onTap: () async{


                                      print("Ret geldi");/*
                                      var result = await _approveRequest(
                                          oAnkiKlup.clubId,
                                          _userModel.user.userID,
                                          oAnkiKlup.clubName,
                                          _userModel.user.userName,
                                          _userModel.user.profilURL,
                                          "Denied"
                                      );

                                      if (result != null) {
                                        //  await Future.delayed(Duration(seconds: 1));
                                        print(result);

                                        PlatformDuyarliAlertDialog(
                                          baslik: "Katılma İsteği",
                                          icerik: dialogString,
                                          anaButonYazisi: "Tamam",
                                          // iptalButonYazisi: "Vazgeç"
                                        ).goster(context);


                                      }*/
                                    },
                                        child: Container(
                                            height: 40,
                                            child: Image.asset(
                                                "assets/images/denied.png"))),
                                  ],
                                ), //Text(oAnkiUser.aradakiFark),
                              )
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            } else {
              return RefreshIndicator(
                onRefresh: _aktivitelerlerListesiniYenile,
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
  Future<Null> _aktivitelerlerListesiniYenile() async {
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
