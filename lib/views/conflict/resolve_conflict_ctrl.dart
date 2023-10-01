import 'package:appsyncing/models/note_conflict_model.dart';
import 'package:appsyncing/models/note_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../db/note_conflict_table.dart';

class ResolveConflictController extends GetxController {
  static ResolveConflictController get instance => Get.find();

  dynamic argumets = Get.arguments;

  RxBool merging = false.obs;

  late NoteModel? note;
  NoteConflict? theConflict;

  TextEditingController localtitleCtrl = TextEditingController();
  TextEditingController localDescCtrl = TextEditingController();
  TextEditingController onlinetitleCtrl = TextEditingController();
  TextEditingController onlineDescCtrl = TextEditingController();

  @override
  void onInit() async {
    note = argumets['note'];
    theConflict = await getNoteConflict(note);

    localtitleCtrl.text = note?.title ?? 'null';
    localDescCtrl.text = note?.description ?? '';

    onlinetitleCtrl.text = theConflict?.title ?? '';
    onlineDescCtrl.text = theConflict?.description ?? '';
    super.onInit();
  }

  Future<NoteConflict?> getNoteConflict(NoteModel? note) async {
    try {
      NoteConflict? noteConflict = await NoteConflictTable.getConflict(
          trackingId: note?.trackingId ?? '');

      return noteConflict;
    } catch (_) {
      return null;
    }
  }
}
