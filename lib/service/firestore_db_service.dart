import 'package:campusapp/model/activity.dart';
import 'package:campusapp/model/activityRequest.dart';
import 'package:campusapp/model/club.dart';
import 'package:campusapp/model/clubRequest.dart';
import 'package:campusapp/model/user.dart';
import 'package:campusapp/service/db_base.dart';
import 'package:campusapp/service/local_db_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreDBService implements DBBase {
  final FirebaseFirestore _firestoreDb = FirebaseFirestore.instance;
  DatabaseHelper databaseHelper =DatabaseHelper();
  //final FirebaseFirestore _firebaseDB = FirebaseFirestore.instance; bu böyle olmuş

  @override
  Future<bool> saveUserWithEmailAndPassword(
      MyUser user, String interest) async {
    user.interest = interest;
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
  Future<bool> updateInterest(String userID, String newInterest) async {
    await _firestoreDb
        .collection("users")
        .doc(userID)
        .update({"interest": newInterest});
    return true;
  }

  @override
  Future<List<Club>> getAllClubs() async {
    QuerySnapshot querySnapshot = await _firestoreDb.collection("clubs").get();

    List<Club> tumKlupler = [];
    databaseHelper.klupListeSil();
    for (DocumentSnapshot tekKlub in querySnapshot.docs) {
      Club _tekClub = Club.fromJson(tekKlub.data());
      tumKlupler.add(_tekClub);
      databaseHelper.klupEkle(_tekClub);
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

    List<Club> tumKlupler = [];



    //databaseHelper.klupListeSil();

    for (DocumentSnapshot tekKlub in querySnapshot.docs) {
      Club _tekClub = Club.fromJson(tekKlub.data());
      tumKlupler.add(_tekClub);
     // databaseHelper.klupEkle(_tekClub);
      // test = ;
      // print("tek konusma  -----------> + ");
      // print(_tekClub.name);
    }



    return tumKlupler;
  }

  @override
  Future<bool> updateCategoryPhoto(
      String clubId, String categoryPhotoUrl) async {
    await _firestoreDb
        .collection("clubs")
        .doc(clubId)
        .update({"photoUrl": categoryPhotoUrl});
    return true;
  }

  @override
  Future<bool> createClub(Club club) async {
    DocumentSnapshot _okunanClub =
        await FirebaseFirestore.instance.doc("clubs/${club.id}").get();

    if (_okunanClub.data() == null) {
      print("nullll");
      print(_okunanClub.toString());
      await _firestoreDb.collection("clubs").doc(club.id).set(club.toJson());
      return true;
    } else {
      return true;
    }
  }

  @override
  Future<Club> readClub(String id) async {
    DocumentSnapshot _okunanClub =
        await _firestoreDb.collection("clubs").doc(id).get();

    Map<String, dynamic> _okunanClubBilgileriMap = _okunanClub.data();

    Club _okunanClubNesnesi = Club.fromJson(_okunanClubBilgileriMap);
    print("okuunan club nesnesi" + _okunanClubNesnesi.toString());
    return _okunanClubNesnesi;
  }

  @override
  Future<ClubRequest> checkClubRequest(String clubId, String userId) async {
    DocumentSnapshot _okunanClubRequest =
        await _firestoreDb.collection("clubWaiting").doc(userId + clubId).get();
    print(_okunanClubRequest.data());
    // print("okunan Club Request");

    if (_okunanClubRequest.data() != null) {
      Map<String, dynamic> _okunanClubBilgileriMap = _okunanClubRequest.data();
      //  print("okunan Club Bilgileri Map");
      // print(_okunanClubBilgileriMap);
      ClubRequest _okunanClubNesnesi =
          ClubRequest.fromJson(_okunanClubBilgileriMap);
      //  print("okuunan club nesnesi" + _okunanClubNesnesi.toString());
      return _okunanClubNesnesi;
    } else
      return null;
  }

  @override
  Future<bool> addClubAttendantRequest(ClubRequest request) async {
    String userIdClubId = request.userId + request.clubId;
    print("firestore a geldi eklemek için");
    await _firestoreDb
        .collection("clubWaiting")
        .doc(userIdClubId)
        .set(request.toJson());
    return true;
  }

  Future<List<ClubRequest>> getAllClubRequests() async {
    QuerySnapshot querySnapshot =
        await _firestoreDb.collection("clubWaiting").get();

    List<ClubRequest> tumKlupIstekleri = [];

    for (DocumentSnapshot tekKlubIstegi in querySnapshot.docs) {
      ClubRequest _tekClub = ClubRequest.fromJson(tekKlubIstegi.data());
      if (_tekClub.status.contains("Waiting")) {
        tumKlupIstekleri.add(_tekClub);
      }
      // test = ;
      // print("tek konusma  -----------> + ");
      // print(_tekClub.name);
    }
    return tumKlupIstekleri;
  }

  Future<bool> changeRequestTypeForClub(ClubRequest clubRequest) async {
    String userIdClubId = clubRequest.userId + clubRequest.clubId;
    print("firestore a geldi eklemek için");
    await _firestoreDb
        .collection("clubWaiting")
        .doc(userIdClubId)
        .set(clubRequest.toJson());
    if (clubRequest.status.contains("Approved")) {
      await _firestoreDb
          .collection("clubAttendant")
          .doc(userIdClubId)
          .set(clubRequest.toJson());
      await _firestoreDb.collection("clubWaiting").doc(userIdClubId).delete();
    }

    return true;
  }

  Future<List<ClubRequest>> getAllApprovalClubRequests(String userID) async{
    QuerySnapshot querySnapshot =
    await _firestoreDb.collection("clubAttendant").get();

    List<ClubRequest> tumKlupIstekleri = [];

    for (DocumentSnapshot tekKlubIstegi in querySnapshot.docs) {
      ClubRequest _tekClub = ClubRequest.fromJson(tekKlubIstegi.data());
      if (_tekClub.userId.contains(userID)) {
        tumKlupIstekleri.add(_tekClub);
      }

    }
    return tumKlupIstekleri;
  }

  Future<bool>  createActivity(Activity activity) async{
    DocumentSnapshot _okunanActivity =
    await FirebaseFirestore.instance.doc("activities/${activity.id}").get();

    if (_okunanActivity.data() == null) {
      print("nullll");
      print(_okunanActivity.toString());
      await _firestoreDb.collection("activities").doc(activity.id).set(activity.toJson());
      return true;
    } else {
      return true;
    }
  }

  Future<Activity> readActivity(String id) async{
    DocumentSnapshot _okunanActivity =
    await _firestoreDb.collection("activities").doc(id).get();

    Map<String, dynamic> _okunanActivityBilgileriMap = _okunanActivity.data();

    Activity _okunanActivityNesnesi = Activity.fromJson(_okunanActivityBilgileriMap);
    print("okuunan club nesnesi" + _okunanActivityNesnesi.toString());
    return _okunanActivityNesnesi;
  }

  Future<bool>  updateActivityPhoto(String activityId, String categoryPhotoUrl) async{
    await _firestoreDb
        .collection("activities")
        .doc(activityId)
        .update({"photoUrl": categoryPhotoUrl});
    return true;
  }

  Future<List<ActivityRequest>> getAllActivityRequests() async{
    QuerySnapshot querySnapshot =
        await _firestoreDb.collection("activityWaiting").get();

    List<ActivityRequest> tumAktiviteIstekleri = [];

    for (DocumentSnapshot tekAktiviteIstegi in querySnapshot.docs) {
      ActivityRequest _tekActivity = ActivityRequest.fromJson(tekAktiviteIstegi.data());
      if (_tekActivity.status.contains("Waiting")) {
        tumAktiviteIstekleri.add(_tekActivity);
      }
      // test = ;
      // print("tek konusma  -----------> + ");
      // print(_tekClub.name);
    }
    return tumAktiviteIstekleri;
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
