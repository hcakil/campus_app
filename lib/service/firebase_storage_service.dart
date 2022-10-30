import 'dart:io';
import 'dart:math';

import 'package:campusapp/model/post.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:campusapp/service/storage_base.dart';

class FirebaseStorageService implements StorageBase {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  firebase_storage.Reference _storageReference;
  String randomSayiUret() {
    int rastgeleSayi = Random().nextInt(999999);
    return rastgeleSayi.toString();
  }
  @override
  Future<String> uploadFile(
      String userID, String fileType, File yuklenecekDosya) async {

    var random= randomSayiUret();

    _storageReference = firebase_storage.FirebaseStorage.instance
        .ref()
        .child(userID)
        .child(fileType)
        .child(random+"profil_photo.png");

    firebase_storage.UploadTask uploadTask =
    _storageReference.putFile(yuklenecekDosya);
    firebase_storage.TaskSnapshot snapshot = await uploadTask;

    var url = await _storageReference.getDownloadURL();

    return url;
  }

  @override
  Future<String> uploadCategoryFile(String clubId, String fileType, File clubPhoto) async{

    if(fileType.contains("activity_photo"))
      {
        _storageReference = firebase_storage.FirebaseStorage.instance
            .ref()
            .child(clubId)
            .child(fileType)
            .child("activity_photo.png");

      }
    else{
      _storageReference = firebase_storage.FirebaseStorage.instance
          .ref()
          .child(clubId)
          .child(fileType)
          .child("club_photo.png");

    }


    firebase_storage.UploadTask uploadTask =
    _storageReference.putFile(clubPhoto);
    firebase_storage.TaskSnapshot snapshot = await uploadTask;

    var url = await _storageReference.getDownloadURL();

    return url;

  }

  Future<String> uploadPostFile(Post sonuc, String fileType, File postPhoto) async {

    //var userIdAndDateTime = sonuc.userId+sonuc.dateTime.toString();

      _storageReference = firebase_storage.FirebaseStorage.instance
          .ref()
          .child(sonuc.activityId)
          .child(fileType)
          .child(sonuc.postDocId);




    firebase_storage.UploadTask uploadTask =
    _storageReference.putFile(postPhoto);
    firebase_storage.TaskSnapshot snapshot = await uploadTask;

    var url = await _storageReference.getDownloadURL();

    return url;
  }
}
