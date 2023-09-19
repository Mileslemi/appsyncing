import 'dart:io';

const String emailValidationPattern =
    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+.[a-zA-Z0-9-]+$";
//this below regex validates without a .something end e.g., miles@localhost
//r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$";
const String phoneNoValidationPattern = r"^(?:[+0])[0-9]{9,16}$";

const String positiveNumericValuePattern = r"^[0-9]+([.][0-9]+)?$";

const String apiUsername = "ck_e42a54fb75e8c52894547034e190c566fb3cad96";
const String apiPassword = "cs_d9adc62d6af04b8aea0cc17b356796cc148bdec7";

class UrlStrings {
  UrlStrings._();
  static String myApiBaseUrl =
      (Platform.isWindows || Platform.isMacOS || Platform.isLinux)
          ? "http://127.0.0.1:8000"
          : "http://10.0.2.2:8000";

  static String getBranches() {
    return "$myApiBaseUrl/getBranches/";
  }

  static String updateBranch() {
    return "$myApiBaseUrl/updateBranch/";
  }

  static String authenticateUser() {
    return "$myApiBaseUrl/authUser/";
  }
}
