import 'package:campusapp/custom_utils/colors.dart';
import 'package:campusapp/custom_utils/fade_animation.dart';
import 'package:campusapp/model/activity.dart';
import 'package:campusapp/model/post.dart';
import 'package:campusapp/pages/add_post_page.dart';
import 'package:campusapp/view_model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ActivityFeedPage extends StatefulWidget {
  ActivityFeedPage({Key key, this.gelenActivity}) : super(key: key);

  final Activity gelenActivity;

  @override
  _ActivityFeedPageState createState() => _ActivityFeedPageState();
}

class _ActivityFeedPageState extends State<ActivityFeedPage> {
  @override
  Widget build(BuildContext context) {
    UserModel _userModel = Provider.of<UserModel>(context);
   // _kluplerListesiniYenile();

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
                      widget.gelenActivity.name, // "Campus App",
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
        ),
      ),
      body: FutureBuilder<List<Post>>(
          future: _userModel.getPostsOfActivities(widget.gelenActivity.id),
          builder: (context, postList) {
            if (!postList.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              var tumPosts = postList.data;
              if (tumPosts.length > 0) {
                return RefreshIndicator(
                  onRefresh: _kluplerListesiniYenile,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: tumPosts.length,
                    itemBuilder: (context, index) {
                      var oAnkiAktivite = postList.data[index];

                      return Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: double.infinity,

                              //height: 85,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 5),

                              child: Column(
                                children: [
                                  Container(
                                    //height: 400,
                                    child: Stack(children: <Widget>[
                                      Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 10.0),
                                            child: Container(
                                              // height: 60,
                                              color: Colors.white,
                                              width: double.infinity,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10, top: 5),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        CircleAvatar(
                                                          backgroundColor:
                                                              Colors.white,
                                                          backgroundImage: oAnkiAktivite
                                                                      .userPhotoUrl ==
                                                                  null
                                                              ? NetworkImage(
                                                                  "https://digitalpratix.com/wp-content/uploads/pexels-mentatdgt-1049622-365x365.jpg")
                                                              : NetworkImage(
                                                                  oAnkiAktivite
                                                                      .userPhotoUrl),
                                                          //NetworkImage(oAnkiKlup.photoUrl),
                                                          radius: 20,
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  oAnkiAktivite
                                                                      .userName,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontFamily:
                                                                        "Lobster",
                                                                    color: Colors
                                                                        .deepPurple,
                                                                    letterSpacing:
                                                                        1,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                CircleAvatar(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .grey,
                                                                  backgroundImage:
                                                                      AssetImage(
                                                                          "assets/images/blue_tick.png"),
                                                                  radius: 10,
                                                                )
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  oAnkiAktivite
                                                                          .dateTime
                                                                          .day
                                                                          .toString() +
                                                                      "/" +
                                                                      oAnkiAktivite
                                                                          .dateTime
                                                                          .month
                                                                          .toString() +
                                                                      "/" +
                                                                      oAnkiAktivite
                                                                          .dateTime
                                                                          .year
                                                                          .toString(),
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontFamily:
                                                                        "OpenSans",
                                                                    color: Colors
                                                                        .black,
                                                                    letterSpacing:
                                                                        1,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Text(
                                                                  oAnkiAktivite
                                                                          .dateTime
                                                                          .hour
                                                                          .toString() +
                                                                      ":" +
                                                                      oAnkiAktivite
                                                                          .dateTime
                                                                          .minute
                                                                          .toString(),
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontFamily:
                                                                        "OpenSans",
                                                                    color: Colors
                                                                        .black,
                                                                    letterSpacing:
                                                                        1,
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(20)),
                                              boxShadow: const [
                                                BoxShadow(
                                                    color: Colors.blueAccent,
                                                    blurRadius: 10,
                                                    offset: Offset(1, 1)),
                                              ],
                                              border: Border.all(
                                                  color: Colors.blueAccent,
                                                  width: 1),
                                              image: DecorationImage(
                                                  image: oAnkiAktivite
                                                              .photoUrl ==
                                                          null
                                                      ? NetworkImage(
                                                          "https://digitalpratix.com/wp-content/uploads/resimsec.png")
                                                      : NetworkImage(
                                                          oAnkiAktivite
                                                              .photoUrl),
                                                  fit: BoxFit.fill),
                                            ),
                                            height: 250.0,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    oAnkiAktivite.description,
                                                    maxLines: 3,
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: "Lobster",
                                                      color: Colors.deepPurple,
                                                      letterSpacing: 1,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 30,
                                          )
                                        ],
                                      ),
                                    ]),
                                  ),
                                ],
                              ),
                            ),
                          ],
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
                                Icons.flash_on,
                                color: Theme.of(context).primaryColor,
                                size: 80,
                              ),
                              Text(
                                "Henüz Gönderi Yok",
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
          }),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.deepPurple,
            child: CircleAvatar(
              backgroundImage: AssetImage("assets/images/plus.png"),
            ),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (context) => AddPostPage(
                            gelenActivity: widget.gelenActivity,
                          )))
                  .then((value) => {
              setState(() {})

              });
              // Navigator.push(context,MaterialPageRoute(builder: (context) => AddPostPage(gelenActivity: widget.gelenActivity,))).then((value) { setState(() {});
            },
          ),
          SizedBox(
            height: 60,
          )
        ],
      ),
    );
  }

  Future<Null> _kluplerListesiniYenile() async {
    setState(() {});
    await Future.delayed(Duration(seconds: 1));

    return null;
  }
}
