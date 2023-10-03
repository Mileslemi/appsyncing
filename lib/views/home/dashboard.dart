import 'package:appsyncing/common_widgets/loading_widget.dart';
import 'package:appsyncing/repository/syncing/sync_controller.dart';
import 'package:appsyncing/views/addEditNote/add_edit_note.dart';
import 'package:appsyncing/views/home/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/sizes.dart';
import '../../repository/authentication/authentication_controller.dart';

class DashBoard extends StatelessWidget {
  const DashBoard({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardCtrl = Get.find<DashBoardController>();
    final authCtrl = Get.find<AuthenticationController>();
    final syncCtrl = Get.find<SyncController>();
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text("Branch: ${authCtrl.localBranch.value.branchName}"),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              await SyncController.instance.checkIfConflict();
            },
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: Column(
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
            child: Stack(
              children: [
                Obx(
                  () => dashboardCtrl.pages.elementAt(
                    dashboardCtrl.currentPage.value,
                  ),
                ),
                Obx(
                  () => syncCtrl.syncing.value
                      ? const LoadingWidget()
                      : const SizedBox(),
                )
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Get.to(
          () => AddEditeNote(title: "Add Note"),
          //arguments: {"": ""},
        ),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
            currentIndex: dashboardCtrl.currentPage.value,
            onTap: (value) {
              if (value > dashboardCtrl.pages.length - 1) {
                dashboardCtrl.currentPage.value = 0;
              } else {
                dashboardCtrl.currentPage.value = value;
              }
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'All Notes',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.computer),
                label: 'Local Notes',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.warning_amber_rounded),
                label: 'Conflicts',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.refresh),
                label: 'Unsynced Notes',
              ),
            ]),
      ),
    );
  }
}
