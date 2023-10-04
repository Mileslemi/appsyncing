import 'package:appsyncing/models/note_model.dart';
import 'package:appsyncing/repository/authentication/authentication_controller.dart';
import 'package:get/get.dart';

import '../../db/note_table.dart';

class NotesController extends GetxController {
  static NotesController get instance => Get.find();

  final authCtrl = Get.find<AuthenticationController>();

  RxList<NoteModel> allNotes = RxList([]);

  RxList<NoteModel> localNotes = RxList([]);

  RxList<NoteModel> conflictNotes = RxList([]);

  RxList<NoteModel> unSyncedNotes = RxList([]);

  RxBool fetching = false.obs;
  RxBool syncing = false.obs;

  @override
  void onInit() async {
    fetchAllNotes();
    fetchAllOnlyLocalMadeNotes();
    fetchConflictNotes();
    fetchUnsyncedNotes();

    ever(authCtrl.localBranch, (callback) => updatesNotesList());
    super.onInit();
  }

  void updatesNotesList() {
    fetchAllNotes();
    fetchAllOnlyLocalMadeNotes();
    fetchConflictNotes();
    fetchUnsyncedNotes();
    refresh();
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

  Future<void> fetchUnsyncedNotes() async {
    try {
      unSyncedNotes.value = await NoteTable.getUnsycedNotes();

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
