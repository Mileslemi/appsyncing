import '../models/note_conflict_model.dart';
import 'appsync_db.dart';

class NoteConflictTable {
  NoteConflictTable._();

  static Future<NoteConflict?> create(NoteConflict noteConflict) async {
    final db = await AppSyncDatabase.instance.database;

    try {
      // incase trackingId already exists
      final id = await db.insert(
        noteConflictTable,
        noteConflict.toMap(),
      );

      return noteConflict.copyWith(id: id);
    } on Exception catch (_) {}
    return null;
  }

  // static Future<List<NoteConflict>> getAllConflicts() async {
  //   final db = await AppSyncDatabase.instance.database;

  //   List notes = await db.query(noteConflictTable);

  //   return notes.map((e) => NoteConflict.fromMap(e)).toList();
  // }

  static Future<NoteConflict?> getConflict({required String trackingId}) async {
    final db = await AppSyncDatabase.instance.database;

    List noteConflicts = await db.query(noteConflictTable,
        where: "${NoteConflictFields.trackingId} = ?", whereArgs: [trackingId]);
    if (noteConflicts.isNotEmpty) {
      List<NoteConflict> list =
          noteConflicts.map((e) => NoteConflict.fromMap(e)).toList();

      return list[0];
    }
    return null;
  }

  static Future<int> update(NoteConflict noteConflict) async {
    final db = await AppSyncDatabase.instance.database;

    //  Returns the number of changes made
    int count = await db.update(noteConflictTable, noteConflict.toMap(),
        where: "${NoteConflictFields.id} = ?", whereArgs: [noteConflict.id]);

    return count;
  }

  static Future<void> deleteConflict(int id) async {
    final db = await AppSyncDatabase.instance.database;

    await db.delete(
      noteConflictTable,
      where: "${NoteConflictFields.id} = ?",
      whereArgs: [id],
    );
  }
}
