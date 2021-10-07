import 'package:flutter/material.dart';

class CategoryOffersPage extends StatefulWidget {
  @override
  _CategoryOffersPageState createState() => _CategoryOffersPageState();
}

class _CategoryOffersPageState extends State<CategoryOffersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        automaticallyImplyLeading: false,
        backgroundColor:  Colors.purple.shade600,
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
        ),),
      body: Container(child: Center(child: Text("offer page category  "),),),
    );
  }
}
