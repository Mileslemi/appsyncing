import 'dart:convert';

import 'package:appsyncing/exception/exception_handling.dart';
import 'package:appsyncing/models/branch_model.dart';
import 'package:appsyncing/repository/Network/network_handler.dart';
import 'package:get/get.dart';

import '../../constants/string_constants.dart';
import '../../db/branch_table.dart';
import '../../models/user_model.dart';

class AuthenticationController extends GetxController {
  static AuthenticationController get instance => Get.find();

  RxList<MasterBranch> masterBranches = RxList([]);

  Rx<Branch> branch = Rx(Branch());
  late Rx<BranchUser> user;

  @override
  void onInit() {
    user = Rx(BranchUser(username: "mileslemi", password: "1234"));
    countLocalBranches();
    super.onInit();
  }

  Future<void> countLocalBranches() async {
    int count = await BranchTable.branchCount();
    // if count is 0, new db, assert that other tables are empty also, cause maybe this branch table is deleted/corrupted but the server has been in use
    // if so, quick fix would be to change assigned to false in the master to allow user to selct that same server again.
    print(count);
    if (count < 1) {
      // if all empty, then allow user to choose branch[fetched from online master db]
      // disbale those already assigned
      print("fetching online branches");
      fecthOnlineBranches();
    } else if (count == 1) {
      //meaning is equal to 1
      print("fetching local branch");
      fetchLocalBranch();
    }
  }

  Future<void> fetchLocalBranch() async {
    List<Branch> localBranches = await BranchTable.read();

    if (localBranches.isNotEmpty) {
      branch.value = localBranches[0];
    }
  }

  Future<void> fecthOnlineBranches() async {
    final result = await NetworkHandler.get(UrlStrings.getBranches());

    if (result is Success) {
      Success s = result as Success;

      try {
        List collection = jsonDecode(s.returnValue);

        print(collection);

        List<MasterBranch> fetched =
            collection.map((e) => MasterBranch.fromMap(e)).toList();
        masterBranches.value = fetched;
      } catch (e) {
        Get.log("Error Fetching: $e");
        Get.snackbar("Error", "Error. Try Again Later.");
      }
    } else {
      Get.log("Error Fetching: $result");
      Get.snackbar("Error", "$result");
    }
  }
}
