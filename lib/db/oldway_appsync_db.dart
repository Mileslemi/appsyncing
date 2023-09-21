import 'dart:async';

import 'package:appsyncing/models/note_model.dart';
import 'package:sqflite_common/sqflite.dart';
import 'package:path/path.dart' as p;

import '../models/branch_model.dart';
import '../models/note_conflict_model.dart';
import '../models/user_model.dart';

class AppSyncDatabaseOld {
  static final AppSyncDatabaseOld instance = AppSyncDatabaseOld._init();

  static Database? _database;

  static String idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
  static String intType = "INTEGER";
  static String uniqueintType = "INTEGER UNIQUE";
  static String textType = "TEXT NOT NULL";
  static String boolType = "BOOLEAN NOT NULL";

  AppSyncDatabaseOld._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    String dbName = "appsync.db";

    // first, it will initiliaze this first version of db
    _database = await _initializeDB(dbName: dbName, version: 1);

    // then update that db to current tables
    // _database = await _upgradeDB2(dbName: dbName, newVersion: 3);

    return _database!;
  }

  Future<Database> _initializeDB(
      {required String dbName, required int version}) async {
    final dbDirectory = await getDatabasesPath();

    final dbPath = p.join(dbDirectory, dbName);
    // if not db is found on that path, onCreate will be called
    // [onCreate] is called if the database did not exist prior to calling [openDatabase]
    return await openDatabase(dbPath,
        version: version, onCreate: _createInitialTables);
  }

  // Future<Database> _upgradeDB2(
  //     {required String dbName, required int newVersion}) async {
  //   print("upgrading");
  //   // [onUpgrade] is called if either of the following conditions are met:

  //   //     [onCreate] is not specified
  //   //     The database already exists and [version] is higher than the last database version
  //   //     In the first case where [onCreate] is not specified, [onUpgrade] is called with its [oldVersion] parameter as 0. In the second case, you can perform the necessary migration procedures to handle the differing schema
  //   //
  //   final dbDirectory = await getDatabasesPath();

  //   final dbPath = p.join(dbDirectory, dbName);

  //   return await openDatabase(
  //     dbPath,
  //     version: newVersion,
  //     onUpgrade: _upgradeTable2,
  //   );
  // }

//   FutureOr<void> _upgradeTable2(
//       Database db, int oldVersion, int newVersion) async {
//     print("db oldversion: $oldVersion");
//     if (oldVersion == 1) {
//       // if oldversion is 1, upgrade to 2
//       await db.execute(
//           "ALTER TABLE $usertable ADD COLUMN ${BranchUserFields.joined} $textType");

//       await db.execute('''
// CREATE TABLE $syncTableName(
//   ${SyncFields.id} $idType,
//   ${SyncFields.tableName} $textType,
//   ${SyncFields.lastSync} $textType,
//   ${SyncFields.rowsEntered} $intType,
// )
// ''');
//     }
//   }

  FutureOr<void> _createInitialTables(Database db, int version) async {
    // tables to create, branch, note, user, note_conflict, count

//  note table
    await db.execute('''
CREATE TABLE $noteTableName(
  ${NoteFields.id} $idType,
  ${NoteFields.trackingId} $textType UNIQUE,
  ${NoteFields.masterId} $uniqueintType,
  ${NoteFields.title} $textType,
  ${NoteFields.desc} $textType,
  ${NoteFields.user} $textType,
  ${NoteFields.branchName} $textType,
  ${NoteFields.posted} $textType,
  ${NoteFields.lastModified} $textType,
  ${NoteFields.synced} $boolType,
  ${NoteFields.mergeConflict} $boolType
)
''');

// branch table

    await db.execute('''
CREATE TABLE $branchTable(
  ${BranchFields.id} $idType,
  ${BranchFields.branchName} $textType,
  ${BranchFields.createdAt} $textType
)
''');
// user table, later, try adding a column, like joined
    await db.execute('''
CREATE TABLE $usertable(
  ${BranchUserFields.id} $idType,
  ${BranchUserFields.username} $textType,
  ${BranchUserFields.password} $textType,
  ${BranchUserFields.email} $textType,
  ${BranchUserFields.firstName} $textType,
  ${BranchUserFields.lastName} $textType,
  ${BranchUserFields.isAdmin} $boolType
)
''');

// note conflict table

    await db.execute('''
CREATE TABLE $noteConflictTable(
  ${NoteConflictFields.id} $idType,
  ${NoteConflictFields.trackingId} $textType UNIQUE,
  ${NoteConflictFields.title} $textType,
  ${NoteConflictFields.desc} $textType
)
''');
  }
}

// best way to create db
// https://github.com/tekartik/sqflite/blob/master/sqflite/doc/migration_example.md
// ******1ST VERSION ****

/// Create tables
// void _createTableCompanyV1(Batch batch) {
//   batch.execute('DROP TABLE IF EXISTS Company');
//   batch.execute('''CREATE TABLE Company (
//     id INTEGER PRIMARY KEY AUTOINCREMENT,
//     name TEXT
// )''');
// }

// // First version of the database
// db = await factory.openDatabase(path,
//     options: OpenDatabaseOptions(
//         version: 1,
//         onCreate: (db, version) async {
//           var batch = db.batch();
//           _createTableCompanyV1(batch);
//           await batch.commit();
//         },
//         onDowngrade: onDatabaseDowngradeDelete));



// *****2ND VERSION***


// /// Let's use FOREIGN KEY constraints
// Future onConfigure(Database db) async {
//   await db.execute('PRAGMA foreign_keys = ON');
// }

// /// Create Company table V2
// void _createTableCompanyV2(Batch batch) {
//   batch.execute('DROP TABLE IF EXISTS Company');
//   batch.execute('''CREATE TABLE Company (
//     id INTEGER PRIMARY KEY AUTOINCREMENT,
//     name TEXT,
//     description TEXT
// )''');
// }

// /// Update Company table V1 to V2
// void _updateTableCompanyV1toV2(Batch batch) {
//   batch.execute('ALTER TABLE Company ADD description TEXT');
// }

// /// Create Employee table V2
// void _createTableEmployeeV2(Batch batch) {
//   batch.execute('DROP TABLE IF EXISTS Employee');
//   batch.execute('''CREATE TABLE Employee (
//     id INTEGER PRIMARY KEY AUTOINCREMENT,
//     name TEXT,
//     companyId INTEGER,
//     FOREIGN KEY (companyId) REFERENCES Company(id) ON DELETE CASCADE
// )''');
// }

// // 2nd version of the database
// db = await factory.openDatabase(path,
//     options: OpenDatabaseOptions(
//         version: 2,
//         onConfigure: onConfigure,
//         onCreate: (db, version) async {
//           var batch = db.batch();
//           // We create all the tables
//           _createTableCompanyV2(batch);
//           _createTableEmployeeV2(batch);
//           await batch.commit();
//         },
//         onUpgrade: (db, oldVersion, newVersion) async {
//           var batch = db.batch();
//           if (oldVersion == 1) {
//             // We update existing table and create the new tables
//             _updateTableCompanyV1toV2(batch);
//             _createTableEmployeeV2(batch);
//           }
//           await batch.commit();
//         },
//         onDowngrade: onDatabaseDowngradeDelete));