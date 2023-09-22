import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ADateTimeFunctions {
  ADateTimeFunctions._();

  static String convertDate(
      {required String formatNeeded, required String? theDateString}) {
    try {
      DateTime theDate = DateTime.parse(theDateString!);
      return DateFormat(formatNeeded).format(theDate);
    } catch (e) {
      Get.log("No DateTime Object Recieved");
      return "null";
    }
  }

  static int dateDifferenceInDays(DateTime? val, DateTime? val2) {
    try {
      int diff = val!.difference(val2!).inDays;
      return diff;
    } catch (e) {
      return 0;
    }
  }

  static int dateDifferenceInHours(DateTime? val, DateTime? val2) {
    try {
      int diff = val!.difference(val2!).inHours;
      return diff;
    } catch (e) {
      return 0;
    }
  }

  static int dateDifferenceInMin(DateTime? val, DateTime? val2) {
    try {
      int diff = val!.difference(val2!).inMinutes;
      return diff;
    } catch (e) {
      return 0;
    }
  }

  static dynamic stringdateDifferenceInDays(String? val, String? val2) {
    try {
      DateTime val1Date = DateTime.parse(val!);
      DateTime val2Date = DateTime.parse(val2!);
      int diff = val1Date.difference(val2Date).inDays;
      return diff;
    } catch (e) {
      return null;
    }
  }

  // static dynamic stringdateDifferenceInHours(String? val, String? val2) {
  //   try {
  //     DateTime val1Date = DateTime.parse(val!);
  //     DateTime val2Date = DateTime.parse(val2!);
  //     int diff = val1Date.difference(val2Date).inHours;
  //     return diff;
  //   } catch (e) {
  //     return null;
  //   }
  // }
}
