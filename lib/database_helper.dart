import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'person.dart';

// Inicializar FFI según la plataforma
Future<void> initializeDatabase() async {
  if (kIsWeb) {
    // Para web, usar la implementación por defecto de sqflite
    // No necesita configuración adicional
    return;
  } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    // Para escritorio, inicializar FFI
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  // Para móvil (Android/iOS), sqflite funciona por defecto
}

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  static bool _isInitialized = false;

  DatabaseHelper._init();

  // Obtener instancia de base de datos (patrón singleton)
  Future<Database> get database async {
    if (_database != null) return _database!;

    // Inicializar solo una vez
    if (!_isInitialized) {
      await initializeDatabase();
      _isInitialized = true;
    }

    _database = await _initDB('personas.db');
    return _database!;
  }

  // Inicializar base de datos
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // Crear tablas de base de datos
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

  // Insertar una nueva persona en la base de datos
  Future<int> insertPerson(Person person) async {
    final db = await database;
    return await db.insert(
      'personas',
      person.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Obtener todas las personas de la base de datos
  Future<List<Map<String, dynamic>>> getPersons() async {
    final db = await database;
    return await db.query('personas', orderBy: 'id DESC');
  }

  // Eliminar una persona por ID
  Future<int> deletePerson(int id) async {
    final db = await database;
    return await db.delete('personas', where: 'id = ?', whereArgs: [id]);
  }
}
