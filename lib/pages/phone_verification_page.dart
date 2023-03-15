import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:parking_koi/pages/redirect_page.dart';
import 'package:parking_koi/pages/verify_code_page.dart';
import 'package:provider/provider.dart';

import '../controllers/login_controller.dart';
import '../database/dbhelper.dart';
import '../model/user_model.dart';
import '../provider/mapProvider.dart';
import '../services/Auth_service.dart';

class PhoneVerificationPage extends StatelessWidget {
  const PhoneVerificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
    //     overlays: SystemUiOverlay.values);
    final controller = Get.find<LoginController>();
    return Consumer<MapProvider>(
      builder: (context, mapProvider, child) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ListView(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 15),
                    const Text(
                      "Sign up to find your nearest parking space",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Add your phone number. We'll send you a verification code so we know are real.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.black45),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: TextFormField(
                        enableSuggestions: true,
                        maxLength: 11,
                        validator: (value) {
                          if (value == null || value.length < 11) {
                            return "Please Provide a Valid Number";
                          }
                        },
                        controller: controller.phoneController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "01XXXXXXXXX",
                          hintStyle: const TextStyle(
                              color: Colors.grey,
                              fontSize: 18,
                              letterSpacing: 3),
                          filled: true,
                          fillColor: Colors.grey.shade200,
                          border: InputBorder.none,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                "asset/image/bd_flag.png",
                                width: 15,
                                height: 20,
                              ),
                            ),
                          ),
                          prefixText: "+88",
                          prefixStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              letterSpacing: 3),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(() => const VerifyCodePage());
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
                          "SENT OTP",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "By providing my phone number. I have agreed and accepted the 'Terms and Service' and 'Privacy Policy' to use  Garage Tracking And Parking",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.black45),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          left: 60, right: 60, top: 30, bottom: 10),
                      child: const Divider(
                        color: Colors.orange,
                        thickness: 3,
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {
                        _logInWithGoogle(mapProvider);
                      },
                      label: const Text(
                        "LogIn With Google",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      icon: const Icon(FontAwesomeIcons.google),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _logInWithGoogle(MapProvider mapProvider) async {
    await AuthService.signInWithGoogle().then((credential) async {
      EasyLoading.show(status: "Wait");
      final userExists = await DbHelper.doesUserExist(credential.user!.uid);
      if (!userExists) {
        log("Creating User Account");
        addUser(credential).then((value) {
          EasyLoading.dismiss();
          Get.to(() => const RedirectPage());
        });
      } else {
        EasyLoading.dismiss();
        Get.to(() => const RedirectPage());
      }
    }).catchError((onError) {
      EasyLoading.dismiss();
      Get.snackbar("Error Occurs", onError.toString(),
          backgroundColor: Colors.red);
      log("error :${onError.toString()}");
    });
  }

  Future<void> addUser(UserCredential credential) async {
    final userModel = UserModel(
      accountActive: true,
      isGarageOwner: false,
      uid: AuthService.currentUser!.uid,
      phoneNumber: credential.user!.phoneNumber ?? "0088",
      email: credential.user!.email,
      name: credential.user!.displayName,
      profileUrl: credential.user!.photoURL,
      createTime: Timestamp.fromDate(DateTime.now()),
    );
    log(userModel.toString());
    return await DbHelper.addUser(userModel);
  }
}
