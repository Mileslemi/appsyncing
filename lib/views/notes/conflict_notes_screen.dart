import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common_widgets/note_display.dart';
import 'notes_controller.dart';

class ConflictNotesScreen extends StatelessWidget {
  const ConflictNotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notesCtrl = Get.find<NotesController>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Obx(() => notesCtrl.conflictNotes.isNotEmpty
          ? (Platform.isIOS || Platform.isAndroid)
              ? buildNotes(notesCtrl.conflictNotes)
              : buildNotesDeskTop(notesCtrl.conflictNotes)
          : const Center(
              child: Text("No Conflict Notes...."),
            )),
    );
  }
}
