import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:path/path.dart';
import 'person.dart';

// Flag to track if FFI has been initialized
bool _ffiInitialized = false;

// Initialize FFI for different platforms
void initFfi() {
  if (_ffiInitialized) return;
  _ffiInitialized = true;

  // For web (not Windows, Linux, MacOS, iOS, or Android)
  if (!Platform.isWindows &&
      !Platform.isLinux &&
      !Platform.isMacOS &&
      !Platform.isIOS &&
      !Platform.isAndroid) {
    // Use web version
    databaseFactory = databaseFactoryFfiWeb;
    return;
  }

  // For desktop platforms
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
}

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('personas.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    // Initialize FFI for the appropriate platform
    initFfi();

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
CREATE TABLE personas(
id INTEGER PRIMARY KEY AUTOINCREMENT,
nombre TEXT NOT NULL,
apellido TEXT NOT NULL,
cedula TEXT NOT NULL,
edad INTEGER NOT NULL,
ciudad TEXT NOT NULL
)
''');
  }

  Future<int> insertPerson(Person person) async {
    final db = await database;
    return await db.insert(
      'personas',
      person.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getPersons() async {
    final db = await database;
    return await db.query('personas', orderBy: 'id DESC');
  }

  Future<int> deletePerson(int id) async {
    final db = await database;
    return await db.delete('personas', where: 'id = ?', whereArgs: [id]);
  }
}
