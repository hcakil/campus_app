class Interest {
  Interest({
    this.id,
    this.name,
  });

  String id;
  String name;

  factory Interest.fromJson(Map<String, dynamic> json) => Interest(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
