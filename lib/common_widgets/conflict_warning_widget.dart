import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../repository/syncing/sync_controller.dart';
import '../views/home/dashboard_controller.dart';

class ConflictWarningWidget extends StatelessWidget {
  const ConflictWarningWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => !(SyncController.instance.syncing.value) &&
            SyncController.instance.displayConflictWarning.value
        ? CupertinoAlertDialog(
            title: const Text("Warning!"),
            content: Text(
              "Conflict Impede Syncing. Resolve Conflicts.",
              style: Theme.of(context).textTheme.bodySmall,
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  DashBoardController.instance.currentPage.value = 2;
                },
                child: const Text("Resolve"),
              ),
              TextButton(
                onPressed: () {
                  SyncController.instance.displayConflictWarning.value = false;
                },
                child: const Text('Dismiss'),
              ),
            ],
          )
        : const SizedBox());
  }
}
