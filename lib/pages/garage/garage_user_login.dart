import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';


import '../../database/dbhelper.dart';
import '../../model/user_model.dart';
import '../../services/Auth_service.dart';
import '../../utils/helper_function.dart';
import '../redirect_page.dart';

class GarageOwnerLoginPage extends StatelessWidget {
  const GarageOwnerLoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'Garage Owner',
      titleTag: "Login",
      logo: const AssetImage('asset/image/logo.png'),
      onLogin: _authUser,
      onSignup: _signupConfirm,
      loginAfterSignUp: true,
      onSubmitAnimationCompleted: () {
        Get.to(const RedirectPage());
      },
      onRecoverPassword: (p0) {
        AuthService.auth.sendPasswordResetEmail(email: p0).then((value) {
          return;
        }).catchError((onError) {
          return "Some Thing error";
        });
      },
      additionalSignupFields: [
        const UserFormField(
          keyName: 'Username',
          icon: Icon(FontAwesomeIcons.userLarge),
        ),
        const UserFormField(
            keyName: 'Location', icon: Icon(FontAwesomeIcons.mapLocation)),
        const UserFormField(
            keyName: 'NID_Number', icon: Icon(FontAwesomeIcons.addressCard)),
        UserFormField(
          icon: Icon(Icons.call),
          keyName: 'phone_number',
          displayName: 'Phone Number',
          userType: LoginUserType.phone,
          fieldValidator: (value) {
            final phoneRegExp = RegExp(
              '^(\\+\\d{1,2}\\s)?\\(?\\d{3}\\)?[\\s.-]?\\d{3}[\\s.-]?\\d{4}\$',
            );
            if (value != null &&
                value.length < 7 &&
                !phoneRegExp.hasMatch(value)) {
              return "This isn't a valid phone number";
            }
            return null;
          },
        ),
      ],
      termsOfService: [
        TermOfService(
            id: "01",
            mandatory: true,
            text: "Are you accepts term & conditions")
      ],
    );
  }

  Future<String?> _authUser(LoginData data) {
    return Future.delayed(const Duration(milliseconds: 0)).then((_) async {
      try {
        UserCredential userCredential = await AuthService.auth
            .signInWithEmailAndPassword(
                email: data.name, password: data.password);
        if (await DbHelper.doesUserExist(userCredential.user!.uid)) {
          setGarageOwnerStatus(true);
          return null;
        }
        AuthService.logout();
        return 'You Are Not A User';
      } on FirebaseException catch (error) {
        log(error.toString());
        return error.message!;
      }
    });
  }

  Future<String?> _signupConfirm(SignupData signupData) {
    return Future.delayed(Duration.zero).then((_) async {
      try {
        UserCredential userCredential = await AuthService.auth
            .createUserWithEmailAndPassword(
                email: signupData.name!, password: signupData.password!);
        final userModel = UserModel(
          accountActive: false,
          email: signupData.name!,
          nId: signupData.additionalSignupData!["NID_Number"]!,
          uid: userCredential.user!.uid,
          phoneNumber: signupData.additionalSignupData!["phone_number"]!,
          createTime: Timestamp.now(),
          isGarageOwner: true,
          name: signupData.additionalSignupData!["Username"]!,
          location: signupData.additionalSignupData!["Location"]!,
        );
        DbHelper.addUser(userModel).then((value) {
          setGarageOwnerStatus(true);
          return;
        });
      } on FirebaseException catch (error) {
        log(error.toString());
        return error.message!;
      }
    });
  }
}
