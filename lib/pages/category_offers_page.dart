import 'package:campusapp/custom_utils/fade_animation.dart';
import 'package:campusapp/model/club.dart';
import 'package:campusapp/pages/add_category_page.dart';
import 'package:campusapp/view_model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryOffersPage extends StatefulWidget {
  @override
  _CategoryOffersPageState createState() => _CategoryOffersPageState();
}

class _CategoryOffersPageState extends State<CategoryOffersPage> {

  bool _shouldHideAction;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _shouldHideAction = true;
  }
  @override
  Widget build(BuildContext context) {
    UserModel _userModel = Provider.of<UserModel>(context);
    if(_userModel.user.seviye != null && _userModel.user.seviye == 2 )
      _shouldHideAction = false;
    // print("seviye of usermodel");
     //print(_userModel.user.seviye);

    return  Scaffold(
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
                  "Campus App",
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
          actions: _shouldHideAction ? [] : [
            Theme(
              data: Theme.of(context).copyWith(
                  textTheme: TextTheme().apply(bodyColor: Colors.black),
                  dividerColor: Colors.white,
                  iconTheme: IconThemeData(color: Colors.white)),
              child: PopupMenuButton<int>(
                color:Colors.blueAccent,
                itemBuilder: (context) => [
                  PopupMenuItem<int>(value: 0, child: Row(

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
                      value: 1, child: Row(
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
                onSelected: (item) => SelectedItem(context, item),
              ),
            ),
          ]
      ),
      body: FutureBuilder<List<Club>>(
        future: _userModel.getOfferedClubs(_userModel.user.interest),
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
                                  InkWell(
                                      onTap: () {},
                                      child: Container(
                                          child: Image.asset(
                                              "assets/images/attendance.png"))),
                                  // Icon(Icons.add_box,size: 30,),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  InkWell(
                                      onTap: () {},
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
                              "Henüz Önerilen Klüp Yok",
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
      )
    );
  }

  Future<Null> _kluplerListesiniYenile() async {
    setState(() {});
    await Future.delayed(Duration(seconds: 1));

    return null;
  }
  SelectedItem(BuildContext context, int item) {
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
}
