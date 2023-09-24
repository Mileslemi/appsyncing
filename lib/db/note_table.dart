import 'package:appsyncing/models/note_model.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

import 'appsync_db.dart';

class NoteTable {
  NoteTable._();

  static Future<NoteModel?> create(NoteModel note) async {
    final db = await AppSyncDatabase.instance.database;

    try {
      // incase trackingId already exists
      final id = await db.insert(noteTableName, note.toMap(),
          conflictAlgorithm: ConflictAlgorithm.fail);

      return note.copyWith(id: id);
    } on Exception catch (_) {
      Get.log("Conflict Error. ${note.trackingId} Already Exists");
    }
    return null;
  }

  static Future<int?> nextTrackingNum({required String branchName}) async {
    final db = await AppSyncDatabase.instance.database;

    var count = await db.rawQuery('SELECT COUNT(*) FROM $noteTableName');
    //  returns [{COUNT(*): 0}]

    int? noteCount = Sqflite.firstIntValue(count);

    return noteCount;
  }

  static Future<List<NoteModel>> getAllNotes() async {
    final db = await AppSyncDatabase.instance.database;

    List notes = await db.query(noteTableName);

    return notes.map((e) => NoteModel.fromMap(e)).toList();
  }

  static Future<List<NoteModel>> getLocalyMadeNotes(
      {required String branchName}) async {
    final db = await AppSyncDatabase.instance.database;

    List notes = await db.query(noteTableName,
        where: "${NoteFields.branchName} = ?", whereArgs: [branchName]);

    return notes.map((e) => NoteModel.fromMap(e)).toList();
  }

  static Future<List<NoteModel>> getConflictNotes() async {
    final db = await AppSyncDatabase.instance.database;

    List notes = await db.query(noteTableName,
        where: "${NoteFields.mergeConflict} = ?", whereArgs: [1]);

    return notes.map((e) => NoteModel.fromMap(e)).toList();
  }

  static Future<int> update(NoteModel note) async {
    final db = await AppSyncDatabase.instance.database;

    //  Returns the number of changes made
    int count = await db.update(noteTableName, note.toMap(),
        where: "${NoteFields.id} = ?", whereArgs: [note.id]);

    return count;
  }

  static Future<bool> trackingIdExists({required String trackingID}) async {
    final db = await AppSyncDatabase.instance.database;

    var count = Sqflite.firstIntValue(await db.rawQuery(
        'SELECT COUNT(*) FROM $noteTableName WHERE "${NoteFields.trackingId}" = "$trackingID"'));

    //  returns [{COUNT(*): 0}]
    if ((count ?? 1) > 0) {
      return true;
    }

    return false;
  }
}
