import 'dart:convert';

import 'package:appsyncing/constants/string_constants.dart';
import 'package:appsyncing/exception/exception_handling.dart';
import 'package:appsyncing/models/note_model.dart';
import 'package:appsyncing/repository/Network/network_handler.dart';

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
    for (NoteModel note in onlineNotes) {
      // if trackingID exists, check conflict first, then update if no conflict
      // else, create
    }

    return true;
  }
}
