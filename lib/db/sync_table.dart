import 'package:appsyncing/db/appsync_db.dart';
import 'package:appsyncing/models/sync_model.dart';
import 'package:get/get.dart';
import 'package:sqflite_common/sql.dart';

class SyncTable {
  SyncTable._();

  static Future<SyncModel?> create(SyncModel newSync) async {
    final db = await AppSyncDatabase.instance.database;

    try {
      // incase of unique constraint exception, a row with that _unique already exists
      int id = await db.insert(syncTableName, newSync.toMap(),
          conflictAlgorithm: ConflictAlgorithm.fail);

      return newSync.copyWith(id: id);
    } on Exception catch (_) {
      Get.snackbar("Conflict Error", "Contact Support.");
    }
    return null;
  }

  static Future<SyncModel> read(String tableName) async {
    final db = await AppSyncDatabase.instance.database;

    SyncModel sync = SyncModel();
    // the tableName has a unique constraint
    List syncList = await db.query(syncTableName,
        where: "${SyncFields.tableName} = ?", whereArgs: [tableName]);

    List<SyncModel> mappedSync =
        syncList.map((e) => SyncModel.fromMap(e)).toList();

    if (mappedSync.isNotEmpty) {
      sync = mappedSync[0];
    }
    return sync;
  }

  static Future<int> update(SyncModel sync) async {
    final db = await AppSyncDatabase.instance.database;

    int changescount = await db.update(syncTableName, sync.toMap(),
        where: "${SyncFields.id} = ?", whereArgs: [sync.id]);

    return changescount;
  }

  static Future<int> delete(int id) async {
    final db = await AppSyncDatabase.instance.database;

    return db.delete(
      syncTableName,
      where: "${SyncFields.id} = ?",
      whereArgs: [id],
    );
  }
}
