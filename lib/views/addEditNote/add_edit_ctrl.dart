import 'package:appsyncing/views/notes/notes_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/string_constants.dart';
import '../../db/note_table.dart';
import '../../db/sync_table.dart';
import '../../models/note_model.dart';
import '../../models/sync_model.dart';
import '../../repository/authentication/authentication_controller.dart';

class AddEditController extends GetxController {
  static AddEditController get instance => Get.find();

  final authCtrl = Get.find<AuthenticationController>();

  dynamic arguments = Get.arguments;

  NoteModel? note;

  TextEditingController titleText = TextEditingController();
  TextEditingController descText = TextEditingController();

  @override
  void onInit() {
    if (arguments != null) {
      // checking if argument has been provided.
      try {
        note = arguments['note'];
      } on Exception catch (_) {
        Get.log("No note argument provided");
      }
    }

    if (note != null) {
      titleText.text = note?.title ?? '';
      descText.text = note?.description ?? '';
    }
    super.onInit();
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

    NotesController.instance.updatesNotesList();
    Get.back();
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
      NotesController.instance.updatesNotesList();
      Get.back();
    } else {
      Get.snackbar("Error. Try Again", "If error persists contact support.");
    }
  }
}
