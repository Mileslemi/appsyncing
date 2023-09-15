import 'dart:math';

import 'package:appsyncing/models/note_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

import '../views/addEditNote/add_edit_note.dart';

List<Color> noteColors = [
  Colors.grey,
  Colors.blueGrey,
  Colors.brown,
  Colors.purple
];
Widget buildNotesDeskTop(List<NoteModel> notes) => GridView.custom(
      gridDelegate: SliverWovenGridDelegate.count(
        crossAxisCount: 3,
        mainAxisSpacing: 6,
        crossAxisSpacing: 4,
        pattern: [
          const WovenGridTile(1),
          const WovenGridTile(
            0.9,
            crossAxisRatio: 1,
            alignment: AlignmentDirectional.centerEnd,
          ),
          const WovenGridTile(1.2),
        ],
      ),
      childrenDelegate: SliverChildBuilderDelegate(
        childCount: notes.length,
        (context, index) {
          final NoteModel note = notes[index];
          return InkWell(
              onTap: () => Get.to(
                    () => AddEditeNote(
                      title: "Update Note",
                      note: note,
                    ),
                    //arguments: {"": ""},
                  ),
              child: noteTile(note));
        },
      ),
    );

//for andoid and Ios
Widget buildNotes(List<NoteModel> notes) => ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final NoteModel note = notes[index];
        return GestureDetector(
            onTap: () => Get.to(
                  () => AddEditeNote(
                    title: "Update Note",
                    note: note,
                  ),
                  //arguments: {"": ""},
                ),
            child: noteTile(note));
      },
    );

Widget noteTile(NoteModel note) => Card(
      elevation: 1,
      color: noteColors[Random().nextInt(noteColors.length)],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Title : ${note.title ?? ''}",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                (note.synced ?? false)
                    ? const Icon(
                        Icons.add_task_outlined,
                        semanticLabel: "Sync",
                        color: Colors.green,
                      )
                    : const Icon(
                        Icons.info,
                        semanticLabel: "Sync",
                        color: Colors.amber,
                      )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Branch : ${note.branchName ?? ''}",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
                (note.mergeConflict ?? false)
                    ? const Icon(
                        Icons.warning,
                        semanticLabel: "Conflict",
                        color: Colors.amber,
                      )
                    : const SizedBox()
              ],
            ),
            Text(
              "Tracking ID: ${note.trackingId ?? ''}",
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            ),
            Text(
              "Posted At : ${note.posted ?? ''}",
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
