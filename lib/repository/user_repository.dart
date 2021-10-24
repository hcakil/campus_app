import 'dart:io';

import 'package:campusapp/locator.dart';
import 'package:campusapp/model/activity.dart';
import 'package:campusapp/model/activityRequest.dart';
import 'package:campusapp/model/club.dart';
import 'package:campusapp/model/clubRequest.dart';
import 'package:campusapp/model/user.dart';
import 'package:campusapp/service/auth_base.dart';
import 'package:campusapp/service/fake_auth_service.dart';
import 'package:campusapp/service/firebase_auth_service.dart';
import 'package:campusapp/service/firebase_storage_service.dart';
import 'package:campusapp/service/firestore_db_service.dart';
import 'package:campusapp/service/local_db_helper.dart';

//as timeago;

enum AppMode { DEBUG, RELEASE }

class UserRepository implements AuthBase {
  FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  FakeAuthenticationService _fakeAuthService =
  locator<FakeAuthenticationService>();
  FirestoreDBService _firestoreDBService = locator<FirestoreDBService>();
  FirebaseStorageService _firestoreStorageService =
  locator<FirebaseStorageService>();
  DatabaseHelper databaseHelper = DatabaseHelper();


  AppMode appMode = AppMode.RELEASE;
  List<MyUser> tumKullaniciListesi = [];
  Map<String, String> kullaniciToken = Map<String, String>();

  @override
  Future<MyUser> currentUser() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.currentUser();
    } else {
      MyUser _user = await _firebaseAuthService.currentUser();
      if (_user != null) {
        return await _firestoreDBService.readUser(_user.userID);
      } else
        return null;
    }
  }

  @override
  Future<bool> signOut() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signOut();
    } else {
      return await _firebaseAuthService.signOut();
    }
  }

  @override
  Future<MyUser> createUserWithSignInWithEmail(String email, String sifre,
      String interest) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.createUserWithSignInWithEmail(
          email, sifre, interest);
    } else {
      MyUser _user = await _firebaseAuthService.createUserWithSignInWithEmail(
          email, sifre, interest);
      print("$interest in repo");
      //return _user;
      bool _sonuc = await _firestoreDBService.saveUserWithEmailAndPassword(
          _user, interest);
      if (_sonuc) {
        return await _firestoreDBService.readUser(_user.userID);
      } else {
        return null;
      }
    }
  }

  @override
  Future<MyUser> signInWithEmailAndPassword(String email, String sifre) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signInWithEmailAndPassword(email, sifre);
    } else {
      MyUser _user =
      await _firebaseAuthService.signInWithEmailAndPassword(email, sifre);

//return _user;
      return await _firestoreDBService.readUser(_user.userID);
    }
  }

  Future<bool> updateUserName(String degisecekUserID,
      String yeniUserName) async {
    if (appMode == AppMode.DEBUG) {
      return false;
    } else {
      return await _firestoreDBService.updateUserName(
          degisecekUserID, yeniUserName);
    }
  }

  Future<String> uploadFile(String userID, String fileType,
      File profilPhoto) async {
    if (appMode == AppMode.DEBUG) {
      return "dosya indirme linki";
    } else {
      var profilPhotoUrl = await _firestoreStorageService.uploadFile(
          userID, fileType, profilPhoto);

      await _firestoreDBService.updateProfilPhoto(userID, profilPhotoUrl);

      //buraya da club ve activity wating varsa onları da ekleyelim
    //  await _firestoreDBService.updateProfilPhotoFromRequests(userID, profilPhotoUrl);

      return profilPhotoUrl;
    }
  }

  Future<bool> updateInterest(String userID, String newInterest) async {
    if (appMode == AppMode.DEBUG) {
      return false;
    } else {
      return await _firestoreDBService.updateInterest(userID, newInterest);
    }
  }

  Future<List<Club>> getAllClubs() async {
    if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      //DateTime _zaman = await _firestoreDBService.saatiGoster(userID);

      // return await _firestoreDBService.getAllConversations(userID);
      var klupListesi =
      await _firestoreDBService.getAllClubs();

      return klupListesi;
    }
  }

  Future<List<Club>> getOfferedClubs(String interests) async {
    if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      //DateTime _zaman = await _firestoreDBService.saatiGoster(userID);
      // print("$interests interest in repo");
      // return await _firestoreDBService.getAllConversations(userID);
      var klupListesi =
      await _firestoreDBService.getOfferedClubs(interests);

      return klupListesi;
    }
  }

  Future<String> uploadCategoryFile(String clubId, String fileType,
      File clubPhoto) async {
    if (appMode == AppMode.DEBUG) {
      return "dosya indirme linki";
    } else {
      var categoryPhotoUrl = await _firestoreStorageService.uploadCategoryFile(
          clubId, fileType, clubPhoto);

      if(fileType.contains("activity_photo"))
        {
          await _firestoreDBService.updateActivityPhoto(clubId, categoryPhotoUrl);
        }
      else{
        await _firestoreDBService.updateCategoryPhoto(clubId, categoryPhotoUrl);
      }


      return categoryPhotoUrl;
    }
  }

  @override
  Future<Club> createClub(Club club) async {
    //return _user;
    bool _sonuc = await _firestoreDBService.createClub(
        club);
    print("$_sonuc in repo");

    databaseHelper.klupEkle(club);
    if (_sonuc) {
      return await _firestoreDBService.readClub(club.id);
    } else {
      return null;
    }
  }

  Future<String> addRequestForClub(ClubRequest clubRequest) async {

   // print(" repo  -->club id  and user id ");
    print(clubRequest.clubName);
    ClubRequest _sonuc = await _firestoreDBService.checkClubRequest(
        clubRequest.clubId, clubRequest.userId);

   // print("$_sonuc in repo");
    if (_sonuc == null) {
      print("Klüp isteği yoktu eklenecek");
      var eklemeSonucu = await _firestoreDBService.addClubAttendantRequest(
          ClubRequest(clubId: clubRequest.clubId,userId: clubRequest.userId,
              status: "Waiting",userName: clubRequest.userName,
          clubName: clubRequest.clubName,userPhotoUrl: clubRequest.userPhotoUrl));
      if (eklemeSonucu)
        return "Added";
      else
        return "Hata";
    } else {
      print("KLÜP İSTEĞİ VAR VE DURUMU KONTROL EDİLECEK");
      return _sonuc.status;
    }
  }

  Future<List<ClubRequest>> getAllClubRequests() async{
    if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      //DateTime _zaman = await _firestoreDBService.saatiGoster(userID);

      // return await _firestoreDBService.getAllConversations(userID);
      var klupListesi =
      await _firestoreDBService.getAllClubRequests();

      return klupListesi;
    }
  }

  Future<String> changeRequestTypeForClub(String type, ClubRequest clubRequest) async {
    // print(" repo  -->club id  and user id ");
    print(clubRequest.clubName);
    print("type $type");
   /* ClubRequest _sonuc = await _firestoreDBService.checkClubRequest(
        clubRequest.clubId, clubRequest.userId);*/

      var eklemeSonucu = await _firestoreDBService.changeRequestTypeForClub(
          ClubRequest(clubId: clubRequest.clubId,userId: clubRequest.userId,
              status: type,userName: clubRequest.userName,
              clubName: clubRequest.clubName,userPhotoUrl: clubRequest.userPhotoUrl));
      if (eklemeSonucu)
        return type;
      else
        return "Hata";


  }

  Future<List<ClubRequest>>  getAllApprovalClubRequests(String userID) async{
    if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      //DateTime _zaman = await _firestoreDBService.saatiGoster(userID);

      // return await _firestoreDBService.getAllConversations(userID);
      var klupListesi =
      await _firestoreDBService.getAllApprovalClubRequests(userID);

      return klupListesi;
    }
  }

  Future<Activity>  createActivity(Activity activity) async{
    bool _sonuc = await _firestoreDBService.createActivity(
        activity);
    print("$_sonuc in repo");

    //databaseHelper.klupEkle(club);
    if (_sonuc) {
      return await _firestoreDBService.readActivity(activity.id);
    } else {
      return null;
    }

  }

  Future<List<ActivityRequest>> getAllActivityRequests() async {
    if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      //DateTime _zaman = await _firestoreDBService.saatiGoster(userID);

      // return await _firestoreDBService.getAllConversations(userID);
      var klupListesi =
      await _firestoreDBService.getAllActivityRequests();

      return klupListesi;
    }

  }


/* Future<List<User>> getAllUsers() async {
    if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      tumKullaniciListesi = await _firestoreDBService.getAllUser();
      return tumKullaniciListesi;
    }
  }*/
/*
  Stream<List<Mesaj>> getMessages(
      String currentUserID, String sohbetEdilenKisiUserID) {
    if (appMode == AppMode.DEBUG) {
      return Stream.empty();
    } else {
      return _firestoreDBService.getMessages(
          currentUserID, sohbetEdilenKisiUserID);
    }
  }

  Future<bool> saveMessage(Mesaj kaydedilecekMesaj, MyUser currentUser) async {
    if (appMode == AppMode.DEBUG) {
      return true;
    } else {
      var dbYazmaIslemi =
      await _firestoreDBService.saveMessages(kaydedilecekMesaj);
      if (dbYazmaIslemi) {
        var token = "";
        if (kullaniciToken.containsKey(kaydedilecekMesaj.kime)) {
          token = kullaniciToken[kaydedilecekMesaj.kime];
          print("localden geldi  " + token);
        } else {
          token = await _firestoreDBService.tokenGetir(kaydedilecekMesaj.kime);
          if (token != null) {
            kullaniciToken[kaydedilecekMesaj.kime] = token;
          }
          print("vt den geldi  " + token);
        }
        if (token != null) {
          await _notificationSendService.bildirimGonder(
              kaydedilecekMesaj, currentUser, token);
        }
        return true;
      } else {
        return false;
      }
    }
  }

  Future<List<Konusma>> getAllConversations(String userID) async {
    if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      DateTime _zaman = await _firestoreDBService.saatiGoster(userID);

      // return await _firestoreDBService.getAllConversations(userID);
      var konusmaListesi =
      await _firestoreDBService.getAllConversations(userID);

      for (var oAnkiKonusma in konusmaListesi) {
        var userListesindekiKullanici =
        listedeUserBul(oAnkiKonusma.kimle_konusuyor);

        if (userListesindekiKullanici != null) {
          print("VERILER CACHE DEN OKUNUYOR ile gidip okuyuruz/n");
          oAnkiKonusma.konusulanUserName = userListesindekiKullanici.userName;
          oAnkiKonusma.konusulanUserProfilURL =
              userListesindekiKullanici.profilURL;
        } else {
          print("firebase ile gidip okuyuruz/n");
          var _veritabanindanOkunanUser =
          await _firestoreDBService.readUser(oAnkiKonusma.kimle_konusuyor);
          print("data -- >" + _veritabanindanOkunanUser.userName);
          oAnkiKonusma.konusulanUserName = _veritabanindanOkunanUser.userName;
          oAnkiKonusma.konusulanUserProfilURL =
              _veritabanindanOkunanUser.profilURL;
        }
        timeagoHesapla(oAnkiKonusma, _zaman);
      }
      return konusmaListesi;
    }
  }

  MyUser listedeUserBul(String userID) {
    for (int i = 0; i < tumKullaniciListesi.length; i++) {
      if (tumKullaniciListesi[i].userID == userID) {
        return tumKullaniciListesi[i];
      }
    }
    print("kullanici yok");
    return null;
  }

  Konusma timeagoHesapla(Konusma oAnkiKonusma, DateTime zaman) {
    oAnkiKonusma.sonOkunmaZamani = zaman;
    timeago.setLocaleMessages('tr', timeago.TrMessages());
    var _duration = zaman.difference(oAnkiKonusma.olusturulma_tarihi.toDate());
    oAnkiKonusma.aradakiFark =
        timeago.format(zaman.subtract(_duration), locale: "tr");
    return oAnkiKonusma;
  }

  Future<List<MyUser>> getUserWithPagination(
      MyUser enSonGetirilenUser, int getirilecekElemanSayisi) async {
    if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      List<MyUser> _userList = await _firestoreDBService.getUserWithPagination(
          enSonGetirilenUser, getirilecekElemanSayisi);

      tumKullaniciListesi.addAll(_userList);

      return _userList;
    }
  }

*/
}
