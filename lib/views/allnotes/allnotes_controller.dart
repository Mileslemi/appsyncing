import 'dart:convert';

import 'package:appsyncing/models/note_model.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AllNotesController extends GetxController {
  static AllNotesController get instance => Get.find();

  RxList<NoteModel> allLocalNotes = RxList([]);

  RxString lastSync = "2023-09-13 ...".obs;

  RxBool fetching = false.obs;
  RxBool syncing = false.obs;

  @override
  void onInit() async {
    allLocalNotes.value = await fetchAllLocalNotes();

    ever(syncing, (callback) => fetchLastSyncTime());
    super.onInit();
  }

  Future<List<NoteModel>> fetchAllLocalNotes() async {
    fetching.value = true;
    //await Future.delayed(const Duration(seconds: 3));
    try {
      final data = await rootBundle.loadString("assets/files/local_notes.json");

      List collection = jsonDecode(data);

      Get.log("Notes : $collection");

      List<NoteModel> allNotes =
          collection.map((e) => NoteModel.fromMap(e)).toList();

      fetching.value = false;
      update();
      return allNotes;
    } on Exception catch (e) {
      Get.log("$e");
      Get.snackbar("Error!", "Could not fetch Notes.");
    }
    fetching.value = false;
    update();
    return [];
  }

  Future<List<NoteModel>> fetchAllOnlyLocalMadeNotes() async {
    return [];
  }

  Future<List<NoteModel>> fetchConflictNotes() async {
    return [];
  }

  void fetchLastSyncTime() {
    // new sync time
    // make a sync log time table

    lastSync.value = "New Sync Time";
  }
}
