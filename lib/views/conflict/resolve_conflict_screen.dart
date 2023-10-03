import 'package:appsyncing/common_methods/sync_notes_functions.dart';
import 'package:appsyncing/common_widgets/loading_widget.dart';

import 'package:appsyncing/views/conflict/resolve_conflict_ctrl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app_routing/app_routes.dart';
import '../../constants/sizes.dart';

class ResolveConflictScreen extends StatelessWidget {
  const ResolveConflictScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final resolveConflictCtrl = Get.find<ResolveConflictController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Resolve Conflict"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextFormField(
                  initialValue: resolveConflictCtrl.note?.trackingId,
                  enabled: false,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.track_changes)),
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
                            controller: resolveConflictCtrl.localtitleCtrl,
                            keyboardType: TextInputType.text,
                            enabled: false,
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
                            controller: resolveConflictCtrl.localDescCtrl,
                            keyboardType: TextInputType.text,
                            minLines: 4,
                            maxLines: 5,
                            enabled: false,
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Online Modifications"),
                            const SizedBox(
                              height: defaultSpacing,
                            ),
                            TextFormField(
                              controller: resolveConflictCtrl.onlinetitleCtrl,
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
                              controller: resolveConflictCtrl.onlineDescCtrl,
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
                        ))
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    Get.dialog(
                      barrierDismissible: false,
                      CupertinoAlertDialog(
                        title: const Text("Warning!"),
                        content: Text(
                          "This will override local modifications with the modifications on right.",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () async {
                              // close the dialog first
                              Get.back();
                              resolveConflictCtrl.merging.value = true;

                              await SyncFunctions.merge(
                                  mergedNote: resolveConflictCtrl.note
                                      ?.copyWith(
                                          title: resolveConflictCtrl
                                              .onlinetitleCtrl.text,
                                          description: resolveConflictCtrl
                                              .onlineDescCtrl.text,
                                          lastModified: DateTime.now().toUtc(),
                                          mergeConflict: false),
                                  noteConflict:
                                      resolveConflictCtrl.theConflict);
                              resolveConflictCtrl.merging.value = true;
                              // setting overlays to true pops the dialog and backs one page
                              // Get.back(closeOverlays: true);
                              // go to dashboard
                              Get.offAndToNamed(AppRoutes.dashboard);
                            },
                            child: const Text("Ok"),
                          ),
                          TextButton(
                            onPressed: () {
                              Get.back();
                              // Navigator.of(context, rootNavigator: true).pop();
                            },
                            child: const Text('Cancel'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text("Merge"),
                )
              ],
            ),
          ),
          Obx(() => resolveConflictCtrl.merging.value
              ? const LoadingWidget()
              : const SizedBox())
        ],
      ),
    );
  }
}
