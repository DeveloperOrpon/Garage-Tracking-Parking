import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:parking_koi/pages/user_identification_page.dart';

class LanguageSelectPage extends StatelessWidget {
  const LanguageSelectPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List locale = [
      {'name': 'ENGLISH', 'locale': const Locale('en', 'US')},
      {'name': 'বাংলা', 'locale': const Locale('BD', 'IN')},
    ];
    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Lottie.asset(
              'asset/image/language.json',
              width: Get.width,
              height: Get.height / 2,
            ),
            Expanded(
                child: Column(
              children: [
                const Text(
                  "Select Language",
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                ),
                const SizedBox(height: 6),
                Container(
                  height: 2,
                  width: Get.width / 1.5,
                  color: Colors.amberAccent,
                ),
                const SizedBox(height: 25),
                InkWell(
                  onTap: () {
                    Get.updateLocale(locale[0]['locale']);
                    Get.to(() => const UserIdentificationPage(),
                        curve: Curves.elasticInOut,
                        duration: const Duration(milliseconds: 300));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    height: 60,
                    width: Get.width / 2,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          spreadRadius: 5,
                          offset: const Offset(3, 3),
                          blurRadius: 5,
                        )
                      ],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Text(
                      "English",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                InkWell(
                  onTap: () {
                    Get.updateLocale(locale[1]['locale']);
                    Get.to(() => const UserIdentificationPage(),
                        curve: Curves.elasticInOut,
                        duration: const Duration(milliseconds: 300));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    height: 60,
                    width: Get.width / 2,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          spreadRadius: 5,
                          offset: Offset(3, 3),
                          blurRadius: 5,
                        )
                      ],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Text(
                      "বাংলা",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                )
              ],
            ))
          ],
        ),
      ),
    );
  }
}
