import 'dart:io';

import 'package:campusapp/locator.dart';
import 'package:campusapp/model/club.dart';
import 'package:campusapp/model/user.dart';
import 'package:campusapp/repository/user_repository.dart';
import 'package:campusapp/service/auth_base.dart';
import 'package:flutter/cupertino.dart';

enum ViewState { Idle, Busy }

class UserModel with ChangeNotifier implements AuthBase {
  ViewState _state = ViewState.Idle;
  UserRepository _userRepository = locator<UserRepository>();
  MyUser _user;
  String emailHataMesaji;
  String sifreHataMesaji;

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


/*Future<List<MyUser>> getUserWithPagination(
      MyUser enSonGetirilenUser, int getirilecekElemanSayisi) async {
    return await _userRepository.getUserWithPagination(
        enSonGetirilenUser, getirilecekElemanSayisi);
  }*/
}
