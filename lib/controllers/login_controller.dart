import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../database/dbhelper.dart';
import '../model/user_model.dart';
import '../pages/redirect_page.dart';
import '../services/Auth_service.dart';

class LoginController extends GetxController {
  var formkey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  final codeController = TextEditingController();
  late String vid;

  sendVerificationCode() async {
    String phone = "+88${phoneController.text}";
    EasyLoading.show();
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) async {},
      verificationFailed: (FirebaseAuthException e) {
        print('Verification Failed');
      },
      codeSent: (String verificationId, int? resendToken) {
        vid = verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
    EasyLoading.dismiss();
  }

  Future<void> verify() async {
    EasyLoading.show(status: 'Verifying, please wait');
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: vid, smsCode: codeController.text);
    if (credential.smsCode == codeController.text) {
      await AuthService.auth.signInWithCredential(credential).then((value) {
        addUser().then((value) {
          print("verify function");
          phoneController.text = '';
          codeController.text = '';
          Get.to(() => const RedirectPage());
        });
      }).catchError((onError) {
        EasyLoading.dismiss();
        log("Code Wrong");
        Get.snackbar(
          "Information",
          'Wrong OTP Code',
          duration: const Duration(seconds: 2),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
        );
      });
      EasyLoading.dismiss();
    }
  }

  Future<void> addUser() async {
    if (!await DbHelper.doesUserExist(AuthService.currentUser!.uid)) {
      final userModel = UserModel(
        accountActive: true,
        isGarageOwner: false,
        uid: AuthService.currentUser!.uid,
        phoneNumber: phoneController.text,
        createTime: Timestamp.fromDate(DateTime.now()),
      );
      return await DbHelper.addUser(userModel);
    }
  }
}
