import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:parking_koi/pages/phone_verification_page.dart';

import 'admin/dashboard/login_page.dart';
import 'garage/garage_user_login.dart';

class UserIdentificationPage extends StatelessWidget {
  const UserIdentificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset(
            'asset/image/parking_concept.json',
            width: Get.width,
            height: Get.height / 2,
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
            padding: const EdgeInsets.all(12.0),
            child: Text(
              "welcome_info".tr,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CupertinoButton.filled(
                  onPressed: () {
                    Get.to(() => const PhoneVerificationPage(),
                        curve: Curves.elasticInOut,
                        duration: const Duration(milliseconds: 300));
                  },
                  child: const Text(
                    "Continue as User",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                const Divider(
                  color: Colors.orange,
                  height: 3,
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () => Get.to(const GarageOwnerLoginPage()),
                      label: const Text(
                        "Garage Owner",
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 14,
                        ),
                      ),
                      icon: const Icon(FontAwesomeIcons.squareParking),
                    ),
                    const SizedBox(width: 10),
                    OutlinedButton.icon(
                      onPressed: () => Get.to(const AdminLogin()),
                      label: const Text(
                        "Admin",
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 14,
                        ),
                      ),
                      icon: const Icon(FontAwesomeIcons.screwdriverWrench),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
