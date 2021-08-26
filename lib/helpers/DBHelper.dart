import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DBHelper {
  static const String DB_NAME = 'lists.db';

  static Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
      path.join(dbPath, DBHelper.DB_NAME),
      onCreate: (db, version) => db.execute(
          'CREATE TABLE user_lists (id TEXT PRIMARY KEY NOT NULL, title TEXT NOT NULL, colorRGBO TEXT NOT NULL,iconName TEXT NOT NULL)'),
      version: 1,
    );
  }

  static Future<List<Map<String, dynamic>>> getLists() async {
    final db = await DBHelper.database();
    return db.query('user_lists');
  }

  static Future<void> insertNewList(Map<String, Object> data) async {
    final db = await DBHelper.database();
    //Insert a new list in the database
    db.insert(
      'user_lists',
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
    //Create a new table in the database

    var tablesList = await db.query('sqlite_master',
        where: 'name=?', whereArgs: ['list_${data['id']}']);
    if (tablesList.isEmpty) {
      db.execute(
        'CREATE TABLE [list_${data['id']}] (id TEXT PRIMARY KEY NOT NULL, title TEXT NOT NULL, description TEXT,dueDate TEXT,hasTimePassed INTEGER NOT NULL,wasTimeSet INTEGER)',
      );
    } else {}
  }

  static Future<void> deleteList(String id) async {
    final db = await DBHelper.database();
    db.delete('user_lists', where: 'id=?', whereArgs: [id]);
    db.execute('DROP TABLE IF EXISTS [list_$id]');
  }

  static Future<List<Map<String, dynamic>>> getListTasks(String listId) async {
    final db = await DBHelper.database();
    return db.query('[list_$listId]');
  }

  static Future<void> insertTaskInList(
      String listId, Map<String, Object?> data) async {
    final db = await DBHelper.database();
    db.insert(
      '[list_$listId]',
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<void> deleteTaskFromList(String listId, String taskId) async {
    final db = await DBHelper.database();
    db.delete('[list_$listId]', where: 'id=?', whereArgs: [taskId]);
  }
}
