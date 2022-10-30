import 'dart:io';
import 'dart:math';
import 'package:campusapp/custom_utils/colors.dart';
import 'package:campusapp/custom_utils/fade_animation.dart';
import 'package:campusapp/model/activity.dart';
import 'package:campusapp/model/club.dart';
import 'package:campusapp/pages/add_club_page.dart';
import 'package:campusapp/pages/waiting_activity_request_page.dart';
import 'package:campusapp/pages/waiting_club_request_page.dart';
import 'package:campusapp/service/local_db_helper.dart';
import 'package:campusapp/view_model/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddActivityPage extends StatefulWidget {
  @override
  _AddActivityPageState createState() => _AddActivityPageState();
}

class _AddActivityPageState extends State<AddActivityPage> {
  String _activityName,
      _activityTagLine,
      _activityDesc,
      _activityClubId,
      _activityId;
  DateTime dateTime = DateTime.now();
  List<Club> tumKlupler;
  DatabaseHelper databaseHelper;

  //String klupID;
  Club secilenKlup;
  bool chckResult;
  final _formKey = GlobalKey<FormState>();
  File _activityPhoto;
  final ImagePicker _picker = ImagePicker();

  Widget buildDateTimePicker() {
    if (Platform.isAndroid)
      return SizedBox(
        height: 1,
      );
    else
      return SizedBox(
        height: 180,
        width: 250,
        child: CupertinoDatePicker(
          initialDateTime: dateTime,
          mode: CupertinoDatePickerMode.dateAndTime,
          minimumDate: DateTime(DateTime.now().year, 2, 1),
          maximumDate: DateTime(DateTime.now().year + 3, 2, 1),
          use24hFormat: true,
          onDateTimeChanged: (dateTime) =>
              setState(() => this.dateTime = dateTime),
        ),
      );
  }

  String randomSayiUret() {
    int rastgeleSayi = Random().nextInt(9999999);
    return rastgeleSayi.toString();
  }

  String getText() {
    if (dateTime == null) {
      return 'Seçiniz';
    } else {
      return DateFormat('MM/dd/yyyy HH:mm').format(dateTime);
    }
  }

  void _kameradanFotoCek() async {
    var pickedPhoto = await _picker.getImage(source: ImageSource.camera);

    if (pickedPhoto != null) {
      setState(
        () {
          _activityPhoto = File(pickedPhoto.path);
          Navigator.of(context).pop();
        },
      );
    }
  }

  void _galeridenSec() async {
    var pickedPhoto = await _picker.getImage(source: ImageSource.gallery);

    if (pickedPhoto != null) {
      setState(
        () {
          _activityPhoto = File(pickedPhoto.path);
          Navigator.of(context).pop();
        },
      );
    }
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

  _formSubmit() async {
    _formKey.currentState.save();
    print(
        "adı $_activityName -- tag $_activityTagLine -- desc $_activityDesc --bağlı klüp  $_activityClubId -- club photo $_activityPhoto -- tarih $dateTime");

    if (_activityName == null ||
        _activityDesc == null ||
        _activityClubId == null ||
        _activityTagLine == null ||
        _activityPhoto == null) {
      showDialog(
          context: context,
          builder: (context) {
            Future.delayed(Duration(seconds: 2), () {
              Navigator.of(context).pop();
            });
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 200),
                  child: AlertDialog(
                    backgroundColor: Colors.white70,
                    content: SingleChildScrollView(
                      child: Text(
                        "Activite Adı - Sloganı - Açıklaması - Klubü - Etkinlik Tarihi Boş olamaz !!",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            letterSpacing: 2,
                            fontFamily: "Lobster"),
                      ),
                    ),
                    // shape: ContinuousRectangleBorder(),
                  ),
                ),
              ],
            );
          });
    } else {
      final _userModel = Provider.of<UserModel>(context, listen: false);

      _activityId = _activityName.replaceAll(" ", "");
      _activityId = _activityId + randomSayiUret();
      print("clubid $_activityId");
      try {
        var sonuc = await _userModel.addActivity(Activity(
            id: _activityId,
            description: _activityDesc,
            clubId: _activityClubId,
            name: _activityName,
            tagLine: _activityTagLine,
            dateTime: dateTime));
        var url = await _userModel.uploadActivityFile(
            _activityId, "activity_photo", _activityPhoto);
        print("sonuc --> $sonuc");
      } catch (e) {
        print("-->HATA $e");
      }
      // print("clubId $_clubId");

    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tumKlupler = List<Club>();
    databaseHelper = DatabaseHelper();
    databaseHelper.klupleriGetir().then((kisileriIcerenMapListesi) {
      for (Map okunanMap in kisileriIcerenMapListesi) {
        //  if(okunanMap["photoUrl"]!=null)
        tumKlupler.add(Club.fromJson(okunanMap));
      }
      _activityClubId = tumKlupler[0].id;
      secilenKlup = tumKlupler[0];
      //  debugPrint("secilen kisiye deger atandı" + secilenKlup.name);
      // }

      setState(() {});
    });
  }

  List<DropdownMenuItem<Club>> klupItemleriOlustur() {
    return tumKlupler.map((kisim) {
      return DropdownMenuItem<Club>(
        value: kisim,
        child: Text(
          kisim.name,
          style: TextStyle(fontSize: 16),
        ),
      );
    }).toList();
  }

  Future pickDateTime(BuildContext context) async {
    final date = await pickDate(context);
    if (date == null) return;

    final time = await pickTime(context);
    if (time == null) return;

    setState(() {
      dateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future<DateTime> pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: dateTime ?? initialDate,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (newDate == null) return null;

    return newDate;
  }

  Future<TimeOfDay> pickTime(BuildContext context) async {
    final initialTime = TimeOfDay(hour: 9, minute: 0);
    final newTime = await showTimePicker(
      context: context,
      initialTime: dateTime != null
          ? TimeOfDay(hour: dateTime.hour, minute: dateTime.minute)
          : initialTime,
    );

    if (newTime == null) return null;

    return newTime;
  }

  @override
  Widget build(BuildContext context) {
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
                  "Add Activity",
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
      body: tumKlupler.length == 0
          ? Container(
              child: Center(
                child: Text(
                    "Kayıtlı Klüp Yoktur. Aktivite Eklemek İçin Öncelikle Klüp Ekleyiniz !!"),
              ),
            )
          : SingleChildScrollView(
              //scrollDirection: Axis.vertical,
              child: Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            Container(
                              // color: Colors.red,
                              height: 350.0,
                              //color: Colors.red,
                            ),
                            Container(
                              height: 250.0,
                              decoration:
                                  BoxDecoration(gradient: primaryGradient),
                            ),
                            Positioned(
                                top: 100,
                                right: 0,
                                left: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return Container(
                                          height: 180,
                                          child: Column(
                                            children: [
                                              ListTile(
                                                leading: Icon(Icons.camera),
                                                title:
                                                    Text("Kameradan Foto Çek"),
                                                onTap: () {
                                                  _kameradanFotoCek();
                                                },
                                              ),
                                              ListTile(
                                                leading: Icon(Icons.image),
                                                title: Text("Galeriden Seç"),
                                                onTap: () {
                                                  _galeridenSec();
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Stack(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20.0, right: 20.0),
                                        child: Material(
                                          elevation: 5.0,
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          shadowColor: Colors.white,
                                          child: Container(
                                            height: 220.0,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              border: Border.all(
                                                color: Colors.grey
                                                    .withOpacity(0.2),
                                              ),
                                              color: Colors.grey,
                                            ),
                                            foregroundDecoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              image: DecorationImage(
                                                  image: _activityPhoto == null
                                                      ? NetworkImage(
                                                          "https://digitalpratix.com/wp-content/uploads/activity_resim.jpg")
                                                      : FileImage(
                                                          _activityPhoto),
                                                  fit: BoxFit.fill),
                                            ),
                                          ),
                                        ),
                                      ),
                                      // userStats
                                    ],
                                  ),
                                ))
                          ],
                        ),
                        FadeAnimation(
                          2,
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 90,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 20),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 5),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: gradientStart, width: 1),
                                      boxShadow: const [
                                        BoxShadow(
                                            color: gradientEnd,
                                            blurRadius: 10,
                                            offset: Offset(1, 1)),
                                      ],
                                      color: Colors.white,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20))),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.local_activity),
                                      Expanded(
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(left: 10),
                                          child: TextFormField(
                                            maxLength: 14,
                                            //maxLines: 1,
                                            onSaved:
                                                (String girilenAcitivityName) {
                                              _activityName =
                                                  girilenAcitivityName;
                                            },
                                            decoration: InputDecoration(
                                              labelText: " Activity Name ...",
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 90,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 20),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 5),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: gradientStart, width: 1),
                                      boxShadow: const [
                                        BoxShadow(
                                            color: gradientEnd,
                                            blurRadius: 10,
                                            offset: Offset(1, 1)),
                                      ],
                                      color: Colors.white,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20))),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.subtitles),
                                      Expanded(
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(left: 10),
                                          child: TextFormField(
                                            maxLines: 1,
                                            maxLength: 25,
                                            onSaved: (String girilenTagLine) {
                                              _activityTagLine = girilenTagLine;
                                            },
                                            decoration: InputDecoration(
                                              labelText:
                                                  " Activity Tag Line ...",
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                    width: double.infinity,
                                    height: 150,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 20),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 5),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: gradientStart, width: 1),
                                        boxShadow: const [
                                          BoxShadow(
                                              color: gradientEnd,
                                              blurRadius: 10,
                                              offset: Offset(1, 1)),
                                        ],
                                        color: Colors.white,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20))),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(Icons.description),
                                        Expanded(
                                          child: Container(
                                            margin:
                                                const EdgeInsets.only(left: 10),
                                            child: TextFormField(
                                              //obscureText: true,
                                              minLines: 3,
                                              maxLines: 4,
                                              onSaved: (String girilenDesc) {
                                                _activityDesc = girilenDesc;
                                              },
                                              decoration: InputDecoration(
                                                labelText:
                                                    " Activity Description ...",
                                                border: InputBorder.none,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        FadeAnimation(
                          2,
                          Row(
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  "Klüp :",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.purple,
                                      letterSpacing: 2,
                                      fontFamily: "Lobster"),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 1, horizontal: 12),
                                margin: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: gradientStart, width: 1),
                                    boxShadow: const [
                                      BoxShadow(
                                          color: gradientEnd,
                                          blurRadius: 10,
                                          offset: Offset(1, 1)),
                                    ],
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20))),
                                child: DropdownButtonHideUnderline(
                                    child: DropdownButton<Club>(
                                        items: klupItemleriOlustur(),
                                        hint: Text("Kategori Seç"),
                                        value: secilenKlup,
                                        onChanged:
                                            (Club kullanicininSectigiKisi) {
                                          debugPrint("Seçilen club:" +
                                              kullanicininSectigiKisi.name
                                                  .toString());
                                          setState(() {
                                            secilenKlup =
                                                kullanicininSectigiKisi;

                                            _activityClubId =
                                                kullanicininSectigiKisi.id;
                                          });
                                        })),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        FadeAnimation(
                          2,
                          Row(
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  "Tarih :",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.purple,
                                      letterSpacing: 2,
                                      fontFamily: "Lobster"),
                                ),
                              ),
                              FadeAnimation(
                                2,
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    buildDateTimePicker(),
                                    ElevatedButton(
                                      onPressed: () {
                                        if (Platform.isIOS) {
                                          /* Utils.showSheet(
                                              context,
                                              child: buildDateTimePicker(),
                                              onClicked: () {
                                                final value =
                                                DateFormat('MM/dd/yyyy HH:mm').format(dateTime);
                                                // Utils.showSnackBar(context, 'Selected "$value"');

                                                //Navigator.pop(context);
                                              },
                                            );*/
                                        } else {
                                          pickDateTime(context);
                                        }
                                      }, //=> pickDateTime(context),
                                      style: ElevatedButton.styleFrom(
                                          onPrimary: Colors.purpleAccent,
                                          shadowColor: Colors.purpleAccent,
                                          elevation: 18,
                                          padding: EdgeInsets.zero,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20))),
                                      child: Ink(
                                        decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                                colors: [
                                                  gradientStart,
                                                  gradientEnd
                                                ]),
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Container(
                                          width: 200,
                                          height: 50,
                                          alignment: Alignment.center,
                                          child: Text(
                                            getText(),
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),

                        const SizedBox(
                          height: 20,
                        ),

                        FadeAnimation(
                          2,
                          ElevatedButton(
                            onPressed: () => _formSubmit(),
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
                                  'Ekle',
                                  style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 80,
                        ),
                        // secondCard, thirdCard
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
