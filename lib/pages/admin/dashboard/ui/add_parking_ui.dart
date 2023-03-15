import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';


import '../../../../database/dbhelper.dart';
import '../../../../model/parking_model.dart';
import '../../../../provider/mapProvider.dart';
import '../../../../utils/const.dart';
import '../../../fullScreenImage.dart';

class RequestParkingUi extends StatelessWidget {
  final ParkingModel parkingModel;
  final MapProvider provider;

  const RequestParkingUi(
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
              color: Colors.red.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: ExpansionTile(
              title: Text(
                parkingModel.title,
                style: const TextStyle(fontSize: 16),
              ),
              leading: ClipRRect(
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
              subtitle: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      _accept(parkingModel);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 40,
                      width: 62,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: CupertinoColors.activeGreen,
                        borderRadius: BorderRadius.circular(10),
                        border: parkingModel.isActive
                            ? null
                            : Border.all(width: 1, color: Colors.grey),
                      ),
                      child: const FittedBox(
                        child: Text(
                          "Accept",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              children: [
                Container(
                  alignment: Alignment.center,
                  height: 120,
                  width: Get.width,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: parkingModel.parkImageList.length,
                    itemBuilder: (context, index) => InkWell(
                      onTap: () {
                        Get.to(
                            FullScreenPage(
                                imageUrl: parkingModel.parkImageList[index]),
                            curve: Curves.bounceInOut,
                            transition: Transition.zoom);
                      },
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.orange, width: 5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Hero(
                            tag: parkingModel.parkImageList[index],
                            child: CachedNetworkImage(
                              imageUrl: parkingModel.parkImageList[index],
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    //_deletePlace();
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                    alignment: Alignment.center,
                    height: 40,
                    width: 80,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: CupertinoColors.destructiveRed,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const FittedBox(
                      child: Text(
                        "Delete",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
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
                color: Colors.green,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                parkingModel.parkingCategoryName,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
        )
      ],
    );
  }

  void _accept(ParkingModel parkingModel) async {
    EasyLoading.show(status: "Wait.....");
    DbHelper.updateParkingField(parkingModel.parkId, {
      parkingFieldIsActive: true,
    }).then((value) {
      EasyLoading.dismiss();
    }).catchError((onError) {
      EasyLoading.dismiss();
    });
  }
}
