import 'package:appsyncing/models/note_conflict_model.dart';
import 'package:appsyncing/models/note_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common_widgets/loading_widget.dart';
import '../../constants/sizes.dart';
import '../../db/note_conflict_table.dart';

class ResolveConflictScreen extends StatelessWidget {
  const ResolveConflictScreen({required this.note, super.key});

  final NoteModel? note;

  @override
  Widget build(BuildContext context) {
    Future<NoteConflict?> getNoteConflict() async {
      try {
        NoteConflict? noteConflict = await NoteConflictTable.getConflict(
            trackingId: note?.trackingId ?? '');

        return noteConflict;
      } catch (_) {
        return null;
      }
    }

    TextEditingController localtitleCtrl = TextEditingController();
    TextEditingController localDescCtrl = TextEditingController();
    TextEditingController onlinetitleCtrl = TextEditingController();
    TextEditingController onlineDescCtrl = TextEditingController();

    localtitleCtrl.text = note?.title ?? 'null';
    localDescCtrl.text = note?.description ?? '';
    return Scaffold(
      appBar: AppBar(
        title: const Text("Resolve Conflict"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextFormField(
              initialValue: note?.trackingId,
              enabled: false,
              decoration:
                  const InputDecoration(prefixIcon: Icon(Icons.track_changes)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * .46,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Local Modifications"),
                      const SizedBox(
                        height: defaultSpacing,
                      ),
                      TextFormField(
                        controller: localtitleCtrl,
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
                        controller: localDescCtrl,
                        keyboardType: TextInputType.text,
                        minLines: 4,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          labelText: "Description",
                          hintText: "Note Description",
                          prefixIcon: Icon(Icons.book),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .46,
                  child: FutureBuilder<NoteConflict?>(
                    future: getNoteConflict(),
                    builder: (context, snapshot) {
                      List<Widget> children;
                      if (snapshot.hasData) {
                        NoteConflict? noteConflict = snapshot.data;
                        if (noteConflict != null) {
                          onlinetitleCtrl.text = noteConflict.title ?? '';
                          onlineDescCtrl.text = noteConflict.description ?? '';
                          children = [
                            const Text("Online Modifications"),
                            const SizedBox(
                              height: defaultSpacing,
                            ),
                            TextFormField(
                              controller: onlinetitleCtrl,
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
                              controller: onlineDescCtrl,
                              keyboardType: TextInputType.text,
                              minLines: 4,
                              maxLines: 5,
                              decoration: const InputDecoration(
                                labelText: "Description",
                                hintText: "Note Description",
                                prefixIcon: Icon(Icons.book),
                              ),
                            ),
                          ];
                        } else {
                          children = [
                            const Center(
                              child: Text("Error Loading the Conflict"),
                            )
                          ];
                        }
                      } else if (snapshot.hasError) {
                        children = [
                          const Center(
                            child: Text("Error Loading the Conflict"),
                          )
                        ];
                      } else {
                        children = [
                          const Center(
                            child: LoadingWidget(),
                          )
                        ];
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: children,
                      );
                    },
                  ),
                )
              ],
            ),
            ElevatedButton(
              onPressed: () {
                Get.defaultDialog(
                  content: Text(
                    "This will override local modifications with fetched online modifications.",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  confirm:
                      TextButton(onPressed: () {}, child: const Text("Ok")),
                  cancel:
                      TextButton(onPressed: () {}, child: const Text('Cancel')),
                  onCancel: () => Get.back(),
                  onConfirm: () => Get.log("confirmed"),
                );
              },
              child: const Text("Merge"),
            )
          ],
        ),
      ),
    );
  }
}
