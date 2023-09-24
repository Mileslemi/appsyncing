import 'dart:convert';

import 'package:appsyncing/constants/string_constants.dart';
import 'package:appsyncing/db/sync_table.dart';
import 'package:appsyncing/exception/exception_handling.dart';
import 'package:appsyncing/models/note_model.dart';
import 'package:appsyncing/models/sync_model.dart';
import 'package:appsyncing/repository/Network/network_handler.dart';
import 'package:get/get.dart';

import '../../common_methods/date_functions.dart';
import '../../common_methods/fetch_online_notes.dart';

class SyncController extends GetxController {
  static SyncController get instance => Get.find();

  late Rx<DateTime?> lastNoteTableSync;
  RxBool noteChanges = false.obs;

  RxBool syncing = false.obs;

  Rx<DateTime> lastNoteTableSyncChecked = Rx(DateTime.now());

  @override
  void onInit() async {
    lastNoteTableSync = Rx(await getLastSync(tableName: noteTableName));

    ever(noteChanges, (e) {
      if (e) {
        pullNotes(lastCheck: lastNoteTableSyncChecked.value);
      } else {
        // if no changes online push local notes that have been modified since last sync
        pushNotes();
      }
    });
    noteChanges.value =
        await checkTableChanges(url: UrlStrings.checkNoteTableChangesUrl());
    super.onInit();
  }

  Future<DateTime?> getLastSync({required String tableName}) async {
    SyncModel noteSync = await SyncTable.read(tableName);

    if (noteSync.id != null) {
      return noteSync.lastSync!;
    } else {
      //if that table is not found, then it's a new db, initiate it with default SyncModel
      SyncModel? newSync = await SyncTable.create(SyncModel(
          rowsEntered: 0, tableName: tableName, lastSync: defaultTime));
      // added the first time succesfully
      if (newSync?.id != null) {
        return newSync?.lastSync;
      }
    }
    return null;
  }

  Future<bool> checkTableChanges({required String url}) async {
    lastNoteTableSyncChecked.value = DateTime.now();
    final response = await NetworkHandler.get(url);

    if (response is Success) {
      Success s = response as Success;
      var returnMap = jsonDecode(s.returnValue);
      try {
        String? lastModified = returnMap['last_modified'];

        if (lastModified != null) {
          DateTime lastModifiedDateTime = DateTime.parse(lastModified);
          // compare lastSync and lastModified
          int difference = ADateTimeFunctions.dateDifferenceInMin(
              lastModifiedDateTime, lastNoteTableSync.value);
          // print(difference);
          if (difference > 0) {
            return true;
          }
        }
      } catch (_) {
        Get.log("Error checking table changes");
      }
    }
    return false;
  }

  void pullNotes({required DateTime lastCheck}) async {
    // on success pull, update last sync time with the time you checkedNoteTbale changes
    syncing.value = true;
    if (lastNoteTableSync.value != null) {
      // print("pulling data");
      List<NoteModel> onlineNotes = await SyncFunctions.getOnlineModifiedNotes(
          lastSync: lastNoteTableSync.value!.toIso8601String());
      Get.log("$onlineNotes");
      bool allSuccess =
          await SyncFunctions.syncOnlineToLocal(onlineNotes: onlineNotes);

      if (allSuccess) {
        // after sucessfully adding all, update last sync to lastCheck
        SyncModel noteTableSync = await SyncTable.read(noteTableName);
        await SyncTable.update(noteTableSync.copyWith(lastSync: lastCheck));
      }

      // push local note to online, ones without merge conflict
    } else {
      Get.log("Sync Failure! lastNoteTableSync value is null.");
    }
    syncing.value = false;
  }

  void pushNotes() async {
    syncing.value = true;

    syncing.value = false;
  }
}
