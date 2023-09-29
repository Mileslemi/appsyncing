import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common_widgets/loading_widget.dart';
import '../../common_widgets/note_display.dart';
import 'notes_controller.dart';

class UnSyncedNotesScreen extends StatelessWidget {
  const UnSyncedNotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GetBuilder<NotesController>(builder: (controller) {
        return Stack(
          children: [
            controller.unSyncedNotes.isNotEmpty
                ? (Platform.isIOS || Platform.isAndroid)
                    ? buildNotes(controller.unSyncedNotes)
                    : buildNotesDeskTop(controller.unSyncedNotes)
                : const Center(
                    child: Text("No Conflict Notes...."),
                  ),
            controller.fetching.value
                ? const LoadingWidget()
                : const SizedBox(),
          ],
        );
      }),
    );
  }
}
