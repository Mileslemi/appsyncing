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

  Rx<DateTime> lastNoteTableSyncChecked = Rx(DateTime.now());

  @override
  void onInit() async {
    lastNoteTableSync = Rx(await getLastSync(tableName: noteTableName));

    ever(noteChanges, (e) {
      if (e) {
        pullNotes(lastCheck: lastNoteTableSyncChecked.value);
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
        // print("Error checking table changes $e");
      }
    }
    return false;
  }

  void pullNotes({required DateTime lastCheck}) async {
    // on success pull, update last sync time with the time you checkedNoteTbale changes
    if (lastNoteTableSync.value != null) {
      // print("pulling data");
      List<NoteModel> onlineNotes = await SyncFunctions.getOnlineModifiedNotes(
          lastSync: lastNoteTableSync.value!.toIso8601String());
      // SyncModel noteTableSync = await SyncTable.read(noteTableName);
      Get.log("$onlineNotes");
    } else {
      Get.snackbar("Sync Failure!", "If error persist, contact support.");
    }

    // await SyncTable.update(noteTableSync.copyWith(lastSync: lastCheck));
  }
}
