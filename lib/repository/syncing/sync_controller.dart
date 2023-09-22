import 'dart:convert';

import 'package:appsyncing/constants/string_constants.dart';
import 'package:appsyncing/db/sync_table.dart';
import 'package:appsyncing/exception/exception_handling.dart';
import 'package:appsyncing/models/note_model.dart';
import 'package:appsyncing/models/sync_model.dart';
import 'package:appsyncing/repository/Network/network_handler.dart';
import 'package:get/get.dart';

import '../../common_methods/date_functions.dart';

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
        await checkTableChanges(url: UrlStrings.checkNoteTableChanges());
    super.onInit();
  }

  Future<DateTime?> getLastSync({required String tableName}) async {
    SyncModel noteSync = await SyncTable.read(tableName);

    if (noteSync.id != null) {
      return noteSync.lastSync;
    }
    //if no sync found return null
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
    print("pulling data");
    // on success pull, update last sync time with the time you checkedNoteTbale changes

    // SyncModel noteTableSync = await SyncTable.read(noteTableName);

    // await SyncTable.update(noteTableSync.copyWith(lastSync: lastCheck));
  }
}
