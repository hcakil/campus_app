class ActivityRequest {
  ActivityRequest({
    this.status,
    this.clubId,
    this.activityId,
    this.userId,
    this.userName,
    this.activityName,
    this.clubName,
    this.userPhotoUrl,

  });

  ActivityRequest.status({

    this.clubId,
    this.activityId,
    this.userId,
    this.userName,
    this.activityName,
    this.clubName,
    this.userPhotoUrl,

  });

  String status;
  String clubId;
  String activityId;
  String userId;
  String userName;
  String activityName;
  String clubName;
  String userPhotoUrl;





  factory ActivityRequest.fromJson(Map<String, dynamic> json) => ActivityRequest(
    status: json["status"],
    clubId: json["clubId"],
    userId: json["userId"],
    userName: json["userName"],
    activityId: json["activityId"],
    activityName: json["activityName"],
    clubName: json["clubName"],
    userPhotoUrl: json["userPhotoUrl"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "clubId": clubId,
    "userId": userId,
    "userName": userName,
    "activityId": activityId,
    "activityName": activityName,
    "clubName": clubName,
    "userPhotoUrl": userPhotoUrl,
  };
}
