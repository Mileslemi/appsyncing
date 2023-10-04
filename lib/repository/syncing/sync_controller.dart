import 'dart:async';
import 'dart:convert';

import 'package:appsyncing/constants/string_constants.dart';
import 'package:appsyncing/db/sync_table.dart';
import 'package:appsyncing/exception/exception_handling.dart';
import 'package:appsyncing/models/note_model.dart';
import 'package:appsyncing/models/sync_model.dart';
import 'package:appsyncing/repository/Network/network_handler.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../common_methods/date_functions.dart';
import '../../common_methods/sync_notes_functions.dart';
import '../../db/note_table.dart';
import '../../views/notes/notes_controller.dart';

class SyncController extends GetxController {
  static SyncController get instance => Get.find();

  late Rx<DateTime?> lastNoteTableSync;

  RxString lastNoteSyncToDisplay = "".obs;

  RxBool isThereConflict = true.obs;

  // RxBool noteChangesOnline = false.obs;

  RxBool syncing = false.obs;

  late Timer syncTimer;

  RxBool autoSyncActive = true.obs;

  RxBool displayConflictWarning = false.obs;

  Rx<DateTime> lastNoteTableSyncChecked = Rx(DateTime.now().toUtc());

  @override
  void onInit() async {
    lastNoteTableSync = Rx(await getLastSync(tableName: noteTableName));

    ever(isThereConflict, (thereIs) async {
      if (!thereIs) {
        displayConflictWarning.value = false;
        // Get.log("Conflict notes don't exist");
        await checkOnlineTableChanges(
            url: UrlStrings.checkNoteTableChangesUrl());
      } else {
        displayConflictWarning.value = true;
        // Get.log("IsThereconflict value turn true");
      }
    });

    // this enables periodic syncing
    syncTimer = Timer.periodic(
      const Duration(seconds: 7),
      (timer) async {
        // this is to make sure no new data is pulled from main if there are conflicts on local
        await checkIfConflict();
      },
    );

    super.onInit();
  }

  void toggleAutoSync() {
    if (syncTimer.isActive) {
      syncTimer.cancel();
      autoSyncActive.value = false;
      // just incase it was syncing turn the circualr progress indicator off
      syncing.value = false;
    } else {
      syncTimer = Timer.periodic(
        const Duration(seconds: 7),
        (timer) async {
          // this is to make sure no new data is pulled from main if there are conflicts on local
          await checkIfConflict();
        },
      );
      autoSyncActive.value = true;
    }
  }

  Future<DateTime?> getLastSync({required String tableName}) async {
    SyncModel noteSync = await SyncTable.read(tableName);

    if (noteSync.id != null) {
      lastNoteSyncToDisplay.value = ADateTimeFunctions.convertToFormat(
          formatNeeded: "H:mm y-MM-dd", dateTime: noteSync.lastSync?.toLocal());
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

  // this function can be used to initiate syncing with a btn.

  Future<void> checkIfConflict() async {
    isThereConflict.value = true;
    List<NoteModel> conflictNotes = await NoteTable.getConflictNotes();
    if (conflictNotes.isEmpty) {
      isThereConflict.value = false;
    } else {
      displayConflictWarning.value = true;
    }
  }

  Future<void> checkOnlineTableChanges({required String url}) async {
    lastNoteTableSyncChecked.value = DateTime.now().toUtc();
    final response = await NetworkHandler.get(url);

    if (response is Success) {
      Success s = response as Success;
      var returnMap = jsonDecode(s.returnValue);
      try {
        String? lastEntryMadeInMain = returnMap['last_entry_made'];

        if (lastEntryMadeInMain != null) {
          DateTime lastEntryDateTime =
              DateTime.parse(lastEntryMadeInMain).toUtc();
          // compare lastSync and lastModified
          int difference = ADateTimeFunctions.dateDifferenceInSeconds(
              lastEntryDateTime, lastNoteTableSync.value);
          Get.log("diff in sync time: $difference");
          if (difference > 0) {
            // there Are changes - pull notes
            Get.log("pulling");
            pullNotes(newCheck: lastNoteTableSyncChecked.value);
          } else {
            updateSyncTime(
                tableName: noteTableName,
                newCheck: lastNoteTableSyncChecked.value);
            pushNotes();
          }
        }
      } catch (_) {
        Get.log("Error checking table changes");
      }
    }
  }

  Future<void> pullNotes({required DateTime newCheck}) async {
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
        updateSyncTime(tableName: noteTableName, newCheck: newCheck);
        await pushNotes();
      }

      // push local note to online, ones without merge conflict
    } else {
      Get.log("Sync Failure! lastNoteTableSync value is null.");
    }
    syncing.value = false;
  }

  Future<void> updateSyncTime(
      {required String tableName, required DateTime newCheck}) async {
    Get.log("Updating Sync Time");
    try {
      SyncModel noteTableSync = await SyncTable.read(tableName);
      await SyncTable.update(noteTableSync.copyWith(lastSync: newCheck));
      lastNoteTableSync.value = newCheck;
      lastNoteSyncToDisplay.value =
          DateFormat("H:mm y-MM-dd").format(newCheck.toLocal());
    } on Exception catch (_) {
      Get.log("Error updating $tableName Sync Time");
    }
  }

  Future<void> pushNotes() async {
    Get.log("pushing notes");
    syncing.value = true;
    // push any modified notes[ any notes whose sync is false] and mergeConflict false
    await SyncFunctions.pushLocalToOnline();
    // update notes list
    NotesController.instance.updatesNotesList();
    syncing.value = false;
  }
}
