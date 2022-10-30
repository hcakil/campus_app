import 'dart:io';
import 'dart:math';

import 'package:campusapp/custom_utils/check_box_list_model.dart';
import 'package:campusapp/custom_utils/colors.dart';
import 'package:campusapp/custom_utils/fade_animation.dart';
import 'package:campusapp/model/activity.dart';
import 'package:campusapp/model/club.dart';
import 'package:campusapp/model/post.dart';
import 'package:campusapp/pages/add_activity_page.dart';
import 'package:campusapp/pages/waiting_activity_request_page.dart';
import 'package:campusapp/pages/waiting_club_request_page.dart';
import 'package:campusapp/view_model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddPostPage extends StatefulWidget {
  AddPostPage({Key key, this.gelenActivity}) : super(key: key);

  final Activity gelenActivity;

  @override
  _AddPostPageState createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  String _postName, _postId;
  bool loading = false;

  final _formKey = GlobalKey<FormState>();
  List<CheckBoxListTileModel> checkBoxListTileModel =
      CheckBoxListTileModel.getUsers();
  File _postPhoto;
  final ImagePicker _picker = ImagePicker();
  Post newPost;
  var url;

  _formSubmit() async {
    _formKey.currentState.save();
    print("adı $_postName -- - club photo $_postPhoto");

    if (_postName == null || _postPhoto == null) {
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
                        "Resim veya Açıklama Alanı Boş olamaz !!",
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
      setState(() {
        loading = true;
      });
      print(loading.toString() + " changed loading");
      _postId = _userModel.user.userID + widget.gelenActivity.id;
      _postId = _postId + randomSayiUret();
      print("clubid $_postId");
      try {
        newPost = Post(
          id: _postId,
          activityId: widget.gelenActivity.id,
          description: _postName,
          userId: _userModel.user.userID,
          userPhotoUrl: _userModel.user.profilURL,
          userName: _userModel.user.userName,
        );

        var sonuc = await _userModel.addPost(newPost);

        url = await _userModel.uploadPostFile(sonuc, "post_photo", _postPhoto);
        //print("sonuc --> $sonuc");

        setState(() {
          loading = false;
        });
      } catch (e) {
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
                  Row(
                    children: [
                      InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Icon(Icons.arrow_back)),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Add Post",
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
            ],
          )),
      body: loading == false
          ? SingleChildScrollView(
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
                              height: 290.0,
                              //color: Colors.red,
                            ),
                            Container(
                              height: 200.0,
                              decoration:
                                  BoxDecoration(gradient: primaryGradient),
                            ),
                            Positioned(
                                top: 50,
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
                                                  image: _postPhoto == null
                                                      ? NetworkImage(
                                                          "https://digitalpratix.com/wp-content/uploads/resimsec.png")
                                                      : FileImage(_postPhoto),
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
                                      const Icon(Icons.category),
                                      Expanded(
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(left: 10),
                                          child: TextFormField(
                                            maxLength: 45,
                                            //maxLines: 1,
                                            onSaved: (String girilenClubName) {
                                              _postName = girilenClubName;
                                            },
                                            decoration: InputDecoration(
                                              labelText: " Açıklama ...",
                                              border: InputBorder.none,
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
                        ),
                        const SizedBox(
                          height: 10,
                        ),

                        FadeAnimation(
                          2,
                          ElevatedButton(
                            onPressed: () async {
                              print(
                                  loading.toString() + " loading before start");
                              await _formSubmit();
                               Navigator.of(context).pop();
                             // Navigator.push(context, MaterialPageRoute(builder: (_) => Page2("Foo")));
                              print(loading.toString() + " loading finish");
                            },
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
                                  'Paylaş',
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
            )
          : Center(
              child: CircularProgressIndicator(),
            ), //Container(child: Center(child: Text("Add Category Page"),),),
    );
  }

  void _kameradanFotoCek() async {
    var pickedPhoto = await _picker.getImage(source: ImageSource.camera);

    if (pickedPhoto != null) {
      setState(
        () {
          _postPhoto = File(pickedPhoto.path);
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
          _postPhoto = File(pickedPhoto.path);
          Navigator.of(context).pop();
        },
      );
    }
  }
}
