import 'dart:math';
import 'package:flutter/material.dart';

class MyUser {
  final String userID;
  String email;
  String userName;
  String profilURL;
 // DateTime createdAt;
 // DateTime updatedAt;
  int seviye;

  MyUser({this.userID, this.email});

  MyUser.name(
      {this.userID,
        this.email,
        this.userName,
        this.profilURL,
      //  this.createdAt,
       // this.updatedAt,
        this.seviye});

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'email': email,
      'userName':
      userName ?? email.substring(0, email.indexOf("@")) + randomSayiUret(),
      'profilURL': profilURL ??
          'https://firebasestorage.googleapis.com/v0/b/pratixmessage.appspot.com/o/oVQCiC7VJYU11tLIRYNBa9Q10Ie2%2Fprofil_photo%2Fprofil_photo.png?alt=media&token=8a831d8b-9fff-4b5b-9d22-5864bdcd31f1',
    //  'createdAt': createdAt ?? "",//FieldValue.serverTimestamp(),
     // 'updatedAt': updatedAt ?? "", //FieldValue.serverTimestamp(),
      'seviye': seviye ?? 1,
    };
  }

  MyUser.fromMap(Map<String, dynamic> map)
      : userID = map["userID"],
        userName = map["userName"],
        email = map["email"],
        //createdAt = (map["createdAt"] as Timestamp).toDate(),
       // updatedAt = (map["updatedAt"] as Timestamp).toDate(),
        profilURL = map["profilURL"],
        seviye = map["seviye"];

 // MyUser.idVeResim({this.userID, this.profilURL});

  @override
  String toString() {
    return 'User{userID: $userID, email: $email, userName: $userName, profilURL: $profilURL,  seviye: $seviye}';
  }

  String randomSayiUret() {
    int rastgeleSayi = Random().nextInt(999999);
    return rastgeleSayi.toString();
  }
}
