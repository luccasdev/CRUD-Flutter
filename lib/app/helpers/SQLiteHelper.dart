import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:projeto1/app/models/dog.dart';

class SQLiteHelper {
  static final SQLiteHelper _instance = new SQLiteHelper.internal();

  factory SQLiteHelper() => _instance;

  final String tableDog = 'dog';
  final String columnId = 'id';
  final String columnTitle = 'name';
  final String columnDescription = 'description';

  static Database _db;

  SQLiteHelper.internal();

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();

    return _db;
  }

  initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'dog.db');

//    await deleteDatabase(path); // just for testing

    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $tableDog($columnId INTEGER PRIMARY KEY, $columnTitle TEXT, $columnDescription TEXT)');
  }

  Future<int> saveDog(Dog dog) async {
    var dbClient = await db;
    var result = await dbClient.insert(tableDog, dog.toMap());
//    var result = await dbClient.rawInsert(
//        'INSERT INTO $tableNote ($columnTitle, $columnDescription) VALUES (\'${note.title}\', \'${note.description}\')');

    return result;
  }

  Future<List> getAllDogs() async {
    var dbClient = await db;
    var result = await dbClient.query(tableDog, columns: [columnId, columnTitle, columnDescription]);
//    var result = await dbClient.rawQuery('SELECT * FROM $tableNote');

    return result.toList();
  }

  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(await dbClient.rawQuery('SELECT COUNT(*) FROM $tableDog'));
  }

  Future<Dog> getDog(int id) async {
    var dbClient = await db;
    List<Map> result = await dbClient.query(tableDog,
        columns: [columnId, columnTitle, columnDescription],
        where: '$columnId = ?',
        whereArgs: [id]);
//    var result = await dbClient.rawQuery('SELECT * FROM $tableNote WHERE $columnId = $id');

    if (result.length > 0) {
      return new Dog.fromMap(result.first);
    }

    return null;
  }

  Future<int> deleteDog(int id) async {
    var dbClient = await db;
    return await dbClient.delete(tableDog, where: '$columnId = ?', whereArgs: [id]);
//    return await dbClient.rawDelete('DELETE FROM $tableNote WHERE $columnId = $id');
  }

  Future<int> updateDog(Dog dog) async {
    var dbClient = await db;
    return await dbClient.update(tableDog, dog.toMap(), where: "$columnId = ?", whereArgs: [dog.id]);
//    return await dbClient.rawUpdate(
//        'UPDATE $tableNote SET $columnTitle = \'${note.title}\', $columnDescription = \'${note.description}\' WHERE $columnId = ${note.id}');
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}