import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:task2/UserModel.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper; // Singleton DatabaseHelper
  static Database _database; // Singleton Database

  String userModelTable = 'user_model_table';
  String colId = 'id';
  String colDisplayName = 'displayName';
  String colDescription = 'description';
  String colMeta = 'meta';

  DatabaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper
          ._createInstance(); // This is executed only once, singleton object
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'UserModel.db');

    // Open/create the database at a given path
    var userModelDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return userModelDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute('''
        CREATE TABLE $userModelTable
        ($colId INTEGER PRIMARY KEY AUTOINCREMENT,
         $colDisplayName TEXT,
        $colDescription TEXT, 
        $colMeta TEXT)''');
  }

  Future<List<Map<String, dynamic>>> getUserModelMapList() async {
    Database db = await this.database;

    var result = await db.query(userModelTable);
    return result;
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await this.database;
    return await db.query(userModelTable);
  }

  Future<int> insertNote(UserModel userModel) async {
    Database db = await this.database;
    var result = await db.insert(userModelTable, userModel.toMap());
    return result;
  }

  // Update Operation: Update a Note object and save it to database
  Future<int> updateNote(UserModel userModel) async {
    var db = await this.database;
    var result = await db.update(userModelTable, userModel.toMap(),
        where: '$colId = ?', whereArgs: [userModel.id]);
    return result;
  }

  // Delete Operation: Delete a Note object from database
  Future<int> deleteNote(int id) async {
    var db = await this.database;
    int result =
        await db.rawDelete('DELETE FROM $userModelTable WHERE $colId = $id');
    return result;
  }

  // Get number of Note objects in database
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $userModelTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'Note List' [ List<Note> ]
  Future<List<UserModel>> getNoteList() async {
    var noteMapList =
        await getUserModelMapList(); // Get 'Map List' from database
    int count =
        noteMapList.length; // Count the number of map entries in db table

    List<UserModel> noteList = List<UserModel>();
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      noteList.add(UserModel.fromMapObject(noteMapList[i]));
    }

    return noteList;
  }
}
