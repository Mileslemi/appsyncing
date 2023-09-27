import 'dart:convert';

import 'package:appsyncing/constants/string_constants.dart';
import 'package:appsyncing/db/note_table.dart';
import 'package:appsyncing/exception/exception_handling.dart';
import 'package:appsyncing/models/note_model.dart';
import 'package:appsyncing/repository/Network/network_handler.dart';
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
      for (NoteModel note in onlineNotes) {
        // if trackingID exists, check conflict first, then update if no conflict
        // else, create
        if (note.trackingId != null &&
            (note.trackingId ?? '').trim().isNotEmpty) {
          NoteModel? noteExists =
              await NoteTable.trackingIdExists(trackingID: note.trackingId!);
          if (noteExists != null) {
            // check conflict first, then update if no conflict
            if (note.lastModified == noteExists.lastModified) {
              print("same modified time, ${note.trackingId}");
              //make usre timezones are same, and dateformats okay and same
              //if modified times are same, then no update happened, and this is a note that was prevously pushed from this local server to main after sync time/pulling time
              continue;
            } else if (!(noteExists.synced!)) {
              // there is a conflict as it modified online but also locally
              print(
                  "conflict as it modified online but also locally, ${note.trackingId}");
            } else {
              print("another modified time, no conflict ${note.trackingId}");
              //we need the auto _id in order to update
              // we also need to resolve mergeConflicts
              // await NoteTable.update(note.copyWith(id: noteExists.id));
            }
          } else {
            // create
            NoteModel? createdNote = await NoteTable.create(
                note.copyWith(mergeConflict: false, synced: true));
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
}
