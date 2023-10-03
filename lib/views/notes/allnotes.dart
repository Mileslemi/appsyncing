import 'dart:io';

import 'package:appsyncing/common_widgets/loading_widget.dart';
import 'package:appsyncing/common_widgets/note_display.dart';
import 'package:appsyncing/views/notes/notes_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common_widgets/conflict_warning_widget.dart';

class AllNotes extends StatelessWidget {
  const AllNotes({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Stack(
        children: [
          GetBuilder<NotesController>(builder: (controller) {
            return Stack(
              children: [
                controller.allNotes.isNotEmpty
                    ? (Platform.isIOS || Platform.isAndroid)
                        ? buildNotes(controller.allNotes)
                        : buildNotesDeskTop(controller.allNotes)
                    : const Center(
                        child: Text("No Notes...."),
                      ),
                controller.fetching.value
                    ? const LoadingWidget()
                    : const SizedBox(),
              ],
            );
          }),
          const ConflictWarningWidget()
        ],
      ),
    );
  }
}
