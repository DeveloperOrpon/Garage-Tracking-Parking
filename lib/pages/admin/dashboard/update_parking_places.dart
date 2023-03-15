import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../database/dbhelper.dart';
import '../../../model/garage_model.dart';
import '../../../model/parking_model.dart';
import '../../../utils/const.dart';

class UpdateParkingPlace extends StatefulWidget {
  const UpdateParkingPlace({Key? key}) : super(key: key);

  @override
  State<UpdateParkingPlace> createState() => _UpdateParkingPlaceState();
}

class _UpdateParkingPlaceState extends State<UpdateParkingPlace> {
  var formKey = GlobalKey<FormState>();
  bool buttonDisable = false;
  String? parkingCategory;
  var nameController = TextEditingController();
  var addressController = TextEditingController();
  var capacityController = TextEditingController();
  var costController = TextEditingController();
  List<String> selectImages = [];
  List<String> selectFacility = [];
  List<String> listOfFacility = [
    "CC TV",
    "Guard",
    "Indoor",
    "Car Wash",
    "24/7 Service"
  ];
  final parkingModel = Get.arguments as ParkingModel;

  @override
  void initState() {
    nameController.text = parkingModel.title;
    addressController.text = parkingModel.address;
    capacityController.text = parkingModel.capacity;
    costController.text = parkingModel.parkingCost;
    selectFacility = List.generate(parkingModel.facilityList.length,
        (index) => parkingModel.facilityList[index]);
    log(parkingModel.facilityList.toString());
    parkingCategory = parkingModel.parkingCategoryName;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Additional Information"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                        fillColor: Colors.grey.shade300,
                        filled: true,
                        border: InputBorder.none,
                        hintText: "Enter Place Name",
                        helperStyle:
                            TextStyle(color: Colors.grey, fontSize: 14)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Fill Name";
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: addressController,
                    decoration: InputDecoration(
                        fillColor: Colors.grey.shade300,
                        filled: true,
                        border: InputBorder.none,
                        hintText: "Enter Full Address",
                        helperStyle:
                            TextStyle(color: Colors.grey, fontSize: 14)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Fill Address";
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: capacityController,
                    decoration: InputDecoration(
                        fillColor: Colors.grey.shade300,
                        filled: true,
                        border: InputBorder.none,
                        hintText: "Enter Parking Capacity",
                        helperStyle:
                            TextStyle(color: Colors.grey, fontSize: 14)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Fill Capacity";
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: costController,
                    decoration: InputDecoration(
                        fillColor: Colors.grey.shade300,
                        filled: true,
                        border: InputBorder.none,
                        hintText: "Enter Rent Cost $takaSymbol per hour",
                        helperStyle:
                            TextStyle(color: Colors.grey, fontSize: 14)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Fill Cost";
                      }
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    "Select Facility",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: ChipsChoice<String>.multiple(
                    value: selectFacility,
                    onChanged: (val) => setState(() => selectFacility = val),
                    choiceItems: C2Choice.listFrom<String, String>(
                      source: listOfFacility,
                      value: (i, v) => v,
                      label: (i, v) => v,
                    ),
                  ),
                ),
                SizedBox(
                  height: 100,
                  child: Row(
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
                                    final ImagePicker _picker = ImagePicker();
                                    final pickedImage = await _picker.pickImage(
                                        source: ImageSource.camera);
                                    if (pickedImage != null) {
                                      setState(() {
                                        selectImages.add(pickedImage.path);
                                      });
                                    }
                                    Get.back();
                                  },
                                ),
                                CupertinoDialogAction(
                                    child: const Text("Gallery"),
                                    onPressed: () async {
                                      final ImagePicker _picker = ImagePicker();
                                      final pickedImage =
                                          await _picker.pickImage(
                                              source: ImageSource.gallery);
                                      if (pickedImage != null) {
                                        setState(() {
                                          selectImages.add(pickedImage.path);
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
                      Expanded(
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: selectImages.map((e) {
                            return Container(
                              margin: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                color: Colors.orange,
                                width: 1,
                              )),
                              child: Image.file(
                                File(e),
                                width: 90,
                                height: 90,
                              ),
                            );
                          }).toList(),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: parkingModel.parkImageList.length,
                    itemBuilder: (context, index) => Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                              border: Border.all(
                            color: Colors.orange,
                            width: 1,
                          )),
                          child: CachedNetworkImage(
                            imageUrl: parkingModel.parkImageList[index],
                            width: 90,
                            height: 90,
                          ),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          top: 0,
                          child: IconButton(
                              onPressed: () {
                                _deleteImage(index);
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 35,
                              )),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                FutureBuilder(
                  future: DbHelper.getGarageInfoById(parkingModel.gId),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final garageModel =
                          GarageModel.fromMap(snapshot.data!.data()!);
                      return DropdownButtonFormField<String>(
                        key: UniqueKey(),
                        decoration: const InputDecoration(
                            labelText: 'Parking Category Selection',
                            border: OutlineInputBorder()),
                        value: parkingCategory,
                        items: garageModel.parkingCategoryList.map((category) {
                          return DropdownMenuItem<String>(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        onChanged: (category) {
                          setState(() {
                            parkingCategory = category;
                          });
                        },
                      );
                    }
                    return const Text("Loading..");
                  },
                ),
                const SizedBox(height: 40),
                CupertinoButton.filled(
                  onPressed: () {
                    buttonDisable = true;
                    _updateParkingInfo();
                    buttonDisable = false;
                  },
                  child: const Text(
                    "Add Post For Review",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _deleteImage(int index) async {
    EasyLoading.show(status: "Deleting.......");
    parkingModel.parkImageList.removeAt(index);
    DbHelper.updateParkingField(parkingModel.parkId, {
      parkingFieldParkImages: parkingModel.parkImageList,
    }).then((value) {
      EasyLoading.dismiss();
      setState(() {});
    }).catchError((onError) {
      EasyLoading.dismiss();
      log(onError.toString());
    });
  }

  void _updateParkingInfo() async {
    if (formKey.currentState!.validate()) {
      EasyLoading.show(status: "Wait Data updating.....");
      String title = nameController.text;
      String address = addressController.text;
      String capacity = capacityController.text;
      String parkingCost = costController.text;
      var parkingDownloadUrlList = [];
      try {
        for (String url in selectImages) {
          String downloadUrl = await DbHelper.uploadImage(url);
          parkingDownloadUrlList.add(downloadUrl);
        }
        parkingDownloadUrlList.addAll(parkingModel.parkImageList);
        _clearForm();
        await DbHelper.updateParkingField(parkingModel.parkId, {
          parkingFieldTitle: title,
          parkingFieldAddress: address,
          parkingFieldCapacity: capacity,
          parkingFieldParkingCost: parkingCost,
          parkingFieldFacilityList: selectFacility.isEmpty
              ? parkingModel.facilityList
              : selectFacility,
          parkingFieldParkingCategoryName: parkingCategory,
          parkingFieldParkImages: parkingDownloadUrlList,
        }).catchError((onError) {
          log(onError.toString());
        });
        Get.snackbar("Information", "Your Place Added Successfully",
            duration: const Duration(seconds: 3),
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.orange,
            showProgressIndicator: true);
        EasyLoading.dismiss();
      } catch (error) {
        EasyLoading.dismiss();
        print(error.toString());
      }
    }
  }

  void _clearForm() {
    nameController.clear();
    costController.clear();
    capacityController.clear();
    addressController.clear();
    selectFacility = [];
    selectImages = [];
    setState(() {});
  }
}
