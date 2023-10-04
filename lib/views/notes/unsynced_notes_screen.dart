import 'dart:io';

import 'package:appsyncing/common_widgets/conflict_warning_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common_widgets/note_display.dart';
import 'notes_controller.dart';

class UnSyncedNotesScreen extends StatelessWidget {
  const UnSyncedNotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Stack(
        children: [
          GetBuilder<NotesController>(builder: (controller) {
            return controller.unSyncedNotes.isNotEmpty
                ? (Platform.isIOS || Platform.isAndroid)
                    ? buildNotes(controller.unSyncedNotes)
                    : buildNotesDeskTop(controller.unSyncedNotes)
                : const Center(
                    child: Text("No Conflict Notes...."),
                  );
          }),
          const ConflictWarningWidget()
        ],
      ),
    );
  }
}
