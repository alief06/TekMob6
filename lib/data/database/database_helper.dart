import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/report_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('laporcepat.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
CREATE TABLE reports (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  imagePath TEXT NOT NULL,
  latitude REAL NOT NULL,
  longitude REAL NOT NULL,
  createdAt TEXT NOT NULL,
  updatedAt TEXT NOT NULL
)
''');
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE reports ADD COLUMN updatedAt TEXT NOT NULL DEFAULT ""');
    }
  }

  Future<int> insertReport(Report report) async {
    final db = await instance.database;
    return await db.insert('reports', report.toMap());
  }

  Future<List<Report>> fetchAllReports() async {
    final db = await instance.database;
    final result = await db.query('reports', orderBy: 'createdAt DESC');
    return result.map((json) => Report.fromMap(json)).toList();
  }

  Future<int> updateReport(Report report) async {
    final db = await instance.database;
    return await db.update(
      'reports',
      report.toMap(),
      where: 'id = ?',
      whereArgs: [report.id],
    );
  }

  Future<int> deleteReport(int id) async {
    final db = await instance.database;
    return await db.delete(
      'reports',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
