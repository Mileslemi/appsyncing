import 'package:appsyncing/models/note_model.dart';
import 'package:flutter/material.dart';

import '../../common_widgets/note_extra_info.dart';
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
            note != null ? NoteExtraInfo(note: note) : const SizedBox(),
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
