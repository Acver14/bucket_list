import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:bucket_list/dataClass/bucketDataClass.dart';


final String _TABLE_NAME = 'BucketList';

initDB() async {
  Directory documentsDirectory = await getApplicationDocumentsDirectory();
  String path = join(documentsDirectory.path, 'MyBucketList.db');

  return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_TABLE_NAME(
            id INTEGER PRIMARY KEY,
            name TEXT,
            category TEXT,
            image TEXT,
            content TEXT,
            address TEXT,
            startDate INTEGER,
            closingDate INTEGER,
            achievementDate INTEGER,
            importance INTEGER
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion){}
  );
}

class DBHelper {

  DBHelper._();
  static final DBHelper _db = DBHelper._();
  factory DBHelper() => _db;

  static Database _database;

  Future<Database> get database async {
    if(_database != null) return _database;

    _database = await initDB();
    return _database;
  }

//Create
  createBucketFromDB(BucketClass bucket) async {
    final db = await database;
    var res = await db.rawInsert('INSERT INTO $TableName(name) VALUES(?)', [dog.name]);
    return res;
  }

//Read
  getBucketFromDB(int id) async {
    final db = await database;
    var res = await db.rawQuery('SELECT * FROM $TableName WHERE id = ?', [id]);
    return res.isNotEmpty ? Dog(id: res.first['id'], name: res.first['name']) : Null;
  }

//Read All
  Future<List<BucketClass>> getBucketLsitFromDB() async {
    final db = await database;
    var res = await db.rawQuery('SELECT * FROM $TableName');
    List<Dog> list = res.isNotEmpty ? res.map((c) => Dog(id:c['id'], name:c['name'])).toList() : [];

    return list;
  }

//Delete
  deleteBucketInDB(int id) async {
    final db = await database;
    var res = db.rawDelete('DELETE FROM $TableName WHERE id = ?', [id]);
    return res;
  }

//Delete All
  deleteBucketListInDB() async {
    final db = await database;
    db.rawDelete('DELETE FROM $TableName');
  }

//Update
  updateBucketInDB(BucketClass bucket) async {
    final db = await database;
    var res = db.rawUpdate('UPDATE $TableName SET name = ? WHERE = ?', [dog.name, dog.id]);
    return res;
  }
}