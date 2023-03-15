import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../database/dbhelper.dart';
import '../../model/admin_model.dart';
import '../../model/parking_model.dart';
import '../../model/user_model.dart';
import '../../provider/adminProvider.dart';
import '../View_user_profile.dart';

class ShowMyParkingBooked extends StatefulWidget {
  const ShowMyParkingBooked({Key? key}) : super(key: key);

  @override
  State<ShowMyParkingBooked> createState() => _ShowMyParkingBookedState();
}

class _ShowMyParkingBookedState extends State<ShowMyParkingBooked> {
  @override
  void didChangeDependencies() {
    final adminProvider = Provider.of<AdminProvider>(context, listen: false);
    adminProvider.myParkedBooked = [];

    adminProvider.getMyParkedBooked();
    log("length ${adminProvider.myParkedBooked.length}");
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Parking Booked List"),
      ),
      body: Consumer<AdminProvider>(builder: (context, adminProvider, child) {
        return ListView(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: adminProvider.myParkedBooked.isNotEmpty
                  ? adminProvider.myParkedBooked.map((bookingModel) {
                      return FutureBuilder(
                          future: DbHelper.getUserInfoMap(bookingModel.userUId),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final userModel =
                                  UserModel.fromMap(snapshot.data!.data()!);
                              return Stack(
                                children: [
                                  Card(
                                    color: Colors.grey.shade300,
                                    elevation: 4,
                                    shadowColor: Colors.orange,
                                    child: ExpansionTile(
                                      leading: const Icon(
                                        Icons.garage,
                                        color: Colors.green,
                                      ),
                                      title: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Booked-( ${userModel.name} )",
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "ID - ${bookingModel.bId}",
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      subtitle: FutureBuilder<bool>(
                                        future: DbHelper.doesUserExist(
                                            bookingModel.acceptAdminUId!),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            return !snapshot.data!
                                                ? FutureBuilder(
                                                    future: FirebaseFirestore
                                                        .instance
                                                        .collection(
                                                            collectionAdmin)
                                                        .doc(bookingModel
                                                            .acceptAdminUId)
                                                        .get(),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot.hasData) {
                                                        final adminModel =
                                                            AdminModel.fromMap(
                                                                snapshot.data!
                                                                    .data()!);
                                                        return Text(
                                                          "Accept by ${adminModel.name}",
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 10,
                                                            color: Colors.red,
                                                          ),
                                                        );
                                                      }
                                                      return const SpinKitWave(
                                                        color: Colors.orange,
                                                        size: 50.0,
                                                      );
                                                    })
                                                : FutureBuilder(
                                                    future:
                                                        DbHelper.getUserInfoMap(
                                                            bookingModel
                                                                .acceptAdminUId!),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot.hasData) {
                                                        final userModel =
                                                            UserModel.fromMap(
                                                                snapshot.data!
                                                                    .data()!);
                                                        return Text(
                                                          "Accept by ${userModel.name}",
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 10,
                                                            color: Colors.red,
                                                          ),
                                                        );
                                                      }
                                                      return const SpinKitSquareCircle(
                                                        color:
                                                            Colors.orangeAccent,
                                                        size: 50.0,
                                                      );
                                                    },
                                                  );
                                          }
                                          return const SpinKitSquareCircle(
                                            color: Colors.orangeAccent,
                                            size: 50.0,
                                          );
                                        },
                                      ),
                                      trailing: DateTime.now()
                                                  .millisecondsSinceEpoch >
                                              num.parse(bookingModel.endTime)
                                                  .toInt()
                                          ? const Text(
                                              "Time Expire",
                                              style: TextStyle(
                                                  color: Colors.orange,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          : CountdownTimer(
                                              textStyle: const TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold),
                                              controller:
                                                  CountdownTimerController(
                                                endTime: num.parse(
                                                        bookingModel.endTime)
                                                    .toInt(),
                                                onEnd: () {},
                                              ),
                                              onEnd: () {},
                                              endTime: num.parse(
                                                      bookingModel.endTime)
                                                  .toInt(),
                                            ),
                                      children: [
                                        FutureBuilder(
                                          future: DbHelper.getParkingInfoById(
                                              bookingModel.parkingPId),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              final parkingModel =
                                                  ParkingModel.fromMap(
                                                      snapshot.data!.data()!);
                                              return Card(
                                                elevation: 5,
                                                margin: EdgeInsets.all(10),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                          "Parking Name : ${parkingModel.title}"),
                                                      Text(
                                                          "Parking Address : ${parkingModel.address}"),
                                                      Text(
                                                          "User Address : ${userModel.location}"),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }
                                            return const SpinKitSquareCircle(
                                              color: Colors.orangeAccent,
                                              size: 50.0,
                                            );
                                          },
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            Get.to(
                                                ViewUserProfile(
                                                    userModel: userModel),
                                                transition: Transition
                                                    .rightToLeftWithFade);
                                          },
                                          child: const Text(
                                            "Show Booked User Profile",
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10)
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    child: Container(
                                      padding: EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        bookingModel.onlinePayment
                                            ? "Payment Online"
                                            : "Offline Payment",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                    ),
                                  )
                                ],
                              );
                            }
                            return const SpinKitSquareCircle(
                              color: Colors.orangeAccent,
                              size: 50.0,
                            );
                          });
                    }).toList()
                  : [
                      Center(
                        child: Container(
                          alignment: Alignment.center,
                          height: 80,
                          child: const Text(
                            "There Has No BookingInfo",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
            ),
          ],
        );
      }),
    );
  }
}
