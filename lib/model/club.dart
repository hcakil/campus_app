


class Club {
  Club({
    this.name,
    this.id,
    this.photoUrl,
    this.description,
    this.subtitle,
    this.interest,
   // this.activities,
  });

  String name;
  String id;
  String photoUrl;
  String description;
  String subtitle;
  String interest;
  //List<Activity> activities;

  factory Club.fromJson(Map<String, dynamic> json) => Club(
    name: json["name"],
    id: json["id"],
    subtitle: json["subtitle"],
    photoUrl: json["photoUrl"],
    description: json["description"],
    interest: json["interest"],
   // interests: List<Interest>.from(json["interests"].map((x) => Interest.fromJson(x))),
   // activities: List<Activity>.from(json["activities"].map((x) => Activity.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "subtitle": subtitle,
    "id": id,
    "photoUrl": photoUrl,
    "description": description,
    "interest": interest,
    //"interests": List<dynamic>.from(interests.map((x) => x.toJson())) ?? ["0"],
    //"activities": List<dynamic>.from(activities.map((x) => x.toJson())) ?? [],
  };
}
