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

import '../database/dbhelper.dart';
import '../model/garage_model.dart';
import '../provider/mapProvider.dart';
import '../services/Auth_service.dart';
import 'admin/dashboard/admin_info_add_in_userAccount.dart';
import 'admin/models/city_model.dart';
import 'admin/models/division_model.dart';

class AddGaragePage extends StatefulWidget {
  const AddGaragePage({Key? key}) : super(key: key);

  @override
  State<AddGaragePage> createState() => _AddGaragePageState();
}

class _AddGaragePageState extends State<AddGaragePage> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final totalSpaceController = TextEditingController();
  final adInfoController = TextEditingController();
  final categoryController = TextEditingController();
  DivisionModel? divisionModel;
  CityModel? cityModel;
  String? selectImage;
  bool isSubmitBtnActive = true;

  final categoryList = [];

  void _addItems() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Category Name"),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        backgroundColor: Colors.orange,
        content: Container(
          height: 120,
          width: Get.width * .4,
          decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  controller: categoryController,
                  decoration: InputDecoration(
                    fillColor: Colors.grey.shade200,
                    filled: true,
                    border: InputBorder.none,
                    hintText: "Enter Category Name",
                    helperStyle:
                        const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please Fill Garage Name";
                    }
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (categoryController.text.length >= 4) {
                    categoryList.insert(0, categoryController.text);
                  }
                  categoryController.text = '';
                  Get.back();
                  setState(() {});
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                child: const Text(
                  "Add",
                  style: TextStyle(color: Colors.orange),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Future<void> didChangeDependencies() async {
    if (!await DbHelper.doesUserExist(AuthService.currentUser!.uid)) {
      QuickAlert.show(
        confirmBtnText: "Create An Account",
        context: context,
        onConfirmBtnTap: () {
          Get.back();
          Get.to(const AdminUserAccountCreate(),
              transition: Transition.rightToLeftWithFade);
        },
        type: QuickAlertType.warning,
        text: 'You Has Not Any User Account!',
        barrierDismissible: false,
      );
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        log('Backbutton pressed (device or appbar button), do whatever you want.');

        return Future.value(true);
      },
      child: Consumer<MapProvider>(
        builder: (context, mapProvider, child) => Scaffold(
          backgroundColor: CupertinoColors.white,
          appBar: AppBar(
            title: const Text("Add Garage For Ads "),
          ),
          body: Form(
            key: formKey,
            child: ListView(
              padding: const EdgeInsets.all(14),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller: nameController,
                    decoration: InputDecoration(
                      fillColor: Colors.grey.shade200,
                      filled: true,
                      border: InputBorder.none,
                      hintText: "Enter Garage Name",
                      helperStyle:
                          const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Fill Garage Name";
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller: addressController,
                    decoration: InputDecoration(
                      fillColor: Colors.grey.shade200,
                      filled: true,
                      border: InputBorder.none,
                      hintText: "Enter Garage Address",
                      helperStyle:
                          const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Fill Garage address";
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: totalSpaceController,
                    decoration: InputDecoration(
                      fillColor: Colors.grey.shade200,
                      filled: true,
                      border: InputBorder.none,
                      hintText: "Total Space",
                      helperStyle:
                          const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "enter space";
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller: adInfoController,
                    decoration: InputDecoration(
                      fillColor: Colors.grey.shade200,
                      filled: true,
                      border: InputBorder.none,
                      hintText: "Additional Information",
                      helperStyle:
                          const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "enter additionalInformation";
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 110,
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        ElevatedButton.icon(
                          onPressed: _addItems,
                          icon: const Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          label: const Text(
                            "Add Category",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        categoryList.isNotEmpty
                            ? Expanded(
                                child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: categoryList
                                    .map(
                                      (e) => Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          ChoiceChip(
                                            label: Padding(
                                              padding:
                                                  const EdgeInsets.all(6.0),
                                              child: Text(e),
                                            ),
                                            selected: true,
                                          ),
                                          Positioned(
                                            right: -10,
                                            top: -10,
                                            child: IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    categoryList.remove(e);
                                                  });
                                                },
                                                icon: Icon(
                                                  CupertinoIcons.delete,
                                                  color: Colors.red,
                                                  size: 22,
                                                )),
                                          )
                                        ],
                                      ),
                                    )
                                    .toList(),
                              ))
                            : const Padding(
                                padding: EdgeInsets.all(10),
                                child: Center(
                                  child: Text("No Category Select"),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40.0, vertical: 7),
                  child: DropdownButtonFormField<DivisionModel>(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.orange,
                    ),
                    hint: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Select Division',
                        style: TextStyle(
                            color: Colors.white.withOpacity(.8),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    value: divisionModel,
                    isExpanded: true,
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a Division';
                      }
                      return null;
                    },
                    items: mapProvider.divisionList
                        .map((divisionModel) => DropdownMenuItem(
                            value: divisionModel,
                            child: Text(divisionModel.bnName!)))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        divisionModel = value;
                        cityModel = null;
                        mapProvider.checkCityAvalable(divisionModel!.id!);
                      });
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40.0, vertical: 7),
                  child: DropdownButtonFormField<CityModel>(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.orange,
                    ),
                    hint: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Select City',
                        style: TextStyle(
                            color: Colors.white.withOpacity(.8),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    value: cityModel,
                    isExpanded: true,
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a City';
                      }
                      return null;
                    },
                    items: mapProvider.selectCityListByDivision
                        .map((cityModel) => DropdownMenuItem(
                            value: cityModel, child: Text(cityModel.bnName!)))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        cityModel = value;
                      });
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
                                    final pickedImage = await picker.pickImage(
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
                                      final ImagePicker picker = ImagePicker();
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
                          ? Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
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
                                ),
                                Positioned(
                                  right: -20,
                                  top: -20,
                                  child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          selectImage = null;
                                        });
                                      },
                                      icon: const Icon(
                                        CupertinoIcons.delete_solid,
                                        color: Colors.red,
                                        size: 32,
                                      )),
                                )
                              ],
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
                const SizedBox(height: 60),
              ],
            ),
          ),
          floatingActionButton: Container(
            margin: const EdgeInsets.only(left: 30.0),
            child: CupertinoButton.filled(
              onPressed: isSubmitBtnActive ? _saveGarage : null,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    CupertinoIcons.add,
                    color: Colors.white,
                  ),
                  Text(
                    "Add Garage",
                    style: TextStyle(color: CupertinoColors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _saveGarage() async {
    if (formKey.currentState!.validate() &&
        categoryList.isNotEmpty &&
        selectImage != null) {
      setState(() {
        isSubmitBtnActive = false;
      });
      EasyLoading.show(status: "Wait..........");
      try {
        String downloadUrl = await DbHelper.uploadImage(selectImage!);
        final garageModel = GarageModel(
          gId: DateTime.now().millisecondsSinceEpoch.toString(),
          name: nameController.text,
          coverImage: downloadUrl,
          ownerUId: AuthService.currentUser!.uid,
          address: addressController.text,
          division: divisionModel!.name!,
          city: cityModel!.name!,
          totalSpace: totalSpaceController.text,
          additionalInformation: adInfoController.text,
          createTime: Timestamp.fromDate(DateTime.now()),
          parkingCategoryList: categoryList,
        );
        clear();
        await DbHelper.addGarageInfo(garageModel).then((value) {
          EasyLoading.dismiss();
          Get.snackbar("Information", "Your Garage Added Successfully",
              duration: const Duration(seconds: 5),
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.orange,
              showProgressIndicator: true);
          setState(() {
            isSubmitBtnActive = true;
          });
        }).catchError((onError) {
          EasyLoading.dismiss();
          Get.snackbar("Information", onError.toString(),
              duration: const Duration(seconds: 5),
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.red,
              showProgressIndicator: true);
          setState(() {
            isSubmitBtnActive = true;
          });
        });
      } catch (error) {
        EasyLoading.dismiss();
        log(error.toString());
        Get.snackbar("Information", error.toString(),
            duration: const Duration(seconds: 5),
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            showProgressIndicator: true);
        setState(() {
          isSubmitBtnActive = true;
        });
      }
    }
  }

  clear() {
    nameController.text = '';
    addressController.text = '';
    totalSpaceController.text = '';
    adInfoController.text = '';
    divisionModel = null;
    cityModel = null;
    selectImage = null;
  }

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    totalSpaceController.dispose();
    adInfoController.dispose();
    categoryController.dispose();
    super.dispose();
  }
}
