class CheckBoxListTileModel {
  int userId;
  String img;
  String title;
  bool isCheck;

  CheckBoxListTileModel({this.userId, this.img, this.title, this.isCheck});

  static List<CheckBoxListTileModel> getUsers() {
    return <CheckBoxListTileModel>[
      CheckBoxListTileModel(
          userId: 1,
          img: 'assets/images/1.png',
          title: "Yazılım",
          isCheck: false),
      CheckBoxListTileModel(
          userId: 2,
          img: 'assets/images/4.png',
          title: "Outdoor Sporları",
          isCheck: false),
      CheckBoxListTileModel(
          userId: 3,
          img: 'assets/images/3.png',
          title: "Müzik",
          isCheck: false),
      CheckBoxListTileModel(
          userId: 4,
          img: 'assets/images/2.png',
          title: "Görsel Tasarım",
          isCheck: false),



    ];
  }
}
