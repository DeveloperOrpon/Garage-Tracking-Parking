import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:parking_koi/database/dbhelper.dart';

import '../model/garage_model.dart';
import '../model/parking_model.dart';
import '../model/user_model.dart';
import 'View_parkingAds_page.dart';
import 'chat_page.dart';

class ViewGarageViewPage extends StatelessWidget {
  final GarageModel garageModel;
  const ViewGarageViewPage({Key? key, required this.garageModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: ListView(
        children: [
          const SizedBox(height: 60),
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: Get.width,
                padding: EdgeInsets.all(12),
                margin: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 40),
                    Text(
                      garageModel.name,
                      style: TextStyle(fontSize: 22),
                    ),
                    Text(
                      "${garageModel.address},${garageModel.city},${garageModel.division}",
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                        onPressed: () async {
                          final userMap = await DbHelper.getUserInfoMap(
                              garageModel.ownerUId);
                          final userModer = UserModel.fromMap(userMap.data()!);
                          Get.to(ChatPage(
                            senderUseModel: userModer,
                          ));
                        },
                        child: const Text(
                          "Message",
                          style: TextStyle(color: Colors.white),
                        )),
                    const SizedBox(height: 10),
                    const Divider(),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Total Space",
                          style: TextStyle(fontSize: 18, color: Colors.black54),
                        ),
                        Text(
                          garageModel.totalSpace,
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Total Ads(Parking)",
                          style: TextStyle(fontSize: 18, color: Colors.black54),
                        ),
                        Text(
                          garageModel.parkingAdsPIds!.length.toString(),
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: -Get.width / 7,
                child: Image.asset(
                  "asset/image/Garage_bacground.png",
                  height: 100,
                  width: Get.width / 3,
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
          Container(
            width: Get.width,
            padding: EdgeInsets.all(12),
            margin: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.only(
                      left: 40, right: 40, top: 20, bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Text(
                    "The Parking List :- ",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: garageModel.parkingAdsPIds!.isNotEmpty
                      ? garageModel.parkingAdsPIds!.map((parkingId) {
                          return FutureBuilder(
                              future: FirebaseFirestore.instance
                                  .collection(collectionParkingPoint)
                                  .doc(parkingId)
                                  .get(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final parkingModel = ParkingModel.fromMap(
                                      snapshot.data!.data()!);
                                  return InkWell(
                                    onTap: () {
                                      Get.to(
                                          ViewParkingAdsPage(
                                              parkingModel: parkingModel),
                                          transition:
                                              Transition.leftToRightWithFade);
                                    },
                                    child: Card(
                                      color: Colors.grey.shade300,
                                      elevation: 4,
                                      shadowColor: Colors.orange,
                                      child: ListTile(
                                        leading: const Icon(
                                          Icons.garage,
                                          color: Colors.green,
                                        ),
                                        title: Text(
                                          "Parking ID - $parkingId",
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        subtitle: Text(
                                          parkingModel.address,
                                          style: const TextStyle(
                                            fontSize: 10,
                                            color: Colors.red,
                                          ),
                                        ),
                                        trailing: Text(
                                          "Capacity${parkingModel.capacity}",
                                          style: const TextStyle(
                                            fontSize: 10,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                return const SpinKitWave(
                                  color: Colors.orange,
                                  size: 50.0,
                                );
                              });
                        }).toList()
                      : [
                          Container(
                            alignment: Alignment.center,
                            height: 80,
                            child: const Text(
                              "There Has No Parking Request Accept",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
