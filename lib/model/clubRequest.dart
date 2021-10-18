class ClubRequest {
  ClubRequest({
    this.status,
    this.clubId,
    this.userId,
    this.userName,
    this.clubName,
    this.userPhotoUrl,

  });

  ClubRequest.status({

    this.clubId,
    this.userId,
    this.userName,
    this.clubName,
    this.userPhotoUrl,

  });

  String status;
  String clubId;
  String userId;
  String userName;
  String clubName;
  String userPhotoUrl;


  factory ClubRequest.fromJson(Map<String, dynamic> json) => ClubRequest(
    status: json["status"],
    clubId: json["clubId"],
    userId: json["userId"],
    userName: json["userName"],
    clubName: json["clubName"],
    userPhotoUrl: json["userPhotoUrl"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "clubId": clubId,
    "userId": userId,
    "userName": userName,
    "clubName": clubName,
    "userPhotoUrl": userPhotoUrl,
  };
}
