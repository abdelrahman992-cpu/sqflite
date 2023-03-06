import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'main.dart';

class SqlDb {
  static String DB_TABLE = 'notes';
  static Database? _db;
  static Future<Database?> get db async {
    if (_db == null) {
      _db = await initialDb();
      return db;
    } else {
      return _db;
    }
  }

  static initialDb() async {
    var databasepath = await getDatabasesPath();
    String path = await join(databasepath, 'wael.db');
    Database mydb = await openDatabase(path,
        onCreate: onCreate, version: 3, onUpgrade: onUpgrade);
    return mydb;
  }

  static onUpgrade(Database db, int oldversion, int newversion) async {
    print("upgrade on =============");
  }

  static onCreate(Database db, int version) async {
    await db.execute('''
CREATE TABLE notes(
  id INTEGER  NOT NULL PRIMARY KEY AUTOINCREMENT ,
  note TEXT NOT NULL
)

''');
    print("create DB");
  }

  static Future<List<Note>> readData() async {
    Database? mydb = await db;
    List<Map<String, dynamic>> _maps = await mydb!.query(DB_TABLE);
    print(_maps);
    List<Note> _list = [];
    if (_maps.isNotEmpty) {
      _maps.forEach((element) => _list.add(Note.fromJson(element)));
    }
    print(_list[0].note);
    return _list;
  }

  static insertData(Note note) async {
    Database? mydb = await db;
    int response = await mydb!.insert(
      DB_TABLE,
      note.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return response;
  }

  static updateData(Note note) async {
    Database? mydb = await db;

    await mydb!.update(
      DB_TABLE,
      note.toJson(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  static deleteData(int? id) async {
    Database? mydb = await db;
    await mydb!.delete(
      DB_TABLE,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  deleteAllItems() async {
    Database? mydb = await db;
    await mydb!.delete(DB_TABLE);
  }
}
