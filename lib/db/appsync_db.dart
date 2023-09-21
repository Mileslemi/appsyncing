import 'dart:async';

import 'package:appsyncing/models/note_model.dart';
import 'package:appsyncing/models/sync_model.dart';
import 'package:sqflite_common/sqflite.dart';
import 'package:path/path.dart' as p;

import '../models/branch_model.dart';
import '../models/note_conflict_model.dart';
import '../models/user_model.dart';

// best way to create db
// https://github.com/tekartik/sqflite/blob/master/sqflite/doc/migration_example.md

class AppSyncDatabase {
  static final AppSyncDatabase instance = AppSyncDatabase._init();

  static Database? _database;

  static String idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
  static String intType = "INTEGER";
  // static String uniqueintType = "INTEGER UNIQUE";
  static String textType = "TEXT NOT NULL";
  static String boolType = "BOOLEAN NOT NULL";
  // static String uniqueTextType = "TEXT NOT NULL UNIQUE";

  AppSyncDatabase._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    String dbName = "appsync.db";

    // on upgrade change the version

    _database = await _initializeDB(dbName: dbName, version: 3);

    return _database!;
  }

  Future<Database> _initializeDB(
      {required String dbName, required int version}) async {
    final dbDirectory = await getDatabasesPath();

    final dbPath = p.join(dbDirectory, dbName);
    // if not db is found on that path, onCreate will be called
    // [onCreate] is called if the database did not exist prior to calling [openDatabase]
    return await databaseFactory.openDatabase(dbPath,
        options: OpenDatabaseOptions(
          version: version,
          onCreate: (db, version) async {
            // called when the db does not exist in that platform
            Batch batch = db.batch();
            _createNoteTablev3(batch);

            _createBranchTablev3(batch);

            _createUserTablev3(batch);

            _createNoteConflictTablev3(batch);

            _createSyncTablev3(batch);

            await batch.commit();
          },
          onUpgrade: (db, oldVersion, newVersion) async {
            // called if db existed previously in that plaform, and version is higher than oldversion
            Batch batch = db.batch();

            if (oldVersion == 1) {
              // because the first version db user table had no joined column
              _updateUserTablev1tov3(batch);
              // also we added sync table
              _createSyncTablev3(batch);
            }
            if (oldVersion == 2) {
              // this update was to add unique constraint index to sync and note table
              _updateSyncTablev2tov3(batch);
              _updateNoteTablev2tov3(batch);
            }

            await batch.commit();
          },
        ));
  }

  void _updateSyncTablev2tov3(Batch batch) {
    // "ALTER TABLE $syncTableName ADD 'CONSTRAINT' ${SyncFields.constraint} 'UNIQUE'('${SyncFields.tableName}')"
    // CREATE UNIQUE INDEX ${SyncFields.constraintIndex} ON $syncTableName(${SyncFields.tableName})
    batch.execute(
        "CREATE UNIQUE INDEX ${SyncFields.syncconstraintIndex} ON $syncTableName(${SyncFields.tableName})");
  }

  void _updateNoteTablev2tov3(Batch batch) {
    // "ALTER TABLE $syncTableName ADD 'CONSTRAINT' ${SyncFields.constraint} 'UNIQUE'('${SyncFields.tableName}')"
    // CREATE UNIQUE INDEX ${SyncFields.constraintIndex} ON $syncTableName(${SyncFields.tableName})
    batch.execute(
        "CREATE UNIQUE INDEX ${NoteFields.noteConstraintIndex} ON $noteTableName(${NoteFields.trackingId})");
  }

  void _createSyncTablev3(Batch batch) {
    batch.execute('''
CREATE TABLE $syncTableName(
      ${SyncFields.id} $idType,
      ${SyncFields.tableName} $textType,
      ${SyncFields.lastSync} $textType,
      ${SyncFields.rowsEntered} $intType,
      unique(${SyncFields.tableName})
    )
    ''');
  }

  void _updateUserTablev1tov3(Batch batch) {
    // since it a not null field, we mut supply a default
    String defaultTime = DateTime(2023).toIso8601String();
    // supply extra quotes if text type
    batch.execute(
        "ALTER TABLE $usertable ADD COLUMN ${BranchUserFields.joined} $textType DEFAULT '$defaultTime'");
  }

  void _createNoteConflictTablev3(Batch batch) {
    batch.execute('''
CREATE TABLE $noteConflictTable(
      ${NoteConflictFields.id} $idType,
      ${NoteConflictFields.trackingId} $textType UNIQUE,
      ${NoteConflictFields.title} $textType,
      ${NoteConflictFields.desc} $textType
    )
    ''');
  }

  void _createUserTablev3(Batch batch) {
    batch.execute('''
CREATE TABLE $usertable(
      ${BranchUserFields.id} $idType,
      ${BranchUserFields.username} $textType,
      ${BranchUserFields.password} $textType,
      ${BranchUserFields.email} $textType,
      ${BranchUserFields.firstName} $textType,
      ${BranchUserFields.lastName} $textType,
      ${BranchUserFields.isAdmin} $boolType,
      ${BranchUserFields.joined} $textType
    )
    ''');
  }

  void _createBranchTablev3(Batch batch) {
    batch.execute('''
CREATE TABLE $branchTable(
      ${BranchFields.id} $idType,
      ${BranchFields.branchName} $textType,
      ${BranchFields.createdAt} $textType
    )
    ''');
  }

  void _createNoteTablev3(Batch batch) {
    batch.execute('''
CREATE TABLE $noteTableName(
      ${NoteFields.id} $idType,
      ${NoteFields.trackingId} $textType,
      ${NoteFields.masterId} $intType,
      ${NoteFields.title} $textType,
      ${NoteFields.desc} $textType,
      ${NoteFields.user} $textType,
      ${NoteFields.branchName} $textType,
      ${NoteFields.posted} $textType,
      ${NoteFields.lastModified} $textType,
      ${NoteFields.synced} $boolType,
      ${NoteFields.mergeConflict} $boolType,
      unique(${NoteFields.trackingId})
    )
    ''');
  }
}
