import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../utils/user_preference.dart';

enum SdkType { TESTBOX, LIVE }

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late final Animation<Offset> offsetAnimation;

  var notificationStatusValue = true.obs;

  @override
  void onInit() {
    animationInit();
  }

  animationInit() async {
    late AnimationController controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..forward();
    offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.elasticInOut,
    ));
  }

  notificationGetStatus() async {
    notificationStatusValue.value = await getNotificationStatus();
  }

  void saveNotiValue() async {
    EasyLoading.show(status: "wait");
    await setNotificationStatus(!notificationStatusValue.value);
    notificationGetStatus();
    EasyLoading.dismiss();
  }
}
