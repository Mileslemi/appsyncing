import 'dart:io';

import 'package:appsyncing/views/addEditNote/add_edit_ctrl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common_methods/date_functions.dart';
import '../../common_widgets/note_extra_info.dart';
import '../../constants/sizes.dart';

class AddEditeNote extends StatelessWidget {
  // make sure you provide a note argument, empty note for adding, and a note for updating
  AddEditeNote({required this.title, super.key});

  final String title;
  // if notemodel is null, adding, else edit

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final addEditCtrl = Get.find<AddEditController>();
    // if (note != null) {
    //   // we can't do this here, phone keyboard cause a reload/build on dismiss,
    //   // returning text inputs to waht is decalared here
    //   addEditCtrl.titleText.text = note?.title ?? '';
    //   addEditCtrl.descText.text = note?.description ?? '';
    // }
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
                  addEditCtrl.note == null
                      ? const SizedBox()
                      : Column(
                          children: [
                            TextFormField(
                              initialValue: addEditCtrl.note?.trackingId,
                              enabled: false,
                              decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.track_changes)),
                            ),
                            const SizedBox(
                              height: defaultSpacing,
                            ),
                            NoteDetailRow(
                                title: "Editor",
                                detail: "${addEditCtrl.note?.user}"),
                            NoteDetailRow(
                              title: "Created",
                              detail: ADateTimeFunctions.convertToFormat(
                                  formatNeeded: "H:mm y-MM-dd",
                                  dateTime:
                                      addEditCtrl.note?.posted?.toLocal()),
                            ),
                            NoteDetailRow(
                                title: "At Branch",
                                detail: "${addEditCtrl.note?.branchName}"),
                            NoteDetailRow(
                              title: "Last Modified",
                              detail: ADateTimeFunctions.convertToFormat(
                                  formatNeeded: "H:mm y-MM-dd",
                                  dateTime: addEditCtrl.note?.lastModified
                                      ?.toLocal()),
                            ),
                            (addEditCtrl.note?.synced ?? false)
                                ? NoteDetailRow(
                                    title: "Master DB Id",
                                    detail: "${addEditCtrl.note?.masterId}")
                                : const SizedBox()
                          ],
                        ),
                  TextFormField(
                    controller: addEditCtrl.titleText,
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
                    controller: addEditCtrl.descText,
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
                  addEditCtrl.note == null
                      ? ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              addEditCtrl.addLcalNote(
                                  title: addEditCtrl.titleText.text,
                                  desc: addEditCtrl.descText.text);
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
                                    if (addEditCtrl.note?.id != null) {
                                      if (!(addEditCtrl.note?.mergeConflict ??
                                          false)) {
                                        // don't update if there is conflict
                                        addEditCtrl.updateNote(
                                            note: addEditCtrl.note!,
                                            title: addEditCtrl.titleText.text,
                                            desc: addEditCtrl.descText.text);
                                      } else {
                                        Get.snackbar("Invalid",
                                            "Resolve the conflict first");
                                      }
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
            addEditCtrl.note != null
                ? NoteExtraInfo(note: addEditCtrl.note)
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
