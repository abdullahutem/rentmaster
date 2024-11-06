import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Sqldb {
  static Database? _db;

  Future<Database?> get db async {
    if (_db == null) {
      _db =
          await initialSql(); // Use single equals sign to initialize the database
    }
    return _db;
  }

  initialSql() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'mydatabase.db');
    Database mydatabase = await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
    return mydatabase;
  }

  _onCreate(Database db, int version) async {
    Batch batch = db.batch();
// this the way to create mulitbale table
    batch.execute('''
    CREATE TABLE "users"(
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "name" TEXT NOT NULL,  
    "user_name" TEXT NOT NULL UNIQUE,  
    "email" TEXT NOT NULL,
    "phone_number" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "created_by" TEXT NOT NULL,
    "create_date" DATE NOT NULL,
    "updated_by" TEXT,
    "update_date" DATE
     )
    ''');
    batch.execute('''
    CREATE TABLE "real_state_type"(
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "name" TEXT NOT NULL,  
    "created_by" TEXT ,
    "create_date" DATE,
    "updated_by" TEXT,
    "update_date" DATE
     )
    ''');
   

    await batch.commit();
    print('Database and table created again ============');
  }

  _onUpgrade(Database db, int oldversion, int newversion) async {
  //   await db.execute(
  //      // "ALTER TABLE notes ADD COLUMN color TEXT"); // to add new column to the database whit out delele the database. but to active the code change the version code
}

  deleteMyDatabase() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'mydatabase.db');
    return await deleteDatabase(path);
  }

  selectData(String sql, List<dynamic> args) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.rawQuery(sql, args); 
    return response;
}

Future<List<Map<String,dynamic>>> selectRaw(String query) async {
    Database? mydb = await db;
    List<Map<String,dynamic>> response = await mydb!.rawQuery(query);
    return response;
  }


  insertData(String sql) async {
    Database? mydb = await db;
    int respone = await mydb!.rawInsert(sql);
    return respone;
  }

  updateData(String sql) async {
    Database? mydb = await db;
    int respone = await mydb!.rawUpdate(sql);
    return respone;
  }

  deleteData(String sql) async {
    Database? mydb = await db;
    int respone = await mydb!.rawDelete(sql);
    return respone;
  }

  select(String table) async {
    Database? mydb = await db;
    List<Map> respone = await mydb!.query(table);
    return respone;
  }

  insert(String table, Map<String, Object?> values) async {
    Database? mydb = await db;
    int respone = await mydb!.insert(table, values);
    return respone;
  }

  update(String table, Map<String, Object?> values, String mywhere) async {
    Database? mydb = await db;
    int respone = await mydb!.update(table, values, where: mywhere);
    return respone;
  }

  delete(String table, String mywhere) async {
    Database? mydb = await db;
    int respone = await mydb!.delete(table, where: mywhere);
    return respone;
  }
}