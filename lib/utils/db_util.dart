import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import '../models/Visitor.dart';

class DbUtil {
  static DbUtil _dbUtil;
  static Database _database;

  String table = "visitors_list";
  String colId = 'id';
  String colVisitorName = 'visitor_name';
  String colPersonVisiting = 'person_visiting';
  String colPhoneNo = 'phone_number';
  String colTimeIn = 'time_in';
  String colTimeOut = 'time_out';
  String colDate = "date";

  DbUtil._createInstance(); // for singleton instance of the dbutil

  factory DbUtil() {
    // return an instance of the singleton util
    if (_dbUtil == null) {
      _dbUtil = DbUtil._createInstance();
    }
    return _dbUtil;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await _initDatabase();
    }
    return _database;
  }

  // initialize database
  Future<Database> _initDatabase() async {
    // path to where database is stored
    String path = join(await getDatabasesPath(), 'securitylogs.db');
    _database = await openDatabase(path, version: 1, onCreate: (db, version) {
      // create a new table if it doesn't exist
      db.execute(
          "create table $table($colId integer primary key autoincrement, $colVisitorName text, $colPersonVisiting text, $colPhoneNo text, $colTimeIn text, $colTimeOut text, $colDate text);");
    });
    return _database;
  }

  Future<List<Visitor>> getVisitorList() async {
    Database db = await database;
    List<Map<String, dynamic>> mapList =
        await db.query(table, orderBy: "$colTimeIn asc");

//    List<Visitor> visitors = new List<Visitor>();
//    mapList.forEach((visitor) {
//      visitors.add(Visitor.fromMapObject(visitor));
//    });

//    db.insert(table, {'visitor_name': 'Millo', 'person_visiting': 'Mys', ''});
//    db.delete(table);
//    debugPrint("List visitors: ${visitors[0].visitor_name}");

//    return visitors;
    return List<Visitor>.generate(mapList.length, (i) {
      return Visitor.fromMapObject(mapList[i]);
    });
  }

  Future<int> addVisitor(Visitor visitor) async {
    int result = await (await database).insert(table, visitor.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return result;
  }

  Future<int> updateVisitor(Visitor visitor) async =>
      await (await database).update(table, visitor.toMap(),
          where: "$colId = ?", whereArgs: [visitor.id]);

  Future<int> deleteVisitor(Visitor visitor) async => await (await database)
      .delete(table, where: "$colId = ?", whereArgs: [visitor.id]);
}
