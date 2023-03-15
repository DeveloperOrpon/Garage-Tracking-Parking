import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../provider/mapProvider.dart';
import '../services/Auth_service.dart';
import '../utils/helper_function.dart';
import 'admin/dashboard/dashboard_screen.dart';
import 'garage/garage_user_dashboard.dart';
import 'home_page.dart';
import 'language_select_page.dart';

class RedirectPage extends StatelessWidget {
  const RedirectPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(
      const Duration(seconds: 2),
      () async {
        log("is garage ${await getGarageOwnerStatus()} admin ${await getAdminStatus()} current user ${AuthService.currentUser}");
        if (AuthService.currentUser != null) {
          Provider.of<MapProvider>(context, listen: false).getUserInfo();
          await getAdminStatus()
              ? Get.offAll(() => const DashboardScreen())
              : await getGarageOwnerStatus()
                  ? Get.offAll(() => const GarageUserDashBoardPage())
                  : Get.offAll(() => const HomePage());
        } else {
          Get.offAll(() => const LanguageSelectPage());
        }
      },
    );
    return Scaffold(
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'asset/image/car_map.png',
            height: Get.height / 3,
            width: Get.width,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              textAlign: TextAlign.center,
              'welcome'.tr,
              style: const TextStyle(
                  fontSize: 24,
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "welcome_info".tr,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
          Lottie.asset(
            'asset/image/globe.json',
            width: 140,
            height: 140,
          ),
        ],
      )),
    );
  }
}
