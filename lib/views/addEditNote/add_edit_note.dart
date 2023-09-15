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
                          horizontal: 4, vertical: 8),
                      color: const Color.fromARGB(120, 0, 0, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          (note?.synced ?? false)
                              ? IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.upload),
                                )
                              : const Icon(
                                  Icons.add_task_outlined,
                                  semanticLabel: "Sync",
                                  color: Colors.green,
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
    return Row(
      children: [
        Text(title),
        Expanded(
          child: TextFormField(
            initialValue: detail,
            enabled: false,
          ),
        ),
      ],
    );
  }
}
