

import 'package:campusapp/model/club.dart';
import 'package:campusapp/model/user.dart';
import 'package:campusapp/service/db_base.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreDBService implements DBBase {
  final FirebaseFirestore _firestoreDb = FirebaseFirestore.instance;
  //final FirebaseFirestore _firebaseDB = FirebaseFirestore.instance; bu böyle olmuş

  @override
  Future<bool> saveUserWithEmailAndPassword(MyUser user,String interest) async {
    user.interest=interest;
    DocumentSnapshot _okunanUser =
    await FirebaseFirestore.instance.doc("users/${user.userID}").get();

    if (_okunanUser.data() == null) {
      print("nullll");
      print(_okunanUser.toString());
      await _firestoreDb.collection("users").doc(user.userID).set(user.toMap());
      return true;
    } else {
      return true;
    }

    /* await _firestoreDb
        .collection("users")
        .document(user.userID)
        .setData(user.toMap());

    Map _okunanUserBilgileriMap = _okunanUser.data;
    MyUser _okunanUserBilgileriNesne = MyUser.fromMap(_okunanUserBilgileriMap);

    print("okunan user bilgileri " + _okunanUserBilgileriNesne.toString());
    return true;*/
  }

  @override
  Future<MyUser> readUser(String userID) async {
    DocumentSnapshot _okunanUser =
    await _firestoreDb.collection("users").doc(userID).get();

    Map<String, dynamic> _okunanUserBilgileriMap = _okunanUser.data();

    MyUser _okunanUserNesnesi = MyUser.fromMap(_okunanUserBilgileriMap);
    print("okuunan user nesnesi" + _okunanUserNesnesi.toString());
    return _okunanUserNesnesi;
  }

  @override
  Future<bool> updateUserName(String userID, String yeniUserName) async {
    var users = await _firestoreDb
        .collection("users")
        .where("userName", isEqualTo: yeniUserName)
        .get();
    if (users.docs.length >= 1) {
      return false;
    } else {
      await _firestoreDb
          .collection("users")
          .doc(userID)
          .update({"userName": yeniUserName});
      return true;
    }
  }

  @override
  Future<bool> updateProfilPhoto(String userID, String profilPhotoUrl) async {
    await _firestoreDb
        .collection("users")
        .doc(userID)
        .update({"profilURL": profilPhotoUrl});
    return true;
  }
  @override
  Future<bool> updateInterest(String userID, String newInterest) async{
    await _firestoreDb
        .collection("users")
        .doc(userID)
        .update({"interest": newInterest});
    return true;

  }


  @override
  Future<List<Club>> getAllClubs() async {
    QuerySnapshot querySnapshot = await _firestoreDb
        .collection("clubs")
        .get();

    List<Club> tumKlupler = [];


    for (DocumentSnapshot tekKlub in querySnapshot.docs) {
      Club _tekClub = Club.fromJson(tekKlub.data());
      tumKlupler.add(_tekClub);
     // test = ;
     // print("tek konusma  -----------> + ");
     // print(_tekClub.name);
    }
    return tumKlupler;
  }

  @override
  Future<List<Club>> getOfferedClubs(String interests) async {

    List<String> interestStringList = [];
    interestStringList = interests.split("");
    //print("$interests interest in firestoredb-----");
    //print(interestStringList);

    QuerySnapshot querySnapshot = await _firestoreDb
        .collection("clubs")
        .where("interest", whereIn: interestStringList)
        .get();

    //print(querySnapshot.size);
    //print("size query");

    List<Club> tumKlupler = [];


    for (DocumentSnapshot tekKlub in querySnapshot.docs) {
      Club _tekClub = Club.fromJson(tekKlub.data());
      tumKlupler.add(_tekClub);
      // test = ;
      // print("tek konusma  -----------> + ");
      // print(_tekClub.name);
    }
    return tumKlupler;
  }







/*
  @override
  Future<List<User>> getAllUser() async {
    QuerySnapshot querySnapshot =
        await _firestoreDb.collection("users").getDocuments();
    List<User> tumKullanicilar = [];
    for (DocumentSnapshot tekUser in querySnapshot.documents) {
      User _tekUser = User.fromMap(tekUser.data);
      tumKullanicilar.add(_tekUser);
    }

    //Map metodu ile
    // tumKullanicilar =querySnapshot.documents.map((tekSatir) => User.fromMap(tekSatir.data));

    return tumKullanicilar;
  }
*/


}
