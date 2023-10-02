import 'dart:convert';

import 'package:appsyncing/constants/string_constants.dart';
import 'package:appsyncing/db/note_conflict_table.dart';
import 'package:appsyncing/db/note_table.dart';
import 'package:appsyncing/exception/exception_handling.dart';
import 'package:appsyncing/models/note_conflict_model.dart';
import 'package:appsyncing/models/note_model.dart';
import 'package:appsyncing/repository/Network/network_handler.dart';
import 'package:appsyncing/repository/syncing/sync_controller.dart';
import 'package:appsyncing/views/notes/notes_controller.dart';
import 'package:get/get.dart';

// {
//         "id": 3,
//         "posted": "2023-09-08T08:54:40Z",
//         "title": "Note To Test",
//         "description": "This Note was for purpose of testing getting all modified or new Notes since last sync. Modifying Test 2.",
//         "trackingId": "MAINNOTE3",
//         "lastModified": "2023-09-08T09:09:18.535124Z",
//         "user": "mileslemi",
//         "branchName": "MAIN"
//     },
class SyncFunctions {
  SyncFunctions._();

  static Future<List<NoteModel>> getOnlineModifiedNotes(
      {required String lastSync}) async {
    final response = await NetworkHandler.post(
        url: UrlStrings.getOnlineModifiedNotesUrl(),
        body: {"last_sync": lastSync});
    if (response is Success) {
      Success s = response as Success;
      List notesList = jsonDecode(s.returnValue);

      if (notesList.isNotEmpty) {
        List<NoteModel> notes =
            notesList.map((e) => NoteModel.fromOnlineMap(e)).toList();

        return notes;
      }
    }
    return [];
  }

  static Future<bool> syncOnlineToLocal(
      {required List<NoteModel> onlineNotes}) async {
    bool success = true;
    try {
      for (NoteModel onlineNote in onlineNotes) {
        // if trackingID exists, check conflict first, then update if no conflict
        // else, create
        if (onlineNote.trackingId != null &&
            (onlineNote.trackingId ?? '').trim().isNotEmpty) {
          NoteModel? noteExists = await NoteTable.trackingIdExists(
              trackingID: onlineNote.trackingId!);
          if (noteExists != null) {
            // check conflict first, then update if no conflict
            if (onlineNote.lastModified == noteExists.lastModified) {
              print("same modified time, ${onlineNote.trackingId}");
              //make sure timezones are same
              //if modified times are same, then no update happened, and this is a note that was prevously pushed from this local server to main after sync time/pulling time
              continue;
            } else if (!(noteExists.synced!)) {
              // there is a conflict as it modified online but also locally

              print(
                  "conflict as it's modified online but also locally, ${onlineNote.trackingId}");
              int change = await NoteTable.update(
                  noteExists.copyWith(mergeConflict: true));
              if (change > 0) {
                NoteConflict? theCnflict = await NoteConflictTable.create(
                    NoteConflict(
                        trackingId: noteExists.trackingId,
                        title: onlineNote.title,
                        description: onlineNote.description));
                if (theCnflict == null) {
                  success = false;
                }
              } else {
                success = false;
              }
              continue;
            } else {
              // syced is true, no modification has happened locally
              print(
                  "another modified time, no conflict ${onlineNote.trackingId}");
              //we need the auto _id in order to update
              int changes = await NoteTable.update(
                  onlineNote.copyWith(id: noteExists.id));
              if (changes < 1) {
                //  no update made
                success = false;
              }
              continue;
            }
          } else {
            // create
            NoteModel? createdNote = await NoteTable.create(
                onlineNote.copyWith(mergeConflict: false, synced: true));
            if (createdNote == null) {
              success = false;
            }
          }
        }
      }
    } catch (_) {
      Get.log("Error occured on syncOnlineToLocal fn");
      success = false;
    }

    return success;
  }

  static Future<void> pushLocalToOnline() async {
    List<NoteModel> allNotesToPush = await NoteTable.getNotesToPush();

    if (allNotesToPush.isNotEmpty) {
      final response = await NetworkHandler.post(
        url: UrlStrings.pushLocalToOnlineUrl(),
        body: {"notes": jsonEncode(allNotesToPush)},
      );
      if (response is Success) {
        Success s = response as Success;
        String messageR = jsonDecode(s.returnValue);
        print(messageR);
        if (messageR == "1") {
          print("success");
          //all successful, update allNotesToPush synced to true
          for (NoteModel syncedNote in allNotesToPush) {
            await NoteTable.update(syncedNote.copyWith(synced: true));
          }
        } else {
          Get.log("Error Pushing notes to remote. The Error, $messageR.");
        }
      } else {
        Get.log("Failure on pushing note online");
      }
    }
  }

  static Future<void> merge(
      {required NoteModel? mergedNote,
      required NoteConflict? noteConflict}) async {
    if (mergedNote != null && noteConflict != null) {
      await NoteTable.update(mergedNote);
      // delete the conflict row
      await NoteConflictTable.deleteConflict(noteConflict.id!);
      // update all notes lists
      NotesController.instance.updatesNotesList();
      // check if any other conflict, if not, it initiate syncing
      await SyncController.instance.checkIfConflict();
    } else {
      Get.log("Merge fn receiving a null mergedNote");
    }
  }
}
