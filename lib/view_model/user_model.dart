import 'dart:io';

import 'package:campusapp/locator.dart';
import 'package:campusapp/model/activity.dart';
import 'package:campusapp/model/activityRequest.dart';
import 'package:campusapp/model/club.dart';
import 'package:campusapp/model/clubRequest.dart';
import 'package:campusapp/model/user.dart';
import 'package:campusapp/repository/user_repository.dart';
import 'package:campusapp/service/auth_base.dart';
import 'package:flutter/cupertino.dart';

enum ViewState { Idle, Busy }

class UserModel with ChangeNotifier implements AuthBase {
  ViewState _state = ViewState.Idle;
  UserRepository _userRepository = locator<UserRepository>();
  MyUser _user;
  Club _club;
  Activity _activity;
  String emailHataMesaji;
  String sifreHataMesaji;
  String requestResultForClub;

  MyUser get user => _user;

  ViewState get state => _state;

  set state(ViewState value) {
    _state = value;
    notifyListeners();
  }

  UserModel() {
    currentUser();
  }

  @override
  Future<MyUser> currentUser() async {
    try {
      state = ViewState.Busy;
      _user = await _userRepository.currentUser();
      if (_user != null) {
        return _user;
      } else
        return null;
    } catch (e) {
      debugPrint(" ViewModel deki current user hata " + e.toString());
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      state = ViewState.Busy;
      bool sonuc = await _userRepository.signOut();
      _user = null;
      return sonuc;
    } catch (e) {
      debugPrint(" ViewModel deki sign out user hata " + e);
      return false;
    } finally {
      state = ViewState.Idle;
    }
  }

  /* Future<List<User>> getAllUsers() async {
    var tumKullaniciListesi = await _userRepository.getAllUsers();
    return tumKullaniciListesi;
  }

  */
  @override
  Future<MyUser> createUserWithSignInWithEmail(
      String email, String sifre, String interest) async {
    //if (emailSifreKontrol(email, sifre)) {
    print("$interest  interest in user model");
    try {
      state = ViewState.Busy;
      _user = await _userRepository.createUserWithSignInWithEmail(
          email, sifre, interest);

      return _user;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<MyUser> signInWithEmailAndPassword(String email, String sifre) async {
    try {
      // if (emailSifreKontrol(email, sifre)) {
      state = ViewState.Busy;
      _user = await _userRepository.signInWithEmailAndPassword(email, sifre);
      return _user;
      /*  } else {
        return null;
      }*/
    } finally {
      state = ViewState.Idle;
    }
  }

  /*bool emailSifreKontrol(String email, String sifre) {
    var sonuc = true;
print("e mail şifre kontrole geşdi  -->"+email + "  "+sifre);
    if (sifre.length < 6) {
      sifreHataMesaji = "En az 6 karakter olmalıdır";
     // print(sifre.length.toString() +" şifre uzunluk");
      sonuc = false;
    } else {
      sifreHataMesaji = null;
    }
    if (!email.contains("@yeditepe.edu.tr")) {
      emailHataMesaji = "Lütfen geçerli bir öğrenci mail adresi giriniz";
     // print(email.length.toString() +" şifre uzunluk");
      sonuc = false;
    } else {
      emailHataMesaji = null;
    }

    return sonuc;
  }*/

  Future<bool> updateUserName(
      String degisecekUserID, String yeniUserName) async {
    var sonuc =
        await _userRepository.updateUserName(degisecekUserID, yeniUserName);
    if (sonuc) {
      _user.userName = yeniUserName;
    }

    return sonuc;
  }

  Future<String> uploadFile(
      String userID, String fileType, File profilPhoto) async {
    var indirmeLinki =
        await _userRepository.uploadFile(userID, fileType, profilPhoto);
    return indirmeLinki;
  }

  Future<bool> updateInterest(String userID, String newInterest) async {
    var sonuc = await _userRepository.updateInterest(userID, newInterest);
    if (sonuc) {
      _user.interest = newInterest;
    }
    return sonuc;
  }

  Future<List<Club>> getAllClubs() async {
    return await _userRepository.getAllClubs();
  }

  Future<List<Club>> getOfferedClubs(String intests) async {
    // print("$intests interest in model");
    return await _userRepository.getOfferedClubs(intests);
  }

  Future<String> uploadCategoryFile(
      String clubId, String fileType, File clubPhoto) async {
    try {
      var indirmeLinki =
          await _userRepository.uploadCategoryFile(clubId, fileType, clubPhoto);
      return indirmeLinki;
    } finally {
      state = ViewState.Idle;
    }
  }

  Future<Club> addClub(Club club) async {
    try {
      state = ViewState.Busy;
      _club = await _userRepository.createClub(club);
      return _club;
    } finally {
      // state = ViewState.Idle;
    }
  }

  Future<String> addRequestForClub(String clubId, String userId,
      String clubName, String userName, String userProfileUrl) async {
    try {
      // state = ViewState.Busy;
      //  print(" model  -->club id $clubId and user id $userId");
      requestResultForClub = await _userRepository.addRequestForClub(
          ClubRequest.status(
              clubId: clubId,
              userId: userId,
              userName: userName,
              userPhotoUrl: userProfileUrl,
              clubName: clubName));
      return requestResultForClub;
    } finally {
      // state = ViewState.Idle;
    }
  }

  Future<List<ClubRequest>> getAllClubRequests() async {
    return await _userRepository.getAllClubRequests();
  }

  Future<String> changeRequestTypeForClub(String clubId, String userId,
      String clubName, String userName, String userProfileUrl, String type) async{
    try {
      // state = ViewState.Busy;
      //  print(" model  -->club id $clubId and user id $userId");
      requestResultForClub = await _userRepository.changeRequestTypeForClub(type,
          ClubRequest.status(
              clubId: clubId,
              userId: userId,
              userName: userName,
              userPhotoUrl: userProfileUrl,
              clubName: clubName));
      return requestResultForClub;
    } finally {
      // state = ViewState.Idle;
    }
  }

  Future<List<ClubRequest>>  getAllApprovalClubRequests(String userID) async{
    return await _userRepository.getAllApprovalClubRequests(userID);
  }

  Future<Activity>  addActivity(Activity activity)async {
    try {
      state = ViewState.Busy;
      _activity = await _userRepository.createActivity(activity);
      return _activity;
    } finally {
      // state = ViewState.Idle;
    }
  }

  Future<String> uploadActivityFile(String activityId, String fileType, File activityPhoto) async{
    try {
      var indirmeLinki =
      await _userRepository.uploadCategoryFile(activityId, fileType, activityPhoto);
      return indirmeLinki;
    } finally {
      state = ViewState.Idle;
    }
  }

  Future<List<ActivityRequest>> getAllActivityRequests() async {
    return await _userRepository.getAllActivityRequests();
  }

/*Future<List<MyUser>> getUserWithPagination(
      MyUser enSonGetirilenUser, int getirilecekElemanSayisi) async {
    return await _userRepository.getUserWithPagination(
        enSonGetirilenUser, getirilecekElemanSayisi);
  }*/
}
