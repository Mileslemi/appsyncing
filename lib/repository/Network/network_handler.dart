import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../exception/exception_handling.dart';
import 'network_controller.dart';

class NetworkHandler {
  static final client = http.Client();
  static final myApiClient = http.Client();

  // static String basicAuth =
  //     "Basic ${base64.encode(utf8.encode('$apiUsername:$apiPassword'))}";
  //http requests for smashit provided api
  static Future<Result<String, Exception>> get(String url) async {
    try {
      final http.Response response = await client.get(Uri.parse(url));
      // you can declare hasInterent here to true,
      // bcuz it will be true if it passes the first sentence
      // otherwise it would have raised an exception
      NetworkController.hasInternet.value = true;
      switch (response.statusCode) {
        case 200:
          return Success(returnValue: response.body);
        case 401:
          Get.log("Authentication Error");
          return const Failure(error: "Try Again Later.");

        default:
          Get.log("$url ${response.statusCode} ${response.body}");
          return const Failure();
      }
    } on SocketException catch (_) {
      Get.log("socket exception");
      NetworkController.instance.checkConnection();
      return const Failure(error: "Network Error!", becauseSocket: true);
    } on Exception {
      Get.log("another exception");
      return const Failure();
    }
  }

  static Future<Result<String, Exception>> post(
      {required String url, required Map body}) async {
    try {
      final http.Response response = await client.post(
        Uri.parse(url),
        body: body,
      );
      // you can declare hasInterent here to true,
      // bcuz it will be true if it passes the first sentence
      // otherwise it would have raised an exception
      NetworkController.hasInternet.value = true;
      switch (response.statusCode) {
        case 200:
          return Success(returnValue: response.body);
        case 401:
          Get.log("Authentication Error");
          //**to-do email admin all credentials have failed
          return const Failure(error: "Error");

        default:
          Get.log("$url ${response.body}");
          return const Failure();
      }
    } on SocketException catch (_) {
      Get.log("socket exception");
      NetworkController.instance.checkConnection();
      return const Failure(error: "Network Error!", becauseSocket: true);
    } on Exception {
      Get.log("another exception");
      return const Failure();
    }
  }

  static Future<Result<String, Exception>> put(
      {required String url, required Map body}) async {
    try {
      final http.Response response = await myApiClient.put(
        Uri.parse(url),
        body: body,
      );
      // you can declare hasInterent here to true,
      // bcuz it will be true if it passes the first sentence
      // otherwise it would have raised an exception
      NetworkController.hasInternet.value = true;
      switch (response.statusCode) {
        case 200:
          return Success(returnValue: response.body);
        case 401:
          Get.log("Authentication Error");

          //**to-do email admin all credentials have failed
          return const Failure(error: "Error");

        default:
          Get.log("$url ${response.body}");
          return const Failure();
      }
    } on SocketException catch (_) {
      Get.log("socket exception");
      NetworkController.instance.checkConnection();
      return const Failure(error: "Network Error!");
    } on Exception {
      Get.log("another exception");
      return const Failure();
    }
  }
}
