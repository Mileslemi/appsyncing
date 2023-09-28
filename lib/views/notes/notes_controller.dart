import 'package:appsyncing/constants/string_constants.dart';
import 'package:appsyncing/models/note_model.dart';
import 'package:appsyncing/models/sync_model.dart';
import 'package:appsyncing/repository/authentication/authentication_controller.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../db/note_table.dart';
import '../../db/sync_table.dart';

class NotesController extends GetxController {
  static NotesController get instance => Get.find();

  final authCtrl = Get.find<AuthenticationController>();

  TextEditingController titleText = TextEditingController();
  TextEditingController descText = TextEditingController();

  RxList<NoteModel> allNotes = RxList([]);

  RxList<NoteModel> localNotes = RxList([]);

  RxList<NoteModel> conflictNotes = RxList([]);

  RxBool fetching = false.obs;
  RxBool syncing = false.obs;

  @override
  void onInit() async {
    fetchAllNotes();
    fetchAllOnlyLocalMadeNotes();
    fetchConflictNotes();

    ever(authCtrl.localBranch, (callback) => updatesNotesList());
    super.onInit();
  }

  void addLcalNote({required String title, required String desc}) async {
    DateTime now = DateTime.now().toUtc();

    // don't use this func on synced rows, only those entered locally
    Map result = await trackTableRowsEntered(tableName: noteTableName);

    if (result['changes'] > 0) {
      int nextInt = result['nextInt'];

      String trackingId =
          "${authCtrl.localBranch.value.branchName}$noteTableName$nextInt"
              .toUpperCase();

      NoteModel note = NoteModel(
          trackingId: trackingId,
          title: title,
          description: desc,
          user: authCtrl.user.value.username,
          branchName: authCtrl.localBranch.value.branchName,
          posted: now,
          lastModified: now);

      await NoteTable.create(note);
      updatesNotesList();
      Get.back();
    } else {
      Get.snackbar("Error. Try Again", "If error persists contact support.");
    }
  }

  Future<Map<String, int>> trackTableRowsEntered(
      {required String tableName}) async {
    // don't use this func on synced rows, only those entered loccaly
    SyncModel track = await SyncTable.read(tableName);

    if (track.id != null) {
      // that tableName exists in sync table
      int rowsEntered = track.rowsEntered!;

      int nextInt = rowsEntered + 1;

      //update table to reflect a row is entered now, we need this to be successful first,
      // for bcuz of this we can constraint the unique keys

      int changes =
          await SyncTable.update(track.copyWith(rowsEntered: nextInt));

      return {"changes": changes, "nextInt": nextInt};
    } else {
      // first time a row is entered
      SyncModel? track = await SyncTable.create(SyncModel(
          rowsEntered: 0, tableName: tableName, lastSync: defaultTime));
      if (track != null) {
        // added the first time succesfully

        // that tableName exists in sync table
        int rowsEntered = track.rowsEntered!;

        int nextInt = rowsEntered + 1;

        //update table to reflect a row is entered now, we need this to be successful first,
        // for bcuz of this we can constraint the unique keys

        int changes =
            await SyncTable.update(track.copyWith(rowsEntered: nextInt));

        return {"changes": changes, "nextInt": nextInt};
      }
    }
    return {"changes": 0};
  }

  void updateNote(
      {required NoteModel note,
      required String title,
      required String desc}) async {
    DateTime now = DateTime.now().toUtc();

    NoteModel updateNote = note.copyWith(
        user: authCtrl.user.value.username,
        title: title,
        description: desc,
        lastModified: now,
        synced: false);

    await NoteTable.update(updateNote);

    updatesNotesList();
    Get.back();
  }

  void updatesNotesList() {
    fetchAllNotes();
    fetchAllOnlyLocalMadeNotes();
    fetchConflictNotes();
  }

  Future<void> fetchAllNotes() async {
    fetching.value = true;
    //await Future.delayed(const Duration(seconds: 3));
    try {
      // final data = await rootBundle.loadString("assets/files/local_notes.json");

      // List collection = jsonDecode(data);

      // Get.log("Notes : $collection");

      // List<NoteModel> allNotes =
      //     collection.map((e) => NoteModel.fromMap(e)).toList();

      allNotes.value = await NoteTable.getAllNotes();

      fetching.value = false;
      update();
    } on Exception catch (e) {
      Get.log("$e");
      Get.snackbar("Error!", "Could not fetch Notes.");
    }
    fetching.value = false;
  }

  Future<void> fetchAllOnlyLocalMadeNotes() async {
    // notes whose tracking_id match server name somewhere in their string

    try {
      localNotes.value = await NoteTable.getLocalyMadeNotes(
          branchName: authCtrl.localBranch.value.branchName ?? '');

      update();
    } on Exception catch (e) {
      Get.log("$e");
    }
  }

  Future<void> fetchConflictNotes() async {
    try {
      conflictNotes.value = await NoteTable.getConflictNotes();

      update();
    } on Exception catch (e) {
      Get.log("$e");
    }
  }
}
