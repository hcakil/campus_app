import 'package:campusapp/custom_utils/colors.dart';
import 'package:campusapp/model/activity.dart';
import 'package:campusapp/model/club.dart';
import 'package:flutter/material.dart';

class ActivityGeneralInfo extends StatelessWidget {
  ActivityGeneralInfo({Key key, this.gelenActivity}) : super(key: key);

  final Activity gelenActivity;

  final Shader linearGradient = LinearGradient(
    colors: <Color>[gradientStart, gradientEnd],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 350,
              child: Stack(children: <Widget>[

                Column(
                  children: [

                    Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        image: DecorationImage(
                            image: gelenActivity.photoUrl == null
                                ? NetworkImage(
                                    "https://digitalpratix.com/wp-content/uploads/resimsec.png")
                                : NetworkImage(gelenActivity.photoUrl),
                            fit: BoxFit.fill),
                      ),
                      height: 350.0,
                    ),
                  ],
                ),
                Container(
                  height: 350.0,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      gradient: LinearGradient(
                          begin: FractionalOffset.topCenter,
                          end: FractionalOffset.bottomCenter,
                          colors: [
                            Colors.grey.withOpacity(0.0),
                            Colors.white,
                          ],
                          stops: [
                            0.0,
                            1.0
                          ])),
                ),
                InkWell(
                  onTap: (){
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30,left: 10),
                    child: ClipRRect(
                      borderRadius: new BorderRadius.circular(10.0),
                      child: Image.asset('assets/images/left-arrow.png', height: 30, width: 30),
                    ),
                  ),
                ),
              ]),
            ),
            Container(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      gelenActivity.name, // "Club Name",
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
              ),
              height: 80,
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: gradientEnd,
                    offset: Offset(0.0, 1.0), //(x,y)
                    blurRadius: 6.0,
                  ),
                ],
                gradient: chatBubbleGradient,
                //borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Container(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Text(
                          gelenActivity.tagLine, // "Slogan Text",
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Lobster",
                              // color: Colors.white,
                              letterSpacing: 3,
                              foreground: Paint()..shader = linearGradient),
                        ),
                      ),
                    ],
                  ),
                ),
                height: 80,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Container(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Text(
                                gelenActivity.dateTime.day.toString() +
                                    "/" +
                                    gelenActivity.dateTime.month.toString() +
                                    "/" +
                                    gelenActivity.dateTime.year
                                        .toString(), // "Slogan Text",
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Lobster",
                                    // color: Colors.white,
                                    letterSpacing: 3,
                                    foreground: Paint()
                                      ..shader = linearGradient),
                              ),
                            ),
                            Container(
                              child: Text(
                                gelenActivity.dateTime.hour.toString() +
                                    " : " +
                                    gelenActivity.dateTime.minute.toString(),
                                // "Slogan Text",
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Lobster",
                                    // color: Colors.white,
                                    letterSpacing: 3,
                                    foreground: Paint()
                                      ..shader = linearGradient),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                height: 80,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Container(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 12, left: 5, right: 5, bottom: 12),
                        child: Text(
                          gelenActivity.description, // "Description Text",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: "OpenSans",
                            color: Colors.white,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // height: 350,
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepPurple,
                      offset: Offset(0.0, 1.0), //(x,y)
                      blurRadius: 6.0,
                    ),
                  ],
                  gradient: clubDescGradient,
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    ));
  }
}
