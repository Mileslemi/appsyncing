import 'dart:async';

import 'package:appsyncing/models/note_model.dart';
import 'package:sqflite_common/sqflite.dart';
import 'package:path/path.dart' as p;

import '../models/branch_model.dart';
import '../models/note_conflict_model.dart';
import '../models/user_model.dart';

class AppSyncDatabase {
  static final AppSyncDatabase instance = AppSyncDatabase._init();

  static Database? _database;

  AppSyncDatabase._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initializeDB("appsync.db");

    return _database!;
  }

  Future<Database> _initializeDB(String dbName) async {
    final dbDirectory = await getDatabasesPath();

    final dbPath = p.join(dbDirectory, dbName);
    // if not db is found on that path, onCreate will be called
    // [onCreate] is called if the database did not exist prior to calling [openDatabase]
    return await openDatabase(dbPath, version: 1, onCreate: _createTables);
  }

  // FutureOr<void> _onUpgrade(db, oldVersion, newVersion) {
  //   // [onUpgrade] is called if either of the following conditions are met:

  //   //   [onCreate] is not specified
  //   //   The database already exists and [version] is higher than the last database version
  //   //   In the first case where [onCreate] is not specified, [onUpgrade] is called with its [oldVersion] parameter as 0. In the second case, you can perform the necessary migration procedures to handle the differing schema
  // }

  FutureOr<void> _createTables(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const intType = "INTEGER UNIQUE";
    const textType = "TEXT NOT NULL";
    const boolType = "BOOLEAN NOT NULL";

    // tables to create, branch, note, user, note_conflict, count

//  note table
    await db.execute('''
CREATE TABLE $noteTableName(
  ${NoteFields.id} $idType,
  ${NoteFields.trackingId} $textType UNIQUE,
  ${NoteFields.masterId} $intType,
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
