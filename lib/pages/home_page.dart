import 'package:campusapp/custom_utils/fade_animation.dart';
import 'package:campusapp/model/user.dart';
import 'package:campusapp/pages/sign_up_page.dart';
import 'package:campusapp/view_model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _email, _sifre;
  final _formKey = GlobalKey<FormState>();
  String emailHataMesaji ;
  String sifreHataMesaji ;
  String hataMessage = "";

  bool emailSifreKontrol(String email, String sifre) {
    var sonuc = true;
    emailHataMesaji="base";
    sifreHataMesaji="base";
    //print("e mail şifre kontrole geşdi  -->" + email );
    //print(" şifre kontrole geşdi  -->" + sifre );
    if (sifre.length < 6) {
      sifreHataMesaji = "En az 6 karakter olmalıdır";
      // print(sifre.length.toString() +" şifre uzunluk");
      sonuc = false;
    } else {
      sifreHataMesaji = null;
    }
    if (!email.contains("@yeditepe.edu.tr")) {
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
    //print(result.toString() + " result");
    //  print("sifre hata " + sifreHataMesaji);
    //print("email hata " + emailHataMesaji);

    if (result) {
      try {
print("result true");
        //_userModel.createUserWithSignInWithEmail(_email, _sifre);
        MyUser _girisYapanUser =
        await _userModel.signInWithEmailAndPassword(_email, _sifre);

        //print("kayıt yapan user" + _kayitYapanUser.email);
        if (_girisYapanUser != null) {
           print("Oturum Açan userId   :  " + _girisYapanUser.userID.toString());
        }
      } catch (e) {
        print(
            " Widgeet Email Create Hata Tekrarı çıktı _2_    " + e.toString());
      }
    }
    else {
      print("$emailHataMesaji  email" );
      //print(sifreHataMesaji + " sifre" );

      if (emailHataMesaji != "base" || sifreHataMesaji != "base") {
        hataMessage = "Öğrenci mail adresi veya\n Şifreniz yanlış";
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
      print("user boş değil girişi home page den");
      Future.delayed(Duration(milliseconds: 30), () {
        print(_userModel.user.email);
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
                margin: const EdgeInsets.only(top: 100),
                child: const FadeAnimation(
                  2,
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
                )),
            Expanded(
              child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50))),
                  margin: const EdgeInsets.only(top: 60),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 50,
                        ),
                        Container(
                          // color: Colors.red,
                            alignment: Alignment.topLeft,
                            margin: const EdgeInsets.only(left: 22, bottom: 20),
                            child: const FadeAnimation(
                              2,
                              Text(
                                "Giriş",
                                style: TextStyle(
                                    fontSize: 35,
                                    color: Colors.black87,
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
                                  'Giriş',
                                  style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.white,
                                  ),
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
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(top: 10),
                              child: InkWell(
                                onTap: ()=> Navigator.of(context).push(MaterialPageRoute(
                                  fullscreenDialog: true,
                                  builder: (context) => SignUpPage(),
                                )),
                                child: const Text(
                                  "Kaydınız Yoksa Kayıt olmak için tıklayınız ",
                                  style: TextStyle(
                                      color: Colors.black45,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic),
                                ),
                              )),
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
}
