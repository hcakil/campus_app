import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  Post({
    this.id,
    this.activityId,
    this.description,
    this.userId,
    this.userPhotoUrl,
    this.photoUrl,
    this.userName,
    this.postDocId,
    this.dateTime,
  });

  String id;
  String activityId;
  String description;
  String userId;
  String userPhotoUrl;
  String photoUrl;
  String userName;
  String postDocId;
  DateTime dateTime;

  factory Post.fromJson(Map<String, dynamic> json) => Post(
    id: json["id"],
    activityId: json["activityId"],
    description: json["description"],
    userId: json["userId"],
    userPhotoUrl: json["userPhotoUrl"],
    photoUrl: json["photoUrl"],
    userName: json["userName"],
    postDocId: json["postDocId"],
    dateTime: (json['dateTime'] as Timestamp).toDate() ,
    );




  Map<String, dynamic> toJson() => {
    "id": id,
    "activityId": activityId,
    "description": description,
    "userId": userId,
    "userPhotoUrl": userPhotoUrl ?? "",
    "photoUrl": photoUrl,
    "userName": userName,
    "postDocId": postDocId ?? "",
    "dateTime": dateTime ?? FieldValue.serverTimestamp(),
  };
}
