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

class SyncController extends GetxController {
  static SyncController get instance => Get.find();

  late Rx<DateTime?> lastNoteTableSync;

  RxString lastNoteSyncToDisplay = "".obs;

  RxBool isThereConflict = true.obs;

  RxBool noteChangesOnline = false.obs;

  RxBool syncing = false.obs;

  Rx<DateTime> lastNoteTableSyncChecked = Rx(DateTime.now().toUtc());

  @override
  void onInit() async {
    lastNoteTableSync = Rx(await getLastSync(tableName: noteTableName));

    ever(isThereConflict, (thereIs) async {
      if (!thereIs) {
        Get.log("Conflict notes don't exist");
        noteChangesOnline.value = await checkOnlineTableChanges(
            url: UrlStrings.checkNoteTableChangesUrl());
      } else {
        Get.log("IsThereconflict value turn true");
      }
    });

    ever(noteChangesOnline, (thereAreChanges) async {
      if (thereAreChanges) {
        Get.log("pulling");
        await pullNotes(newCheck: lastNoteTableSyncChecked.value);
      } else {
        // if no changes online push local notes that have sync as false and mergeConflict as false also
        await pushNotes();
      }
    });

    // this is to make sure no new data is pulled from main if there are conflicts on local
    await checkIfConflict();
    // noteChanges.value =
    //     await checkTableChanges(url: UrlStrings.checkNoteTableChangesUrl());
    super.onInit();
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
    }
  }

  Future<bool> checkOnlineTableChanges({required String url}) async {
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
          int difference = ADateTimeFunctions.dateDifferenceInMin(
              lastEntryDateTime, lastNoteTableSync.value);
          print("diff$difference");
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
        SyncModel noteTableSync = await SyncTable.read(noteTableName);
        await SyncTable.update(noteTableSync.copyWith(lastSync: newCheck));
        lastNoteTableSync.value = newCheck;
        lastNoteSyncToDisplay.value =
            DateFormat("H:m y-MM-dd").format(newCheck.toLocal());
        await pushNotes();
      }

      // push local note to online, ones without merge conflict
    } else {
      Get.log("Sync Failure! lastNoteTableSync value is null.");
    }
    syncing.value = false;
  }

  Future<void> pushNotes() async {
    Get.log("pushing notes");
    syncing.value = true;
    // push any modified notes[ any notes whose sync is false] and mergeConflict false
    await SyncFunctions.pushLocalToOnline();
    syncing.value = false;
  }
}
