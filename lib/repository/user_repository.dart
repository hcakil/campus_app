
import 'package:campusapp/locator.dart';
import 'package:campusapp/model/user.dart';
import 'package:campusapp/service/auth_base.dart';
import 'package:campusapp/service/fake_auth_service.dart';
import 'package:campusapp/service/firebase_auth_service.dart';
import 'package:campusapp/service/firestore_db_service.dart';

//as timeago;

enum AppMode { DEBUG, RELEASE }

class UserRepository implements AuthBase {
  FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  FakeAuthenticationService _fakeAuthService =
  locator<FakeAuthenticationService>();
  FirestoreDBService _firestoreDBService = locator<FirestoreDBService>();
  //FirebaseStorageService _firestoreStorageService =
  //locator<FirebaseStorageService>();
/**/

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
  Future<MyUser> createUserWithSignInWithEmail(
      String email, String sifre,String interest) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.createUserWithSignInWithEmail(email, sifre,interest);
    } else {
      MyUser _user = await _firebaseAuthService.createUserWithSignInWithEmail(
          email, sifre,interest);
      print("$interest in repo");
      //return _user;
      bool _sonuc = await _firestoreDBService.saveUserWithEmailAndPassword(_user,interest);
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

  /*Future<bool> updateUserName(
      String degisecekUserID, String yeniUserName) async {
    if (appMode == AppMode.DEBUG) {
      return false;
    } else {
      return await _firestoreDBService.updateUserName(degisecekUserID, yeniUserName);
    }
  }*/

 /* Future<String> uploadFile(
      String userID, String fileType, File profilPhoto) async {
    if (appMode == AppMode.DEBUG) {
      return "dosya indirme linki";
    } else {
      var profilPhotoUrl = await _firestoreStorageService.uploadFile(
          userID, fileType, profilPhoto);

      await _firestoreDBService.updateProfilPhoto(userID, profilPhotoUrl);

      return profilPhotoUrl;
    }
  }*/

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
