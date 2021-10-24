
import 'package:campusapp/custom_utils/check_box_list_model.dart';
import 'package:campusapp/custom_utils/exceptions.dart';
import 'package:campusapp/custom_utils/fade_animation.dart';
import 'package:campusapp/custom_utils/platform_duyarli_alert_dialog.dart';
import 'package:campusapp/model/user.dart';
import 'package:campusapp/pages/home_page.dart';
import 'package:campusapp/view_model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  List<CheckBoxListTileModel> checkBoxListTileModel =
      CheckBoxListTileModel.getUsers();
  String _email, _sifre;
  String emailHataMesaji;

  String sifreHataMesaji;

  String _interest = "";

  String hataMessage = "";
  final _formKey = GlobalKey<FormState>();

  bool emailSifreKontrol(String email, String sifre) {
    var sonuc = true;
    emailHataMesaji = "base";
    sifreHataMesaji = "base";
    //print("e mail şifre kontrole geşdi  -->" + email );
    //print(" şifre kontrole geşdi  -->" + sifre );
    if (sifre.length < 6) {
      sifreHataMesaji = "En az 6 karakter olmalıdır";
      // print(sifre.length.toString() +" şifre uzunluk");
      sonuc = false;
    } else {
      sifreHataMesaji = null;
    }
    if (!email.contains("@std.yeditepe.edu.tr")) {
      emailHataMesaji = "Lütfen geçerli bir öğrenci mail adresi giriniz";
      // print(email.length.toString() +" şifre uzunluk");
      sonuc = false;
    } else {
      emailHataMesaji = null;
    }

    return sonuc;
  }

  //Form Submit
  void _formSubmit() async {
    _formKey.currentState.save();
    debugPrint("e mail " + _email + "  sifre  ==" + _sifre);
    //print(_formType.toString() + "  -----aaa");
    final _userModel = Provider.of<UserModel>(context, listen: false);
    var result = emailSifreKontrol(_email, _sifre);
    print(result.toString() + " result");
    //  print("sifre hata " + sifreHataMesaji);
    //print("email hata " + emailHataMesaji);

    if (result) {
      try {
        for (int i = 0; i < 4; i++) {
          if(checkBoxListTileModel[i].isCheck)
          _interest = _interest + i.toString();
          print("interest $_interest ");
        }
        //_userModel.createUserWithSignInWithEmail(_email, _sifre);
        MyUser _kayitYapanUser =
            await _userModel.createUserWithSignInWithEmail(_email, _sifre,_interest);
        //print("kayıt yapan user" + _kayitYapanUser.email);
        if (_kayitYapanUser != null) {
          // print("Oturum Açan userId   :  " + _kayitYapanUser.userID.toString());
        }
      } on FirebaseAuthException catch (e) {
        print(
            " Widgeet Email Create Hata Tekrarı çıktı _2_  " +e.code+ " --"+ e.toString());
        _interest="";
        PlatformDuyarliAlertDialog(
          baslik: "Kullanıcı Oluşturmada HATA",
          icerik: Hatalar.goster(e.code),
          anaButonYazisi: 'Tamam',
        ).goster(context);



      }
    } else {

      print("$emailHataMesaji  email");
      //print(sifreHataMesaji + " sifre" );
      _interest="";
      if (emailHataMesaji != "base" || sifreHataMesaji != "base") {
        hataMessage = "Öğrenci mail adresi ve\n 6 haneli şifre giriniz";
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
                          hataMessage,
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
    }
  }

  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserModel>(context);

    if (_userModel.user != null) {
      Future.delayed(Duration(milliseconds: 30), () {
        Navigator.of(context).popUntil(ModalRoute.withName("/"));
      });
    }

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              // Colors.purple,
              Colors.purple.shade600,
              Colors.deepPurpleAccent,
            ])),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10),
            ),
            Expanded(
              child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50))),
                  margin: const EdgeInsets.only(top: 30),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 50,
                        ),
                        Container(
                            // color: Colors.red,
                            alignment: Alignment.topLeft,
                            margin: const EdgeInsets.only(left: 22, bottom: 10),
                            child: const FadeAnimation(
                              2,
                              Text(
                                "Kayıt",
                                style: TextStyle(
                                    fontSize: 35,
                                    color: Colors.black,
                                    letterSpacing: 2,
                                    fontFamily: "Lobster"),
                              ),
                            )),
                        FadeAnimation(
                          2,
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 70,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 20),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 5),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.purpleAccent, width: 1),
                                      boxShadow: const [
                                        BoxShadow(
                                            color: Colors.purpleAccent,
                                            blurRadius: 10,
                                            offset: Offset(1, 1)),
                                      ],
                                      color: Colors.white,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20))),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.email_outlined),
                                      Expanded(
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(left: 10),
                                          child: TextFormField(
                                            maxLines: 1,
                                            onSaved: (String girilenEmail) {
                                              _email = girilenEmail;
                                            },
                                            decoration: InputDecoration(
                                              labelText: " E-mail ...",
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
                                    height: 70,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 20),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 5),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.purpleAccent,
                                            width: 1),
                                        boxShadow: const [
                                          BoxShadow(
                                              color: Colors.purpleAccent,
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
                                        Icon(Icons.text_fields),
                                        Expanded(
                                          child: Container(
                                            margin:
                                                const EdgeInsets.only(left: 10),
                                            child: TextFormField(
                                              obscureText: true,
                                              maxLines: 1,
                                              onSaved: (String girilenSifre) {
                                                _sifre = girilenSifre;
                                              },
                                              decoration: InputDecoration(
                                                labelText: " Şifre ...",
                                                border: InputBorder.none,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ))
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
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
                                                checkBoxListTileModel[index]
                                                    .title,
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontFamily: "Lobster",
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                              value:
                                                  checkBoxListTileModel[index]
                                                      .isCheck,
                                              secondary: Container(
                                                height: 50,
                                                width: 50,
                                                child: Image.asset(
                                                  checkBoxListTileModel[index]
                                                      .img,
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
                          Container(

                              width: double.infinity,
                              height: 50,
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(top: 5),
                              child: InkWell(
                                onTap: ()=> Navigator.of(context).push(MaterialPageRoute(
                                  fullscreenDialog: true,
                                  builder: (context) => Home(),
                                )),
                                child: const Text(
                                  "Kaydınız Varsa Giriş Yapmak için tıklayınız ",
                                  style: TextStyle(
                                      color: Colors.black45,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic),
                                ),
                              )),
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
                                  'Kayıt Ol',
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
                          height: 20,
                        ),
                      ],
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }

  void itemChange(bool val, int index) {
    //List<int> interestList;

    setState(() {
      checkBoxListTileModel[index].isCheck = val;
    });
  }
}
