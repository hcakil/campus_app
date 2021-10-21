class Activity {
  Activity({
    this.id,
    this.description,
    this.tagLine,
    this.photoUrl,
    this.clubId,
    this.name,
    this.dateTime,
  });

  String id;
  String description;
  String tagLine;
  String photoUrl;
  String clubId;
  String name;
  DateTime dateTime;

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
      id: json["id"],
      description: json["description"],
      tagLine: json["tagLine"],
      photoUrl: json["photoUrl"],
      clubId: json["clubId"],
      name: json["name"],
      dateTime: DateTime.tryParse(json['dateTime']),
  );



  Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
        "tagLine": tagLine,
        "photoUrl": photoUrl,
        "clubId": clubId,
        "name": name,
        "dateTime": dateTime.toIso8601String(),
      };
}
