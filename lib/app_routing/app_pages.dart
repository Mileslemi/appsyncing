import 'package:appsyncing/app_routing/app_routes.dart';
import 'package:appsyncing/views/home/dashboard.dart';
import 'package:get/get.dart';

import '../views/login/login.dart';

class AppPages {
  AppPages._();

  static const initial = AppRoutes.login;

  static final routes = [
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const DashBoard(),
    )
  ];
}
