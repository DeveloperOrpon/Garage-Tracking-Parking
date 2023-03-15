import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../../../database/dbhelper.dart';
import '../../../model/user_model.dart';
import '../../../provider/adminProvider.dart';
import '../../../services/Auth_service.dart';
import '../../add_garage_page.dart';

class AdminUserAccountCreate extends StatefulWidget {
  const AdminUserAccountCreate({Key? key}) : super(key: key);

  @override
  State<AdminUserAccountCreate> createState() => _AdminUserAccountCreateState();
}

class _AdminUserAccountCreateState extends State<AdminUserAccountCreate> {
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var locationController = TextEditingController();
  String? selectImage;
  bool isUpdate = false;
  late AdminProvider adminProvider;

  @override
  Future<void> didChangeDependencies() async {
    isUpdate = await DbHelper.doesUserExist(AuthService.currentUser!.uid);
    adminProvider = Provider.of<AdminProvider>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isUpdate ? "Update User info" : "User Account Create"),
      ),
      body: ListView(
        children: [
          Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: nameController,
                      decoration: InputDecoration(
                          fillColor: Colors.grey.shade300,
                          filled: true,
                          border: InputBorder.none,
                          hintText: "Enter Name here",
                          helperStyle: const TextStyle(
                              color: Colors.grey, fontSize: 14)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please Fill";
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: phoneController,
                      decoration: InputDecoration(
                          fillColor: Colors.grey.shade300,
                          filled: true,
                          border: InputBorder.none,
                          hintText: "Enter phone Number here",
                          helperStyle: const TextStyle(
                              color: Colors.grey, fontSize: 14)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please Fill";
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: locationController,
                      decoration: InputDecoration(
                          fillColor: Colors.grey.shade300,
                          filled: true,
                          border: InputBorder.none,
                          hintText: "Enter Address here",
                          helperStyle: const TextStyle(
                              color: Colors.grey, fontSize: 14)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please Fill";
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            showCupertinoDialog(
                              context: context,
                              builder: (context) => CupertinoAlertDialog(
                                title: const Text("Select Image Source"),
                                actions: [
                                  CupertinoDialogAction(
                                    child: const Text("Camera"),
                                    onPressed: () async {
                                      final ImagePicker picker = ImagePicker();
                                      final pickedImage =
                                          await picker.pickImage(
                                              source: ImageSource.camera);
                                      if (pickedImage != null) {
                                        setState(() {
                                          selectImage = (pickedImage.path);
                                        });
                                      }
                                      Get.back();
                                    },
                                  ),
                                  CupertinoDialogAction(
                                      child: const Text("Gallery"),
                                      onPressed: () async {
                                        final ImagePicker picker =
                                            ImagePicker();
                                        final pickedImage =
                                            await picker.pickImage(
                                                source: ImageSource.gallery);
                                        if (pickedImage != null) {
                                          setState(() {
                                            selectImage = (pickedImage.path);
                                          });
                                        }
                                        Get.back();
                                      }),
                                ],
                              ),
                            );
                          },
                          child: Container(
                            height: 90,
                            width: 90,
                            decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                border: Border.all(
                                  color: Colors.orange,
                                  width: 1,
                                )),
                            child: const Icon(Icons.add),
                          ),
                        ),
                        selectImage != null
                            ? Container(
                                margin: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                  color: Colors.orange,
                                  width: 1,
                                )),
                                child: Image.file(
                                  File(selectImage!),
                                  width: 90,
                                  height: 90,
                                ),
                              )
                            : const Expanded(
                                child: Center(
                                  child: Text(
                                    "Please Select A Image",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              )
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  CupertinoButton(
                    color: Colors.blue,
                    child: Text(
                      "Create Account",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      _createUser();
                    },
                  )
                ],
              ))
        ],
      ),
    );
  }

  void _createUser() async {
    if (formKey.currentState!.validate()) {
      EasyLoading.show(status: "Wait..........");
      try {
        String downloadUrl = await DbHelper.uploadImage(selectImage!);
        final userModel = UserModel(
          accountActive: true,
          uid: AuthService.currentUser!.uid,
          phoneNumber: phoneController.text,
          profileUrl: downloadUrl,
          email: AuthService.currentUser!.email!,
          location: locationController.text,
          name: nameController.text,
          isGarageOwner: true,
          createTime: Timestamp.fromDate(DateTime.now()),
        );
        clear();

        await DbHelper.createAdminUser(userModel).then((value) {
          EasyLoading.dismiss();
          QuickAlert.show(
            context: context,
            type: QuickAlertType.confirm,
            text: 'Do you want Create Garage',
            confirmBtnText: 'Yes',
            cancelBtnText: 'No',
            onCancelBtnTap: () {
              Get.back();
              Get.back();
            },
            onConfirmBtnTap: () {
              Get.back();
              Get.back();
              Get.to(const AddGaragePage(),
                  transition: Transition.rightToLeftWithFade);
            },
            barrierDismissible: false,
            confirmBtnColor: Colors.green,
          );
        });
      } catch (error) {
        EasyLoading.dismiss();
        log(error.toString());
        Get.snackbar("Information", error.toString(),
            duration: const Duration(seconds: 5),
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            showProgressIndicator: true);
      }
    }
  }

  void clear() {
    nameController.text = '';
    phoneController.text = '';
    locationController.text = '';
    selectImage = null;
  }
}
