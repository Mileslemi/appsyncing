import 'package:appsyncing/views/home/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashBoard extends StatelessWidget {
  const DashBoard({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardCtrl = Get.find<DashBoardController>();
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text("Branch: ${dashboardCtrl.branchName}")),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Obx(() => Text("Last Sync: ${dashboardCtrl.lastSync}")),
          Expanded(child: ListView()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {},
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
            currentIndex: dashboardCtrl.currentPage.value,
            onTap: (value) {
              dashboardCtrl.currentPage.value = value;
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
            ]),
      ),
    );
  }
}
