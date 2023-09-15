import 'package:appsyncing/models/note_model.dart';
import 'package:flutter/material.dart';

import '../../constants/sizes.dart';

class AddEditeNote extends StatelessWidget {
  AddEditeNote({required this.title, this.note, super.key});

  final String title;
  final NoteModel? note;
  // if notemodel is null, adding, else edit

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Form(
              key: formKey,
              child: ListView(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * .1),
                children: [
                  note == null
                      ? const SizedBox()
                      : Column(
                          children: [
                            TextFormField(
                              initialValue: note?.trackingId,
                              enabled: false,
                              decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.track_changes)),
                            ),
                            const SizedBox(
                              height: defaultSpacing,
                            ),
                            NoteDetailRow(
                                title: "Creator", detail: "${note?.user}"),
                            NoteDetailRow(
                                title: "Created", detail: "${note?.posted}"),
                            NoteDetailRow(
                                title: "At Branch",
                                detail: "${note?.branchName}"),
                            NoteDetailRow(
                              title: "Last Modified",
                              detail: "${note?.lastModified}",
                            ),
                            (note?.synced ?? false)
                                ? NoteDetailRow(
                                    title: "Master DB Id",
                                    detail: "${note?.masterId}")
                                : const SizedBox()
                          ],
                        ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: "Title",
                      hintText: "Note Title",
                      prefixIcon: Icon(Icons.title),
                    ),
                  ),
                  const SizedBox(
                    height: defaultSpacing,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    minLines: 4,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      labelText: "Description",
                      hintText: "Note Description",
                      prefixIcon: Icon(Icons.book),
                    ),
                  ),
                  const SizedBox(
                    height: defaultSpacing,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {}
                    },
                    child:
                        note == null ? const Text("ADD") : const Text("UPDATE"),
                  )
                ],
              ),
            ),
            note != null
                ? Positioned(
                    right: 5,
                    top: 5,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 8),
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
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}

class NoteDetailRow extends StatelessWidget {
  const NoteDetailRow({super.key, required this.title, required this.detail});

  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title),
            SizedBox(
              width: MediaQuery.of(context).size.width * .6,
              child: TextFormField(
                initialValue: detail,
                enabled: false,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: defaultSpacing,
        ),
      ],
    );
  }
}
