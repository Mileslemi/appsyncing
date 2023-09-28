import 'dart:io';

import 'package:appsyncing/repository/syncing/sync_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common_widgets/loading_widget.dart';
import '../../common_widgets/note_display.dart';
import '../../constants/sizes.dart';

import '../../repository/authentication/authentication_controller.dart';
import 'notes_controller.dart';

class LocalNotes extends StatelessWidget {
  const LocalNotes({super.key});

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
                          ? buildNotes(controller.localNotes)
                          : buildNotesDeskTop(controller.localNotes)
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
