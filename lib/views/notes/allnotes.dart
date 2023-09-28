import 'dart:io';

import 'package:appsyncing/common_widgets/loading_widget.dart';
import 'package:appsyncing/common_widgets/note_display.dart';
import 'package:appsyncing/repository/authentication/authentication_controller.dart';
import 'package:appsyncing/views/notes/notes_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/sizes.dart';
import '../../repository/syncing/sync_controller.dart';

class AllNotes extends StatelessWidget {
  const AllNotes({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final authCtrl = Get.find<AuthenticationController>();
    final syncCtrl = Get.find<SyncController>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                    "Welcome, ${authCtrl.user.value.firstName} ${authCtrl.user.value.lastName}"),
                Text(
                  "Last Sync: ${syncCtrl.lastNoteSyncToDisplay}",
                ),
              ],
            ),
          ),
          const SizedBox(
            height: defaultSpacing,
          ),
          Expanded(
            child: GetBuilder<NotesController>(builder: (controller) {
              return Stack(
                children: [
                  controller.allNotes.isNotEmpty
                      ? (Platform.isIOS || Platform.isAndroid)
                          ? buildNotes(controller.allNotes)
                          : buildNotesDeskTop(controller.allNotes)
                      : const Center(
                          child: Text("No Notes...."),
                        ),
                  controller.fetching.value
                      ? const LoadingWidget()
                      : const SizedBox(),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
