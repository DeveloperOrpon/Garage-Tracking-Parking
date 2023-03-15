import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parking_koi/model/user_model.dart';
import 'package:provider/provider.dart';

import '../../database/dbhelper.dart';
import '../../provider/mapProvider.dart';

class UpdateGarageOwnerProfile extends StatefulWidget {
  final UserModel userModel;
  const UpdateGarageOwnerProfile({Key? key, required this.userModel})
      : super(key: key);

  @override
  State<UpdateGarageOwnerProfile> createState() =>
      _UpdateGarageOwnerProfileState();
}

class _UpdateGarageOwnerProfileState extends State<UpdateGarageOwnerProfile> {
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var locationController = TextEditingController();
  String? selectImage;
  String? downloadUrl;
  bool isButtonActive = true;
  @override
  void didChangeDependencies() {
    final mapProvider = Provider.of<MapProvider>(context, listen: false);
    nameController.text = mapProvider.userModel!.name!;
    phoneController.text = mapProvider.userModel!.phoneNumber;
    locationController.text = mapProvider.userModel!.location!;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MapProvider>(
      builder: (context, mapProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Update Owner info"),
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
                        child: mapProvider.userModel!.profileUrl == null
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      showCupertinoDialog(
                                        context: context,
                                        builder: (context) =>
                                            CupertinoAlertDialog(
                                          title:
                                              const Text("Select Image Source"),
                                          actions: [
                                            CupertinoDialogAction(
                                              child: const Text("Camera"),
                                              onPressed: () async {
                                                final ImagePicker picker =
                                                    ImagePicker();
                                                final pickedImage =
                                                    await picker.pickImage(
                                                        source:
                                                            ImageSource.camera);
                                                if (pickedImage != null) {
                                                  setState(() {
                                                    selectImage =
                                                        (pickedImage.path);
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
                                                          source: ImageSource
                                                              .gallery);
                                                  if (pickedImage != null) {
                                                    setState(() {
                                                      selectImage =
                                                          (pickedImage.path);
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
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ),
                                        )
                                ],
                              )
                            : Stack(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                      color: Colors.orange,
                                      width: 1,
                                    )),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          mapProvider.userModel!.profileUrl!,
                                      placeholder: (context, url) =>
                                          const CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                      width: 90,
                                      height: 90,
                                    ),
                                  ),
                                  Positioned(
                                    right: -15,
                                    top: -10,
                                    child: IconButton(
                                        onPressed: () {
                                          _deleteProfileImage(mapProvider);
                                        },
                                        icon: const Icon(
                                          CupertinoIcons.delete_solid,
                                          color: Colors.red,
                                          size: 32,
                                        )),
                                  )
                                ],
                              ),
                      ),
                      const SizedBox(height: 30),
                      CupertinoButton(
                        color: Colors.blue,
                        onPressed: isButtonActive
                            ? () {
                                _updateProfile(mapProvider);
                              }
                            : null,
                        child: const Text(
                          "Update Profile",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ))
            ],
          ),
        );
      },
    );
  }

  void _deleteProfileImage(MapProvider mapProvider) {
    mapProvider.updateProfile(userFieldUProfileUrl, null);
  }

  Future<void> _updateProfile(MapProvider mapProvider) async {
    setState(() {
      isButtonActive = false;
    });
    if (formKey.currentState!.validate()) {
      EasyLoading.show(status: "Wait..........");
      try {
        if (selectImage != null) {
          downloadUrl = await DbHelper.uploadImage(selectImage!);
          selectImage = null;
          mapProvider.updateProfile(userFieldUProfileUrl, downloadUrl);
        }
        mapProvider.updateProfile(userFieldName, nameController.text);
        mapProvider.updateProfile(userFieldPhone, phoneController.text);
        mapProvider.updateProfile(userFieldLocation, locationController.text);
        setState(() {
          isButtonActive = true;
        });
        Get.snackbar("Information", 'Update Successful',
            duration: const Duration(seconds: 5),
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            showProgressIndicator: true);
      } catch (error) {
        EasyLoading.dismiss();
        setState(() {
          isButtonActive = true;
        });
        Get.snackbar("Information", error.toString(),
            duration: const Duration(seconds: 5),
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            showProgressIndicator: true);
      }
    }
  }
}
