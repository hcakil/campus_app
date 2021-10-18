import 'dart:io';
import 'dart:math';

import 'package:campusapp/custom_utils/check_box_list_model.dart';
import 'package:campusapp/custom_utils/colors.dart';
import 'package:campusapp/custom_utils/fade_animation.dart';
import 'package:campusapp/model/club.dart';
import 'package:campusapp/view_model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';



class AddCategoryPage extends StatefulWidget {
  @override
  _AddCategoryPageState createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  String _clubName, _clubTagLine, _clubDesc, _clubInterest,_clubId;
  bool chckResult;
  final _formKey = GlobalKey<FormState>();
  List<CheckBoxListTileModel> checkBoxListTileModel =
      CheckBoxListTileModel.getUsers();
  File _clubPhoto;
  final ImagePicker _picker = ImagePicker();



  _formSubmit() async{

    _formKey.currentState.save();
    print("adı $_clubName -- tag $_clubTagLine -- desc $_clubDesc --interst $_clubInterest -- club photo $_clubPhoto");

    if(_clubName==null || _clubDesc == null || _clubInterest== null || _clubTagLine== null || _clubPhoto== null )
      {
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
                          "Klüp Adı - Sloganı - Açıklaması - İlgi Alanı Boş olamaz !!",
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
      }
    else
      {
        final _userModel = Provider.of<UserModel>(context, listen: false);

        _clubId = _clubName.replaceAll(" ", "") ;
        _clubId = _clubId + randomSayiUret();
        print("clubid $_clubId");
        try{
           var sonuc = await _userModel.addClub(Club(name: _clubName,id:_clubId ,description: _clubDesc,subtitle: _clubTagLine,interest:_clubInterest ));
          var url = await _userModel.uploadCategoryFile(_clubId, "club_photo", _clubPhoto);
           //print("sonuc --> $sonuc");
        }catch (e){
          print("-->HATA $e");
        }
       // print("clubId $_clubId");




      }


  }
  String randomSayiUret() {
    int rastgeleSayi = Random().nextInt(9999999);
    return rastgeleSayi.toString();
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
                  "Add Club",
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
                        Text("Add Category"),
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
      body: SingleChildScrollView(
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
                        decoration: BoxDecoration(gradient: primaryGradient),
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
                                          title: Text("Kameradan Foto Çek"),
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
                                    borderRadius: BorderRadius.circular(8.0),
                                    shadowColor: Colors.white,
                                    child: Container(
                                      height: 220.0,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        border: Border.all(
                                          color: Colors.grey.withOpacity(0.2),
                                        ),
                                        color: Colors.grey,
                                      ),
                                      foregroundDecoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        image: DecorationImage(
                                            image: _clubPhoto == null
                                                ? NetworkImage(
                                                    "https://digitalpratix.com/wp-content/uploads/resimsec.png")
                                                : FileImage(_clubPhoto),
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
                                border:
                                    Border.all(color: gradientStart, width: 1),
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
                                const Icon(Icons.category),
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    child: TextFormField(
                                      maxLength: 14,
                                      //maxLines: 1,
                                      onSaved: (String girilenClubName) {
                                        _clubName = girilenClubName;
                                      },
                                      decoration: InputDecoration(
                                        labelText: " Club Name ...",
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
                                border:
                                    Border.all(color: gradientStart, width: 1),
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
                                    margin: const EdgeInsets.only(left: 10),
                                    child: TextFormField(
                                      maxLines: 1,
                                      maxLength: 25,
                                      onSaved: (String girilenTagLine) {
                                        _clubTagLine = girilenTagLine;
                                      },
                                      decoration: InputDecoration(
                                        labelText: " Club Tag Line ...",
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(Icons.description),
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.only(left: 10),
                                      child: TextFormField(
                                        //obscureText: true,
                                        minLines: 3,
                                        maxLines: 4,
                                        onSaved: (String girilenDesc) {
                                          _clubDesc = girilenDesc;
                                        },
                                        decoration: InputDecoration(
                                          labelText: " Club Description ...",
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
                    Text(
                      "İlgi Alanları",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.purple,
                          letterSpacing: 2,
                          fontFamily: "Lobster"),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
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
                        child: new ListView.builder(
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
                                        value: checkBoxListTileModel[index]
                                            .isCheck,
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
                      )),
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
      ), //Container(child: Center(child: Text("Add Category Page"),),),
    );
  }

  void _kameradanFotoCek() async {
    var pickedPhoto = await _picker.getImage(source: ImageSource.camera);

    if (pickedPhoto != null) {
      setState(
        () {
          _clubPhoto = File(pickedPhoto.path);
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
          _clubPhoto = File(pickedPhoto.path);
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
        break;
      case 2:
        print("Waiting Activity Request Clicked");
        /* Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => LoginPage()),
                (route) => false);*/
        break;
      case 3:
        print("Waiting Club Request Clicked");
        break;
    }
  }

  void itemChange(bool val, int index) {
    //List<int> interestList;

    setState(() {
      for (int i = 0; i < 4; i++) {
        if (i != index) {
          checkBoxListTileModel[i].isCheck = false;
        } else {
          _clubInterest = i.toString();
        }
      }
      checkBoxListTileModel[index].isCheck = val;
    });
  }
}
