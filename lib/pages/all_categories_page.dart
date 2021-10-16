import 'package:campusapp/custom_utils/fade_animation.dart';
import 'package:campusapp/model/club.dart';
import 'package:campusapp/view_model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllCategoryPage extends StatefulWidget {
  @override
  _AllCategoryPageState createState() => _AllCategoryPageState();
}

class _AllCategoryPageState extends State<AllCategoryPage> {

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
                  "Clubs",
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
        future: _userModel.getAllClubs(),
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
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20))),
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
                                  InkWell(onTap: (){},
                                      child: Tooltip(
                                        message: "Kayıt olmak için tıklayiniz",
                                        child: Container(

                                            child: Image.asset(
                                                "assets/images/attendance.png")),
                                      )),
                                  // Icon(Icons.add_box,size: 30,),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  InkWell(onTap: (){},
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
                              "Henüz Kategori Yok",
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

  Future<Null> _kluplerListesiniYenile() async {
    setState(() {});
    await Future.delayed(Duration(seconds: 1));

    return null;
  }


}
