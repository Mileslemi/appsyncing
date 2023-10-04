import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common_widgets/note_display.dart';
import 'notes_controller.dart';

class ConflictNotesScreen extends StatelessWidget {
  const ConflictNotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GetBuilder<NotesController>(builder: (controller) {
        return controller.conflictNotes.isNotEmpty
            ? (Platform.isIOS || Platform.isAndroid)
                ? buildNotes(controller.conflictNotes)
                : buildNotesDeskTop(controller.conflictNotes)
            : const Center(
                child: Text("No Conflict Notes...."),
              );
      }),
    );
  }
}
