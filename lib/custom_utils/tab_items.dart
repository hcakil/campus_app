import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum TabItem { Oneri, Kategoriler, Profil }

class TabItemData {
  final String title;
  final IconData icon;

  TabItemData(this.title, this.icon);

  static Map<TabItem, TabItemData> tumTablar = {
    TabItem.Oneri:
    TabItemData("Öneriler", Icons.supervised_user_circle),
    TabItem.Profil: TabItemData("Profil", Icons.person),
    TabItem.Kategoriler: TabItemData("Tüm Klüpler", Icons.category),
  };
}
