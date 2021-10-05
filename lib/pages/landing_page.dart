import 'package:campusapp/pages/category_offer_page.dart';
import 'package:campusapp/pages/home_page.dart';
import 'package:campusapp/view_model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserModel>(context);
    if(_userModel.state==ViewState.Idle){
      if(_userModel.user == null){
        //no Signed anybody
        return Home();
      }
      else{
        return CategoryOffer(user: _userModel.user,);
      }
    }
    else{return Scaffold(body: Center(child: CircularProgressIndicator(),),);}
  }
}
