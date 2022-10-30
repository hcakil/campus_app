import 'dart:io';

import 'package:campusapp/custom_utils/check_box_list_model.dart';
import 'package:campusapp/custom_utils/fade_animation.dart';
import 'package:campusapp/custom_utils/platform_duyarli_alert_dialog.dart';
import 'package:campusapp/model/activity.dart';
import 'package:campusapp/model/club.dart';
import 'package:campusapp/pages/activity_general_info_page.dart';
import 'package:campusapp/pages/club_general_info_page.dart';
import 'package:campusapp/view_model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:campusapp/custom_utils/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<CheckBoxListTileModel> checkBoxListTileModel =
      CheckBoxListTileModel.getUsers();
  TextEditingController _controllerUserName;

  // String testInterest;
  String newInterest = "";

  File _profilPhoto;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controllerUserName = TextEditingController();
  }

  @override
  void dispose() {
    _controllerUserName.dispose();
    super.dispose();
  }

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

  void _kameradanFotoCek() async {
    var pickedPhoto = await _picker.getImage(source: ImageSource.camera);

    if (pickedPhoto != null) {
      setState(
        () {
          _profilPhoto = File(pickedPhoto.path);
          Navigator.of(context).pop();
        },
      );
    }
  }

  void _galeridenSec() async {
    try {
      var pickedPhoto = await _picker.getImage(source: ImageSource.gallery);
      if (pickedPhoto != null) {
        setState(
          () {
            _profilPhoto = File(pickedPhoto.path);
            Navigator.of(context).pop();
          },
        );
      }
    } catch (e) {
      print("hata " + e.toString());
    }
  }

  _showModelBottomSheet(BuildContext context) {
    try {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: 180,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.camera),
                  title: Text("Kameradan Foto Çek"),
                  onTap: () {
                    try {
                      _kameradanFotoCek();
                    } catch (e) {
                      print(e.toString());
                    }
                  },
                ),
                ListTile(
                  leading: Icon(Icons.image),
                  title: Text("Galeriden Seç"),
                  onTap: () {
                    _galeridenSec();
                    //  Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        },
      );
    } catch (e) {
      print(e.toString() + " haata");
    }
  }

  @override
  Widget build(BuildContext context) {
    UserModel _userModel = Provider.of<UserModel>(context, listen: false);
    _controllerUserName.text = _userModel.user.userName;
    // print(_userModel.user.interest);
    // print("interests");
    _fillInterests();

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.purple.shade600,
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
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    //Platform.isAndroid == true ?
                    _showModelBottomSheet(context); //:
                    //_galeridenSec();
                  },
                  child: FadeAnimation(
                    2,
                    CircleAvatar(
                      radius: 80,
                      backgroundColor: Colors.purpleAccent,
                      child: CircleAvatar(
                        backgroundColor: Colors.grey,
                        backgroundImage: _profilPhoto == null
                            ? NetworkImage(_userModel.user.profilURL)
                            : FileImage(_profilPhoto),
                        radius: 75,
                      ),
                    ),
                  ),
                ),
              ),
              FadeAnimation(
                2,
                Container(
                  width: double.infinity,
                  height: 70,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.purpleAccent, width: 1),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.purpleAccent,
                            blurRadius: 10,
                            offset: Offset(1, 1)),
                      ],
                      color: Colors.white,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(Icons.email_outlined),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(left: 10),
                          child: TextFormField(
                            maxLines: 1,
                            readOnly: true,
                            //controller: _controllerUserName,
                            initialValue: _userModel.user.email,
                            decoration: InputDecoration(
                              labelText: " E-Mail ...",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              FadeAnimation(
                2,
                Container(
                  width: double.infinity,
                  height: 70,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.purpleAccent, width: 1),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.purpleAccent,
                            blurRadius: 10,
                            offset: Offset(1, 1)),
                      ],
                      color: Colors.white,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(Icons.person),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(left: 10),
                          child: TextFormField(
                            controller: _controllerUserName,
                            maxLines: 1,
                            //controller: _controllerUserName,
                            //initialValue: _userModel.user.userName,
                            decoration: InputDecoration(
                              labelText: " Kullanıcı Adı ...",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              FadeAnimation(
                2,
                Text(
                  "İlgi Alanları",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.purple,
                      letterSpacing: 2,
                      fontFamily: "Lobster"),
                ),
              ),
              FadeAnimation(
                2,
                Container(
                  width: double.infinity,
                  height: 290,
                  //color: Colors.purple.shade50,
                  decoration: const BoxDecoration(
                    // color: Colors.blueGrey,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                  child: new ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: checkBoxListTileModel.length,
                    itemBuilder: (BuildContext context, int index) {
                      return new Card(
                        shadowColor: Colors.purpleAccent,
                        child: new Container(
                          width: 150,
                          child: Column(
                            children: <Widget>[
                              new CheckboxListTile(
                                  activeColor: Colors.pink[300],
                                  dense: true,
                                  //font change
                                  title: new Text(
                                    checkBoxListTileModel[index].title,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: "Lobster",
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  value: checkBoxListTileModel[index].isCheck,
                                  secondary: Container(
                                    height: 50,
                                    width: 50,
                                    child: Image.asset(
                                      checkBoxListTileModel[index].img,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  onChanged: (bool val) {
                                    itemChange(val, index);
                                  })
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              FadeAnimation(
                2,
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Kayıtlı Kulüpler",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.purple,
                        letterSpacing: 2,
                        fontFamily: "Lobster"),
                  ),
                ),
              ),
              FadeAnimation(
                2,
                Container(
                  width: double.infinity,
                  height: 150,
                  //color: Colors.purple.shade50,
                  decoration: const BoxDecoration(
                    // color: Colors.blueGrey,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                  child: FutureBuilder(
                      future: _userModel
                          .getAllApprovalClubRequests(_userModel.user.userID),
                      builder: (context, klubListesi) {
                        if (!klubListesi.hasData) {
                          return Center(
                            child: Text(
                              "Kayıtlı Klüp Yok",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                  fontFamily: "OpenSans"),
                            ),
                          );
                        } else {
                          var tumKlupler = klubListesi.data;
                          if (tumKlupler.length > 0) {
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: tumKlupler.length,
                              itemBuilder: (context, index) {
                                var oAnkiKlup = tumKlupler[index];
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        offset: Offset(0, 4),
                                        blurRadius: 20,
                                        color: Color(0xFFB0CCE1).withOpacity(0.32),
                                      ),
                                    ],
                                  ),
                                  child: GestureDetector(
                                    onTap: () async{
                                      Club secilenKlup =  await _userModel.getClubWithId(
                                          oAnkiKlup.clubId);
                                      print(secilenKlup.name);

                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder:
                                                  (context) =>
                                                  ClubGeneralInfo(
                                                    gelenClub: secilenKlup,
                                                  )));
                                    },
                                    child: Container(
                                      width: 170,
                                      // double.infinity,
                                      height: 50,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 5),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 0),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.deepPurple, width: 1),
                                          boxShadow: const [
                                            BoxShadow(
                                                color: Colors.deepPurpleAccent,
                                                blurRadius: 10,
                                                offset: Offset(1, 1)),
                                          ],
                                          color: Colors.white,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20))),
                                      child: Container(
                                          child: ListTile(
                                        title: Center(
                                          child: Text(oAnkiKlup.clubName,
                                              style: TextStyle(
                                                  fontSize: 30,
                                                  color: gradientEnd,//Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 2,
                                                  fontFamily: "Lobster")),
                                        ),


                                      )),
                                    ),
                                  ),
                                );
                              },
                            );
                          } else
                            return Center(
                              child: Text(
                                "Kayıtlı Klüp Yok",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                    fontFamily: "OpenSans"),
                              ),
                            );
                        }
                      }),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              FadeAnimation(
                2,
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Kayıtlı Aktiviteler",
                    style: TextStyle(
                        fontSize: 20,
                        color: gradientEnd,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        fontFamily: "Lobster"),
                  ),
                ),
              ),
              FadeAnimation(
                2,
                Container(
                  width: double.infinity,
                  height: 250,
                  //color: Colors.purple.shade50,
                  decoration: const BoxDecoration(
                    // color: Colors.blueGrey,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                  child: FutureBuilder(
                      future: _userModel.getAllApprovalActivityRequests(
                          _userModel.user.userID),
                      builder: (context, aktiviteListesi) {
                        if (!aktiviteListesi.hasData) {
                          return Center(
                            child: Text(
                              "Kayıtlı Aktivite Yok",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                  fontFamily: "OpenSans"),
                            ),
                          );
                        } else {
                          var tumAktiviteler = aktiviteListesi.data;
                          if (tumAktiviteler.length > 0) {
                            return ListView.builder(
                              itemCount: tumAktiviteler.length,
                              itemBuilder: (context, index) {
                                var oAnkiAktivite = tumAktiviteler[index];
                                return GestureDetector(
                                  onTap: () async{
                                   // print("category name");
                                   // print(oAnkiAktivite.activityName);

                                  },
                                  child: FadeAnimation(
                                    2,
                                    Container(
                                      width: double.infinity,
                                      height: 50,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 5),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 0),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.blueGrey, width: 1),
                                          boxShadow: const [
                                            BoxShadow(
                                                color: gradientStart,
                                                blurRadius: 10,
                                                offset: Offset(1, 1)),
                                          ],
                                          color: gradientEnd,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20))),
                                      child: Container(
                                          child: ListTile(
                                        title: Text(oAnkiAktivite.activityName,
                                            style: TextStyle(
                                                fontSize: 30,
                                                color: Colors.white,
                                                fontWeight: FontWeight.normal,
                                                fontStyle: FontStyle.italic,
                                                letterSpacing: 2,
                                                fontFamily: "Lobster")),

                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            InkWell(
                                              onTap: () async{

                                             Activity secilenAktivite =  await _userModel.getActivityWithId(
                                                   oAnkiAktivite.activityId);

                                             Navigator.of(context).push(
                                                 MaterialPageRoute(
                                                     builder:
                                                         (context) =>
                                                         ActivityGeneralInfo(
                                                           gelenActivity: secilenAktivite,
                                                         )));
                                                print("bilgi sayfasına git");
                                              },
                                              child: Container(
                                                height: 40,
                                                child: Image.asset(
                                                    "assets/images/info.png"),
                                              ),
                                            ),
                                            // Icon(Icons.add_box,size: 30,),
                                            SizedBox(
                                              width: 5,
                                            ),
                                          ],
                                        ), //Text(oAnkiUser.aradakiFark),
                                      )),
                                    ),
                                  ),
                                );
                              },
                            );
                          } else
                            return Center(
                              child: Text(
                                "Kayıtlı Aktivite Yok",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                    fontFamily: "OpenSans"),
                              ),
                            );
                        }
                      }),
                ),
              ),
              FadeAnimation(
                2,
                ElevatedButton(
                  onPressed: () => _profilPhotoVeUserNameGuncelle(context),
                  style: ElevatedButton.styleFrom(
                      onPrimary: Colors.purpleAccent,
                      shadowColor: Colors.purpleAccent,
                      elevation: 18,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                  child: Ink(
                    decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [
                          Colors.purpleAccent,
                          Colors.deepPurpleAccent
                        ]),
                        borderRadius: BorderRadius.circular(20)),
                    child: Container(
                      width: 200,
                      height: 50,
                      alignment: Alignment.center,
                      child: const Text(
                        'Güncelle',
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 100,
              )
            ],
          ),
        ),
      ),
    );
  }

  void _profilPhotoVeUserNameGuncelle(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    bool result = true;

    //print("user model name "+_userModel.user.userName);
    //  print("controller text name "+_controllerUserName.text);
    newInterest = "";
    _checkInterests();
    print("interest $newInterest ");
    try {
      if (newInterest != "") {
        var result = await _userModel.updateInterest(
            _userModel.user.userID, newInterest);
      }
      if (_profilPhoto != null) {
        // upload yapılır
        var url = await _userModel.uploadFile(
            _userModel.user.userID, "profil_photo", _profilPhoto);
      }
      if (_userModel.user.userName != _controllerUserName.text) {
        var updateResult = await _userModel.updateUserName(
            _userModel.user.userID, _controllerUserName.text);

        if (updateResult == true) {
          _userModel.user.userName = _controllerUserName.text;

          //print("Kullanıcı Adı değiştirildi" + _userModel.user.userName);
        } else {
          result = false;
        }
      }
    } catch (e) {} finally {
      if (result) {
        PlatformDuyarliAlertDialog(
          baslik: "Uyarı",
          icerik: "Bilgileriniz Güncellenmiştir.",
          anaButonYazisi: "Tamam",
          // iptalButonYazisi: "Vazgeç"
        ).goster(context);
      } else {
        PlatformDuyarliAlertDialog(
          baslik: "Uyarı",
          icerik:
              "Kullanıcı Adı kullanımda.Lütfen başka kullanıcı adı deneyiniz",
        ).goster(context);
      }
    }
  }

  void itemChange(bool val, int index) {
    //List<int> interestList;
//print("$val  va ve $index index");
    setState(() {
      checkBoxListTileModel[index].isCheck = val;
    });
  }

  void _fillInterests() {
    UserModel _userModel = Provider.of<UserModel>(context, listen: false);
    String _interest = _userModel.user.interest;
    // testInterest="";

    List<int> intersestList = [];
    List<String> interestStringList = [];

    interestStringList = _interest.split("");
    intersestList = interestStringList.map(int.parse).toList();

    for (int i = 0; i < 4; i++) {
      if (intersestList.contains(i)) {
        itemChange(true, i);
        // print("interest $i true oldu");
      } else {
        // itemChange(false, i);
      }
    }
    //  testInterest= utf8.decode(intersestList);
    // testInterest = testInterest.join(intersestList.map((i) => i.toString()), "");
    //testInterest= String.fromCharCodes(intersestList);
    // print("$testInterest test interest");
    // _userModel.user.interest = test;
  }

  void _checkInterests() {
    for (int i = 0; i < 4; i++) {
      if (checkBoxListTileModel[i].isCheck)
        newInterest = newInterest + i.toString();
    }
  }
}
