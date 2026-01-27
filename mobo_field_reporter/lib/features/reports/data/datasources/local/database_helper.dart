import 'package:injectable/injectable.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

@lazySingleton
class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('mobo_reports.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE reports (
        id TEXT PRIMARY KEY,
        title TEXT,
        description TEXT,
        date INTEGER,
        is_synchronized INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE evidences (
        id TEXT PRIMARY KEY,
        report_id TEXT NOT NULL,
        local_path TEXT,
        remote_url TEXT,
        type TEXT,
        status TEXT,
        FOREIGN KEY (report_id) REFERENCES reports (id) ON DELETE CASCADE
      )
    ''');
  }
}