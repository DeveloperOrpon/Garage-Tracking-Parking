import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:parking_koi/pages/profile_page.dart';
import 'package:provider/provider.dart';

import '../model/booking_model.dart';
import '../model/parking_model.dart';
import '../provider/mapProvider.dart';
import 'View_garage_page.dart';

class AllGaragesPage extends StatelessWidget {
  const AllGaragesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<MapProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                title: Image.asset(
                  'asset/image/logo.png',
                  height: 100,
                  width: 120,
                ),
                centerTitle: true,
                expandedHeight: 200,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    alignment: Alignment.topLeft,
                    padding:
                        const EdgeInsets.only(top: 100, left: 20, right: 20),
                    height: 200,
                    color: Colors.white,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                text: "Hey, ",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 26,
                                ),
                              ),
                              TextSpan(
                                text: provider.userModel!.name ?? "No Name",
                                style: const TextStyle(
                                    color: Colors.orange,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Find Garages Your Near..",
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${provider.getGarageRequestAccept().length} result found",
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 22,
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                side: BorderSide(
                                  color: Colors.grey.shade300,
                                  width: .5,
                                ),
                              ),
                              icon: const Icon(
                                Icons.sort_outlined,
                                color: Colors.orange,
                                size: 28,
                              ),
                              label: const Text(
                                "Sort",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverList(
                  delegate: SliverChildBuilderDelegate(
                childCount: provider.getGarageRequestAccept().length,
                (context, index) => AnimationLimiter(
                    child: AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 375),
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: InkWell(
                        onTap: () {
                          Get.to(
                              ViewGarageViewPage(
                                  garageModel:
                                      provider.getGarageRequestAccept()[index]),
                              transition: Transition.leftToRightWithFade);
                        },
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.all(15),
                          height: 110,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              colors: [
                                Colors.orange.shade100,
                                Colors.grey.shade200,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      width: Get.width / 2,
                                      child: Text(
                                        provider
                                            .getGarageRequestAccept()[index]
                                            .name,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  Text(
                                      "${provider.getGarageRequestAccept()[index].address}\n${provider.getGarageRequestAccept()[index].city}\n${provider.getGarageRequestAccept()[index].division}",
                                      style: const TextStyle(fontSize: 12)),
                                  Text(
                                      "Space Remaining :${provider.getGarageRequestAccept()[index].totalSpace}",
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.orange)),
                                ],
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: InkWell(
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 44,
                                    width: 90,
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: CupertinoColors.activeGreen,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const FittedBox(
                                      child: Text(
                                        "About Info",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )),
              ))
            ],
          ),
        );
      },
    );
  }

  void _confirmBooking(ParkingModel parkingModel, MapProvider provider) {
    var cost = int.parse(parkingModel.parkingCost);
    if (num.parse(provider.userModel!.balance) - cost <= 0) {
      Get.snackbar(
        "Your Balance is to low!",
        "Please Recharge your account",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        onTap: (snack) {
          Get.back();
          Get.to(() => const ProfilePage());
        },
      );
      return;
    }

    final bookingModel = BookingModel(
      bId: DateTime.now().microsecondsSinceEpoch.toString(),
      parkingPId: parkingModel.parkId,
      userUId: provider.userModel!.uid,
      duration: '24',
      cost: cost.toString(),
      onlinePayment: true,
      selectVehicleType: "MotoCycle",
      bookingTime: Timestamp.now(),
    );
    Get.back();
    try {
      provider.bookingParkingPlace(bookingModel, parkingModel);
      Get.snackbar("Your Request Sent", "Please Wait for Conformation");
    } catch (error) {
      Get.snackbar(error.toString(), "message");
    }
  }
}
