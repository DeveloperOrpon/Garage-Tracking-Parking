import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:parking_koi/pages/admin/dashboard/update_parking_places.dart';
import 'package:provider/provider.dart';

import '../../../database/dbhelper.dart';
import '../../../model/booking_model.dart';
import '../../../model/parking_model.dart';
import '../../../model/user_model.dart';
import '../../../provider/mapProvider.dart';
import '../../../services/Auth_service.dart';
import '../../../utils/const.dart';
import '../core/constants/color_constants.dart';

class AllParkingShowPage extends StatelessWidget {
  const AllParkingShowPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Parking Information"),
      ),
      body: Consumer<MapProvider>(
        builder: (context, mapProvider, child) =>
            mapProvider.activeParkingList.isNotEmpty
                ? ListView.builder(
                    itemCount: mapProvider.activeParkingList.length,
                    itemBuilder: (context, index) => ParkingPostUi(
                      mapProvider: mapProvider,
                      parkingModel: mapProvider.activeParkingList[index],
                    ),
                  )
                : const Center(
                    child: Text(
                      "There Have No Parking Ads",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
      ),
    );
  }
}

class ParkingPostUi extends StatelessWidget {
  const ParkingPostUi(
      {Key? key, required this.mapProvider, required this.parkingModel})
      : super(key: key);
  final MapProvider mapProvider;
  final ParkingModel parkingModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: DottedBorder(
        color: Colors.pink,
        strokeWidth: 1,
        radius: const Radius.circular(10),
        dashPattern: const [8, 4],
        child: Container(
          padding: const EdgeInsets.only(
              top: defaultPadding, bottom: defaultPadding, left: 5, right: 5),
          decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.orangeAccent.withOpacity(.2),
                  offset: const Offset(2, 2),
                  spreadRadius: 1,
                  blurRadius: 6,
                )
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection(collectionUser)
                    .doc(parkingModel.uId)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final user = UserModel.fromMap(snapshot.data!.data()!);
                    log(user.toString());
                    return Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(
                              left: 13.0, bottom: 10, top: 10, right: 13),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(.4),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("User Name: ${user.name ?? "admin"}"),
                              Text("Address: ${user.location ?? "admin"}"),
                            ],
                          ),
                        ),
                        Expanded(
                            child: Text(
                          textAlign: TextAlign.end,
                          parkingModel.parkingCategoryName,
                          style: const TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold),
                        ))
                      ],
                    );
                  }
                  if (snapshot.hasError) {
                    return const Text("error");
                  }
                  return const Text("Loading....");
                },
              ),
              ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    height: 100,
                    width: 80,
                    fit: BoxFit.cover,
                    imageUrl: parkingModel.parkImageList[0],
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
                title: Text(parkingModel.title),
                subtitle: Text(parkingModel.address),
                trailing: Text(
                  '${parkingModel.parkingCost}$takaSymbol',
                  style: const TextStyle(
                      color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(defaultPadding * 0.75),
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xfff5af19).withOpacity(0.1),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: FittedBox(
                        child: Text(
                          "Capacity : ${parkingModel.capacity}/${parkingModel.capacityRemaining}",
                          style: const TextStyle(color: Colors.green),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                      Get.to(const UpdateParkingPlace(),
                          arguments: parkingModel,
                          transition: Transition.cupertino);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade300,
                    ),
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.green,
                    ),
                    label: const Text(
                      "Edit",
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: null,
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    label: const Text(
                      "Delete",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _recheckReview,
                      icon: const Icon(
                        Icons.remove_red_eye,
                        color: Colors.red,
                      ),
                      label: const Text(
                        "Recheck Review",
                        style: TextStyle(color: Colors.red),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _booking,
                      icon: const Icon(
                        Icons.bookmark,
                        color: Colors.white,
                      ),
                      label: const FittedBox(
                        child: Text(
                          "Booking For Park",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _recheckReview() {
    EasyLoading.show(status: "Wait.....");
    DbHelper.updateParkingField(parkingModel.parkId, {
      parkingFieldIsActive: false,
    }).then((value) {
      EasyLoading.dismiss();
    }).catchError((onError) {
      EasyLoading.dismiss();
    });
  }

  void _booking() {
    final bookingModel = BookingModel(
      bId: DateTime.now().millisecondsSinceEpoch.toString(),
      parkingPId: parkingModel.parkId,
      userUId: AuthService.currentUser!.uid,
      duration: '2',
      cost: '500',
      onlinePayment: true,
      selectVehicleType: "MotoCycle",
      bookingTime: Timestamp.now(),
    );
    mapProvider.bookingParkingPlace(bookingModel, parkingModel);
  }
}
