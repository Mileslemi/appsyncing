import 'package:flutter/material.dart';

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
        color: const Color.fromARGB(120, 0, 0, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            (note?.synced ?? false)
                ? const Icon(
                    Icons.add_task_outlined,
                    semanticLabel: "Sync",
                    color: Colors.green,
                  )
                : IconButton(
                    onPressed: () {
                      // if mergeConflict is true then don't sync until resolve
                      // resolving is to compare the two rows, the other being in theConflicts table,
                      // and updating this one, setting conflict to false, and deleting the row in theConflict table
                    },
                    icon: const Icon(Icons.upload),
                  ),
            (note?.mergeConflict ?? false)
                ? IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.warning),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
