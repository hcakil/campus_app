import 'package:campusapp/model/user.dart';
import 'package:flutter/material.dart';

class CategoryOffer extends StatefulWidget {
  final MyUser user;
  CategoryOffer({Key key, this.user}) : super(key: key);


  @override
  _CategoryOfferState createState() => _CategoryOfferState();
}

class _CategoryOfferState extends State<CategoryOffer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Campus App"),),
      body: Container(child: Center(child: Text("Hosgeldinir  "),),),
    );
  }
}
