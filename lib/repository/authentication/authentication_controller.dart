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
    bool authenticated = false;
    final response = await NetworkHandler.post(
        url: UrlStrings.authenticateUser(),
        body: {"username": username, "password": password});

    if (response is Success) {
      try {
        Success s = response as Success;
        var data = jsonDecode(s.returnValue);
        print(data);
        //retuned as  { "authenticated": true,  "user": { "first_name": "Miles", "last_name": "Lemi", "email": "mileslemi@gmail.com" } }
        //  or { "authenticated": false}
        authenticated = data['authenticated'];

        if (authenticated) {
          print("yes, is authernticated");
          // set user to add to local table if all goes well adding branch
          Map fetchedUser = data['user'];
          user.value = BranchUser(
              username: username,
              password: password,
              firstName: fetchedUser['first_name'],
              lastName: fetchedUser['last_name'],
              email: fetchedUser['email'],
              isAdmin: true);
        }

        return authenticated;
      } catch (e) {
        Get.log("Error Fetching: $e");
        Get.snackbar("Authentication Error", "Try Again Later.");
      }
    } else {
      Get.log("Error Authenticating: $response");
      Get.snackbar("Error Authenticating User", "$response");
    }
    return authenticated;
  }

  Future<int> addBranchToLocalTable({required int id}) async {
    // add first to local table,

    // confirm added
    int count = await BranchTable.branchCount();
    if (count == 1) {
      // update master

      // if it returns 1, then all well,
      // else delete the branch table row, return unsuccessful
    }

    // // returns 1 if succesfully updated master and added to Local
    return 0;
  }
}
