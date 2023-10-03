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

  RxList<FetchedOnlineBranch> fetchedOnlineBranches = RxList([]);

  Rx<LocalBranch> localBranch = Rx(LocalBranch());
  Rx<BranchUser> user = Rx(BranchUser());

  @override
  void onInit() {
    countLocalBranches();
    super.onInit();
  }

  Future<void> countLocalBranches() async {
    int count = await BranchTable.branchCount();
    // if count is 0, new db, assert that other tables are empty also, cause maybe this branch table is deleted/corrupted but the server has been in use
    // if so, quick fix would be to change assigned to false in the master to allow user to selct that same server again.

    if (count < 1) {
      // if all empty, then allow user to choose branch[fetched from online master db]
      // disbale those already assigned

      fecthOnlineBranches();
    } else if (count == 1) {
      //meaning is equal to 1

      fetchLocalBranch();
    }
  }

  Future<void> fetchLocalBranch() async {
    List<LocalBranch> localBranches = await BranchTable.read();

    if (localBranches.isNotEmpty) {
      localBranch.value = localBranches[0];
    }
  }

  Future<void> fecthOnlineBranches() async {
    final result = await NetworkHandler.get(UrlStrings.getBranches());

    if (result is Success) {
      Success s = result as Success;

      try {
        List collection = jsonDecode(s.returnValue);

        List<FetchedOnlineBranch> fetched =
            collection.map((e) => FetchedOnlineBranch.fromMap(e)).toList();
        fetchedOnlineBranches.value = fetched;
      } catch (e) {
        Get.log("Error Fetching: $e");
        Get.snackbar("Error", "Error. Try Again Later.");
      }
    } else {
      Get.log("Error Fetching: $result");
      Get.snackbar("Error", "$result");
    }
  }

  Future<bool> authenticateUserOnline(
      {required String username, required String password}) async {
    // checks if user is staff
    bool authenticated = false;
    final response = await NetworkHandler.post(
        url: UrlStrings.authenticateUserUrl(),
        body: {"username": username, "password": password});

    if (response is Success) {
      try {
        Success s = response as Success;
        var data = jsonDecode(s.returnValue);

        //retuned as  { "authenticated": true,  "user": { "first_name": "", "last_name": "", "email": "" } }
        //  or { "authenticated": false}
        authenticated = data['authenticated'];

        if (authenticated) {
          // set user to add to local table if all goes well adding branch
          Map fetchedUser = data['user'];
          user.value = BranchUser(
            username: username,
            password: password,
            firstName: fetchedUser['first_name'],
            lastName: fetchedUser['last_name'],
            email: fetchedUser['email'],
            isAdmin: true,
            joined: DateTime.now().toUtc(),
          );
        }

        return authenticated;
      } catch (e) {
        Get.log("Error Fetching: $e");
        Get.snackbar("Authentication Error", "Try Again Later.");
      }
    } else {
      Get.log("Network Failure Authenticating User Online: $response");
      Get.snackbar("Network Failure", "$response");
    }
    return authenticated;
  }

  Future<bool> updateBranchOnline({required int id}) async {
    final response = await NetworkHandler.post(
        url: UrlStrings.updateBranchUrl(), body: {"id": "$id"});
    if (response is Success) {
      try {
        Success s = response as Success;

        var data = jsonDecode(s.returnValue);
        return data['successful'];
      } catch (_) {}
    }
    return false;
  }

  Future<bool> addBranchToLocalTableAndUpdateOnline(
      {required FetchedOnlineBranch branch}) async {
    // confirm first that table is empty
    int count = await BranchTable.branchCount();
    if (count < 1) {
      // add to local table,

      LocalBranch addedBranch = await BranchTable.create(LocalBranch(
          branchName: branch.branchName, createdAt: DateTime.now().toUtc()));
      // confirm only that added, and one row only exists
      int secondcount = await BranchTable.branchCount();
      if (secondcount == 1) {
        // update master
        bool updated = await updateBranchOnline(id: branch.id!);
        if (updated) {
          await fetchLocalBranch();
          return true;
        } else {
          await BranchTable.delete(addedBranch.id!);
        }
        // if it returns 1, then all well,
        // else delete the branch table row, return unsuccessful
      } else if (secondcount > 1) {
        //  if more than one, maybe another computer has just added, delete row added
        await BranchTable.delete(addedBranch.id!);
      }
    }

    // // returns 1 if succesfully updated master and added to Local
    return false;
  }
}
