import 'package:appsyncing/common_widgets/loading_widget.dart';
import 'package:appsyncing/common_widgets/note_display.dart';
import 'package:appsyncing/views/allnotes/allnotes_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/sizes.dart';

class AllNotes extends StatelessWidget {
  const AllNotes({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final allNotesCtrl = Get.find<AllNotesController>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Obx(
            () => Text(
              "Last Sync: ${allNotesCtrl.lastSync}",
            ),
          ),
          const SizedBox(
            height: defaultSpacing,
          ),
          Expanded(
            child: GetBuilder<AllNotesController>(builder: (controller) {
              return Stack(
                children: [
                  controller.allLocalNotes.isNotEmpty
                      ? buildNotes(controller.allLocalNotes)
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
