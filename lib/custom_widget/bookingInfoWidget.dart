import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../database/dbhelper.dart';
import '../model/booking_model.dart';
import '../model/parking_model.dart';
import '../provider/mapProvider.dart';
import '../utils/const.dart';

class BookingItemWidget extends StatelessWidget {
  final BookingModel bookingModel;
  final MapProvider provider;
  const BookingItemWidget(
      {Key? key, required this.bookingModel, required this.provider})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int endTime = num.parse(bookingModel.startTime).toInt() +
        Duration(hours: int.parse(bookingModel.duration)).inMilliseconds;
    ;

    CountdownTimerController controller = CountdownTimerController(
      endTime: endTime,
      onEnd: () {},
    );

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: bookingModel.startTime == '0'
            ? Colors.redAccent
            : Colors.green.shade300,
        elevation: 8,
        shadowColor: Colors.orange,
        child: FutureBuilder(
            future: FirebaseFirestore.instance
                .collection(collectionParkingPoint)
                .doc(bookingModel.parkingPId)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final parkingModel =
                    ParkingModel.fromMap(snapshot.data!.data()!);
                return ExpansionTile(
                  title: Text(parkingModel.title),
                  subtitle: Text(
                    parkingModel.parkingCategoryName,
                    style: const TextStyle(fontSize: 10),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      bookingModel.startTime != '0'
                          ? DateTime.now().millisecondsSinceEpoch >
                                  num.parse(bookingModel.endTime).toInt()
                              ? const Text(
                                  "Time Expire",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                )
                              : CountdownTimer(
                                  textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                  controller: CountdownTimerController(
                                    endTime:
                                        num.parse(bookingModel.endTime).toInt(),
                                    onEnd: () {},
                                  ),
                                  onEnd: () {},
                                  endTime:
                                      num.parse(bookingModel.endTime).toInt(),
                                )
                          : Text(
                              "${bookingModel.cost}$takaSymbol",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_drop_down_circle_outlined,
                          color: Colors.white)
                    ],
                  ),
                  expandedAlignment: Alignment.topLeft,
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  childrenPadding:
                      const EdgeInsets.only(left: 13, right: 13, bottom: 8),
                  children: [
                    const ElevatedButton(
                        onPressed: null, child: Text("Booking Information")),
                    Text(
                      "Booking ID- ${bookingModel.bId}",
                      style: const TextStyle(fontSize: 12),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      num.parse(bookingModel.duration) < 24
                          ? "Rent Duration- ${bookingModel.duration} Hour"
                          : "Rent Duration- ${num.parse(bookingModel.duration) / 24} Day",
                      style: const TextStyle(fontSize: 12),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Booking Time-"
                      " ${DateFormat("yyyy-MM-dd hh:mm a").format(DateTime.fromMillisecondsSinceEpoch(bookingModel.bookingTime.millisecondsSinceEpoch))}",
                      style: const TextStyle(fontSize: 12),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Start Time- ${bookingModel.startTime == '0' ? "Not Start at yet" : bookingModel.startTime}",
                      style: const TextStyle(fontSize: 12),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        _deleteBookingInfo();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent),
                      child: const Text(
                        "Delete",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                );
              }
              return const SpinKitWave(
                color: Colors.orange,
                size: 50.0,
              );
              ;
            }),
      ),
    );
  }

  void _deleteBookingInfo() async {
    EasyLoading.show(status: "Deleting Booking Info");
    final parkingMap =
        await DbHelper.getParkingInfoById(bookingModel.parkingPId);
    final parkingModel = ParkingModel.fromMap(parkingMap.data()!);
    await DbHelper.deleteBookingInfo(bookingModel.bId, parkingModel)
        .then((value) {
      EasyLoading.dismiss();
      Get.snackbar(
        "Information",
        "Booking Delete Successfully",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }).catchError((onError) {
      EasyLoading.dismiss();
      Get.snackbar(
        "Information",
        "Error Occurs!!!!!",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    });
  }
}
