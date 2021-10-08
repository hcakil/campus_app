class Activity {
  Activity({
    this.id,
    this.description,
    this.photoUrl,
    this.clubId,
    this.name,
  });

  String id;
  String description;
  String photoUrl;
  String clubId;
  String name;

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
    id: json["id"],
    description: json["description"],
    photoUrl: json["photoUrl"],
    clubId: json["clubId"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "description": description,
    "photoUrl": photoUrl,
    "clubId": clubId,
    "name": name,
  };
}
