import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:get/get.dart';

import '../../../database/dbhelper.dart';
import '../../../services/Auth_service.dart';
import '../../../utils/helper_function.dart';
import '../../redirect_page.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({Key? key}) : super(key: key);

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  @override
  Widget build(BuildContext context) {
    Future<String?> _authUser(LoginData data) {
      return Future.delayed(const Duration(milliseconds: 0)).then((_) async {
        try {
          UserCredential userCredential = await AuthService.auth
              .signInWithEmailAndPassword(
                  email: data.name, password: data.password);
          if (await DbHelper.doesAdminExist(userCredential.user!.uid)) {
            setAdminStatus(true);
            return null;
          }
          AuthService.logout();
          return 'You Are Not Admin';
        } on FirebaseException catch (error) {
          log(error.toString());
          return error.message!;
        }
      });
    }

    return FlutterLogin(
      title: 'Admin Login',
      logo: const AssetImage('asset/image/logo.png'),
      onLogin: _authUser,
      onSubmitAnimationCompleted: () {
        Get.to(const RedirectPage());
      },
      onRecoverPassword: (p0) {},
    );
  }
}
