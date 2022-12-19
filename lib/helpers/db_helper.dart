import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'expenses.db'),
        onConfigure: (db) async {
          await db.execute('PRAGMA foreign_keys = ON');
        },
        onCreate: (db, version) async{
          await db.execute(
              'CREATE TABLE user_expenses(id TEXT PRIMARY KEY, title TEXT, amount INTEGER, date TEXT)');
          await db.execute('CREATE TABLE user_shopping_list(id TEXT PRIMARY KEY, '
              '             title TEXT, status INTEGER, groupId TEXT,'
              '             FOREIGN KEY (groupId) REFERENCES user_groups (id) ON DELETE CASCADE ON UPDATE CASCADE)');
          await db.execute('CREATE TABLE user_groups(id TEXT PRIMARY KEY, name TEXT)');
        }, version: 1);
    // var raw = await db.execute("CREATE TABLE MarketInfoes ("
    //     "id integer primary key, userId integer, typeId integer,"
    //     "gradeId integer, price DOUBLE"
    //     "FOREIGN KEY (typeId) REFERENCES Type (id) ON DELETE NO ACTION ON UPDATE NO ACTION,"
    //     "FOREIGN KEY (userId) REFERENCES User (id) ON DELETE NO ACTION ON UPDATE NO ACTION,"
    //     "FOREIGN KEY (gradeId) REFERENCES Grade (id) ON DELETE NO ACTION ON UPDATE NO ACTION"
    //     ")");
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.database();
    db.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, Object>>> getData(String table) async {
    final db = await DBHelper.database();
    return db.query(table);
  }

  static Future<void> editData(String table, String id, String title, int amount,
      String date) async {
    final db = await DBHelper.database();
    db.rawUpdate('UPDATE user_expenses SET title = ?, amount = ?, date = ? WHERE id = ?',
        [title, amount, date, id]);
  }

  static Future<void> deleteData(String table, String id) async {
    final db = await DBHelper.database();
//    db.delete(table, where: '$id = ?', whereArgs: [id]);
    db.rawDelete('DELETE FROM user_expenses WHERE id=?', [id]);
  }

  static Future<Database> shoppingDatabase() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'shopping.db'),
        onCreate: (db, version) {
          return db.execute(
              'CREATE TABLE shopping_list(title TEXT PRIMARY KEY, value INTEGER)');
        }, version: 1);
  }

  static Future<List<Map<String, Object>>> getShoppingData(String table) async {
    print("here");
    final db = await DBHelper.shoppingDatabase();
    print("there");
    return db.query(table);
  }

  static Future<void> shoppingInsert(String table, Map<String, Object> data) async {
    final db = await DBHelper.shoppingDatabase();
    db.insert(
      table,
      {'title': 'the', 'value': 0},
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<void> editItemData(String table, String id, String title, int status) async {
    print("reached inside db edit item");
    final db = await DBHelper.database();
    db.rawUpdate('UPDATE user_shopping_list SET title = ?, status = ? WHERE id = ?',
        [title, status, id]);
  }

  static Future<void> deleteItemData(String table, String id) async {
    final db = await DBHelper.database();
    db.rawDelete('DELETE FROM user_shopping_list WHERE id=?', [id]);
  }

  static Future<void> editGroupData(String table, String id, String name) async {
    final db = await DBHelper.database();
    db.rawUpdate('UPDATE user_groups SET name = ? WHERE id = ?',
        [name, id]);
  }

  static Future<void> deleteGroupData(String table, String id) async {
    final db = await DBHelper.database();
    db.rawDelete('DELETE FROM user_groups WHERE id=?', [id]);
  }

  static Future<void> editShoppingData(String table, String id, int amount) async {
    final db = await DBHelper.database();
    db.rawUpdate('UPDATE user_expenses SET amount = ? WHERE id = ?',
        [amount, id]);
  }

  static Future<void> deleteShoppingData(String table, String title) async {
    final db = await DBHelper.shoppingDatabase();
    db.rawDelete('DELETE FROM shopping_list WHERE title=?', [title]);
  }
}
