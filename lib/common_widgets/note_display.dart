import 'dart:math';

import 'package:appsyncing/models/note_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

Widget buildNotes(List<NoteModel> notes) => GridView.custom(
      gridDelegate: SliverQuiltedGridDelegate(
        crossAxisCount: 4,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        repeatPattern: QuiltedGridRepeatPattern.inverted,
        pattern: [
          const QuiltedGridTile(2, 2),
          const QuiltedGridTile(1, 1),
          const QuiltedGridTile(1, 1),
          const QuiltedGridTile(1, 2),
        ],
      ),
      childrenDelegate: SliverChildBuilderDelegate(
        childCount: notes.length,
        (context, index) {
          final NoteModel note = notes[index];
          return GestureDetector(onTap: () {}, child: noteTile(note));
        },
      ),
    );

Widget noteTile(NoteModel note) => Card(
      elevation: 1,
      color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              note.title ?? '',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            Text(
              note.description ?? '',
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
