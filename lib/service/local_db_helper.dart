import 'package:campusapp/model/club.dart';
import 'package:path/path.dart';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  factory DatabaseHelper(){
    if(_databaseHelper == null){
      _databaseHelper = DatabaseHelper._internal();
      return _databaseHelper;
    }else{
      return _databaseHelper;
    }
  }

  DatabaseHelper._internal();



  Future<Database> _getDatabase() async{
    if(_database == null){
      _database = await _initializeDatabase();
      return _database;
    }else{
      return _database;
    }
  }


  Future<Database> _initializeDatabase() async {

    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "campus_app_db.db");

// Check if the database exists
    var exists = await databaseExists(path);

    if (!exists) {
      // Should happen only the first time you launch your application
      print("Creating new copy from asset");

      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      ByteData data = await rootBundle.load(join("assets/db", "campus_app_db.db"));
      List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);

    } else {
      print("Opening existing database");
    }
// open the database
    return await openDatabase(path, readOnly: false);

  }

  Future<int> klupEkle(Club club) async{
    var db= await _getDatabase();
    var sonuc = await db.insert("clubs", club.toJson());
    return sonuc;
  }

  Future<void> klupListeSil() async{
    var db= await _getDatabase();
    var sonuc = await db.delete("clubs");
    return sonuc;
  }

  Future<List<Map<String,dynamic>>> klupleriGetir() async{
    var db= await _getDatabase();
    var sonuc = await db.query("clubs");
    print(sonuc);
    return sonuc;
  }

  Future<List<Club>> klupListesiniGetir() async{

    var klupleriIcerenMapListesi = await klupleriGetir();
    var klupListesi = List<Club>();
    for(Map map in klupleriIcerenMapListesi){
      klupListesi.add(Club.fromJson(map));
    }
    return klupListesi;

  }


}
