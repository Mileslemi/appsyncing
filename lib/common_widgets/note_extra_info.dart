import 'package:appsyncing/views/conflict/resolve_conflict_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/note_model.dart';

class NoteExtraInfo extends StatelessWidget {
  const NoteExtraInfo({
    super.key,
    required this.note,
  });

  final NoteModel? note;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 5,
      top: 5,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 5),
        color: const Color.fromARGB(37, 0, 0, 0),
        child: (note?.synced ?? false)
            ? const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.add_task_outlined,
                  semanticLabel: "Sync",
                  color: Colors.green,
                ),
              )
            : (note?.mergeConflict ?? false)
                ? IconButton(
                    onPressed: () {
                      Get.to(() => ResolveConflictScreen(note: note));
                    },
                    icon: const Icon(
                      Icons.warning,
                      color: Colors.amber,
                    ),
                  )
                : IconButton(
                    onPressed: () {
                      // if mergeConflict is true then don't sync until resolve
                      // resolving is to compare the two rows, the other being in theConflicts table,
                      // and updating this one, setting conflict to false, and deleting the row in theConflict table
                    },
                    icon: const Icon(
                      Icons.upload,
                      color: Colors.white,
                    ),
                  ),
      ),
    );
  }
}
