import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../model/parking_model.dart';
import '../provider/mapProvider.dart';
import '../utils/const.dart';


class MyPlaceItems extends StatelessWidget {
  final ParkingModel parkingModel;
  final MapProvider provider;

  const MyPlaceItems(
      {Key? key, required this.parkingModel, required this.provider})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: CachedNetworkImage(
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                    imageUrl: parkingModel.parkImageList[0],
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          parkingModel.title,
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          parkingModel.address,
                          style: const TextStyle(fontSize: 10),
                        ),
                        Text(
                          "$takaSymbol ${parkingModel.parkingCost}",
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange),
                        ),
                        Text(
                          "Remaining : ${parkingModel.capacity} Slot",
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          "Rating : ${parkingModel.rating} Star",
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        _updateStatus();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 35,
                        width: 62,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: parkingModel.isActive
                              ? CupertinoColors.activeGreen
                              : null,
                          borderRadius: BorderRadius.circular(10),
                          border: parkingModel.isActive
                              ? null
                              : Border.all(width: 1, color: Colors.grey),
                        ),
                        child: FittedBox(
                          child: Text(
                            parkingModel.isActive ? "Live" : "Reviewing",
                            style: TextStyle(
                                color:
                                    parkingModel.isActive ? Colors.white : null,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: () {
                        _deletePlace();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 35,
                        width: 62,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: CupertinoColors.destructiveRed,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const FittedBox(
                          child: Text(
                            "Delete",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        Positioned(
          left: -6,
          top: 5,
          child: Transform.rotate(
            angle: -math.pi / 5.0,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                parkingModel.parkingCategoryName,
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
        )
      ],
    );
  }

  void _updateStatus() {
    if (parkingModel.isActive) {
      EasyLoading.show(status: "Updating...");
      provider.updateParkingField(
          parkId: parkingModel.parkId,
          field: parkingFieldIsActive,
          value: false);
      EasyLoading.dismiss();
    }
  }

  void _deletePlace() {
    EasyLoading.show(status: "Deleting.....");
    try {
      provider.deleteParking(parkingModel.parkId).then((value) {
        EasyLoading.dismiss();
      });
    } catch (error) {
      EasyLoading.dismiss();
      print(error.toString());
    }
  }
}
