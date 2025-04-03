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
    // Insert initial values into the "users" table
    batch.execute('''
    INSERT INTO "users" ("name","user_name","email","phone_number","password","created_by","create_date") VALUES 
    ('ppp','ppp','pppp','000000000','000000','ppp','2/2/2024')
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

    // Insert initial values into the "real_state_type" table
    batch.execute('''
    INSERT INTO "real_state_type" ("name") VALUES 
    ('عمارة'),
    ('شقة'),
    ('فلة'),
    ('حوش')
''');

    batch.execute('''
    CREATE TABLE "real_state"(
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "name" TEXT NOT NULL,  
    "type_id" INTEGER NOT NULL,  
    "is_rentable" INTEGER NOT NULL,  
    "rent_status" INTEGER ,  
    "parent_id" INTEGER,  
    "price" INTEGER,  
    "currency_id" INTEGER,  
    "description" TEXT ,
    "location_id" INTEGER, 
    "created_by" TEXT ,
    "create_date" DATE,
    "updated_by" TEXT,
    "update_date" DATE
     )
    ''');

    batch.execute('''
CREATE TRIGGER IF NOT EXISTS set_parent_id
AFTER INSERT ON real_state
FOR EACH ROW
BEGIN
  UPDATE real_state
  SET parent_id = NEW.id
  WHERE NEW.is_rentable = 1 AND id = NEW.id;
END;
''');

    // Create the "currency" table
    batch.execute('''
    CREATE TABLE "currency"(
      "id" INTEGER PRIMARY KEY AUTOINCREMENT,
      "name" TEXT NOT NULL,  
      "currency_code" TEXT NOT NULL,
      "symbol" TEXT NOT NULL
    )
  ''');

    // Insert initial values into the "currency" table
    batch.execute('''
    INSERT INTO "currency" ("name", "currency_code", "symbol") VALUES 
   ('ريال يمني', 'YER', ' ﷼ يمني'),
    ('ريال سعودي', 'SAR', '﷼ سعودي'),
    ('دولار أمريكي', 'USD', "\$") 
  ''');

    // Create the "currency" table
    batch.execute('''
    CREATE TABLE "owners"(
      "id" INTEGER PRIMARY KEY AUTOINCREMENT,
      "name" TEXT NOT NULL,  
      "created_by" TEXT ,
      "create_date" DATE,
      "updated_by" TEXT,
      "update_date" DATE
    )
  ''');

    // Insert initial values into the "Owner" table
    batch.execute('''
    INSERT INTO "owners" ("name", "created_by") VALUES ('defulte','defulte')
  ''');

    // Create the "services" table
    batch.execute('''
    CREATE TABLE "services"(
      "id" INTEGER PRIMARY KEY AUTOINCREMENT,
      "name" TEXT NOT NULL
    )
''');

// Insert initial values into the "services" table
    batch.execute('''
    INSERT INTO "services" ("name") VALUES 
    ('نظافة'),
    ('ماء'),
    ('كهرباء'),
    ('صيانة')
''');

    // Create the "tenants" table
    batch.execute('''
    CREATE TABLE "tenants"(
      "id" INTEGER PRIMARY KEY AUTOINCREMENT,
      "name" TEXT NOT NULL,  
      "phone_number" TEXT NOT NULL,  
      "created_by" TEXT ,
      "create_date" DATE,
      "updated_by" TEXT,
      "update_date" DATE
    )
  ''');

    // Create the "currency" table
    batch.execute('''
    CREATE TABLE "rent_type"(
      "id" INTEGER PRIMARY KEY AUTOINCREMENT,
      "name" TEXT NOT NULL  
    )
  ''');

    // Insert initial values into the "currency" table
    batch.execute('''
    INSERT INTO "rent_type" ("name") VALUES 
   ('يومي'),
   ('إسبوعي'),
   ('شهري'),
   ('سنوي')
  ''');

    await batch.commit();
    print('Database and table created ============');
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

  Future<List<Map<String, dynamic>>> selectRaw(String query) async {
    Database? mydb = await db;
    List<Map<String, dynamic>> response = await mydb!.rawQuery(query);
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
