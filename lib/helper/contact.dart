import 'dart:io';
import 'package:sql/model/contact_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databaseName = 'ContactData.db'; //database name
  static const _databaseVersion = 1; //database version

  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }
    return _database = await _initDatabase();
  }

  _initDatabase() async {
    Directory dataDirectory = await getApplicationDocumentsDirectory();

    String dbPath = join(dataDirectory.path, _databaseName);

    return await openDatabase(dbPath,
        version: _databaseVersion, onCreate: _onCreateDB);
  }

  _onCreateDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${Contact.tblContact}(
        ${Contact.colId} INTEGER PRIMARY KEY AUTOINCREMENT,  
        ${Contact.colName} TEXT NOT NULL,  
        ${Contact.colMobile} TEXT NOT NULL 
        ) 
      ''');
  }

  Future<int> insertContact(Contact contact) async {
    Database db = await database;
    return db.insert(Contact.tblContact, contact.toMap());
  }

  Future<List<Contact>> fetchContacts() async {
    Database db = await database;
    List<Map> contacts = await db.query(Contact.tblContact);
    return contacts.length == 0
        ? []
        : contacts.map((e) => Contact.formMap(e)).toList();
  }

  Future<List<Contact>> fetchContactsinSeq() async {
    Database db = await database;
    List<Map> contacts =
    await db.query(Contact.tblContact, orderBy: '${Contact.colName} ASC');//sort in ascending order
    return contacts.length == 0
        ? []
        : contacts.map((e) => Contact.formMap(e)).toList();
  }

  deletContact(int id) async {
    Database db = await database;
    return db.delete(
      Contact.tblContact,
      where: '${Contact.colId}=?',
      whereArgs: [id],
    );
  }
}

// flutter build apk --split-per-abi
