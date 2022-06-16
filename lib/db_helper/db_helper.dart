import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static const todo = 'todo';

  static Future<Database> database() async {
    final dbPath = await getDatabasesPath();

    return await openDatabase(
      join(dbPath, 'todo.db'),
      onCreate: (db, version) {
        db.execute("""
        CREATE TABLE IF NOT EXISTS $todo(id TEXT PRIMARY KEY ,
            title TEXT ,
            description TEXT,
            date TEXT
            )""");
      },
      version: 1,
    );
  }

  static Future<List<Map<String, dynamic>>> selectAll(String table) async {
    final db = await DBHelper.database();

    //  without query
    return db.query(table);
    // with query
    // return db.rawQuery("""
    //   SELECT * FROM $to do
    // """);
  }

  static Future insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.database();

    return db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future update(
    String table,
    String columnName,
    String value,
    String id,
  ) async {
    final db = await DBHelper.database();

    return db.update(
      table,
      {
        columnName: value,
      },
      where: 'id = ? ',
      whereArgs: [id],
    );
  }

  static Future deleteById(
    String tableName,
    String columnName,
    String id,
  ) async {
    final db = await DBHelper.database();

    return db.delete(
      tableName,
      where: '$columnName = ?',
      whereArgs: [id],
    );
  }

  static Future deleteTable(String tableName) async {
    final db = await DBHelper.database();

    return db.rawQuery('''
      DELETE FROM $tableName
    ''');
  }

  static Future<List<Map<String, dynamic>>> searchList(
    String table,
    String title,
  ) async {
    final db = await DBHelper.database();

    return db.query(
      table,
      where: 'title = ?',
      whereArgs: [title],
    );
  }
}
