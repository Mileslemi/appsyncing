import 'dart:io';

import 'package:appsyncing/models/note_model.dart';
import 'package:appsyncing/views/notes/notes_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common_methods/date_functions.dart';
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
    final notesCtrl = Get.find<NotesController>();
    if (note != null) {
      notesCtrl.titleText.text = note?.title ?? '';
      notesCtrl.descText.text = note?.description ?? '';
    }
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
                    horizontal: MediaQuery.of(context).size.width * .05),
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
                              title: "Created",
                              detail: ADateTimeFunctions.convertToFormat(
                                  formatNeeded: "H:mm y-MM-dd",
                                  dateTime: note?.posted?.toLocal()),
                            ),
                            NoteDetailRow(
                                title: "At Branch",
                                detail: "${note?.branchName}"),
                            NoteDetailRow(
                              title: "Last Modified",
                              detail: ADateTimeFunctions.convertToFormat(
                                  formatNeeded: "H:mm y-MM-dd",
                                  dateTime: note?.lastModified?.toLocal()),
                            ),
                            (note?.synced ?? false)
                                ? NoteDetailRow(
                                    title: "Master DB Id",
                                    detail: "${note?.masterId}")
                                : const SizedBox()
                          ],
                        ),
                  TextFormField(
                    controller: notesCtrl.titleText,
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
                    controller: notesCtrl.descText,
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
                  note == null
                      ? ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              notesCtrl.addLcalNote(
                                  title: notesCtrl.titleText.text,
                                  desc: notesCtrl.descText.text);
                            }
                          },
                          child: const Text("ADD"),
                        )
                      : Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  Get.snackbar("Invalid",
                                      "This action can only be done online");
                                },
                                child: const Text("DELETE"),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    if (note?.id != null) {
                                      notesCtrl.updateNote(
                                          note: note!,
                                          title: notesCtrl.titleText.text,
                                          desc: notesCtrl.descText.text);
                                    }
                                  }
                                },
                                child: const Text("UPDATE"),
                              ),
                            )
                          ],
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
        (Platform.isIOS || Platform.isAndroid)
            ? TextFormField(
                initialValue: detail,
                enabled: false,
                decoration: InputDecoration(
                  labelText: title,
                ),
              )
            : Row(
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
