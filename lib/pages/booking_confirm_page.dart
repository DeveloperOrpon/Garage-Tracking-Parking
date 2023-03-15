import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../database/dbhelper.dart';
import '../model/booking_model.dart';
import '../model/parking_model.dart';
import '../utils/const.dart';
import 'admin/dashboard/dashboard_screen.dart';

class BookingConfirmPage extends StatelessWidget {
  final BookingModel bookingModel;

  const BookingConfirmPage({super.key, required this.bookingModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Confirmation'),
      ),
      body: FutureBuilder(
          future: DbHelper.getParkingInfoById(bookingModel.parkingPId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final parkingModel = ParkingModel.fromMap(snapshot.data!.data()!);
              return Column(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.all(8),
                    height: 80,
                    width: Get.width,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          offset: const Offset(3, 3),
                          blurRadius: 5,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 10),
                        Text(
                          parkingModel.title,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.red,
                          child: Text(
                            "${bookingModel.cost}$takaSymbol",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  QrImage(
                    data: "B-${bookingModel.bId}",
                    version: QrVersions.auto,
                    size: 200.0,
                    embeddedImage: AssetImage('asset/image/logo.png'),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    margin: const EdgeInsets.all(8),
                    width: Get.width,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          offset: const Offset(4, 6),
                          blurRadius: 8,
                          spreadRadius: 8,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "Booking Information",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        ListTile(
                          title: const Text("Parking Started Time"),
                          trailing: Text(bookingModel.startTime),
                        ),
                        ListTile(
                          title: const Text("Parking EndTime"),
                          trailing: Text(bookingModel.endTime),
                        ),
                        ListTile(
                          title: Text("Booking Status"),
                          trailing: Text(
                              bookingModel.isAccept ? "Active" : "End/Waiting"),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  CupertinoButton(
                    onPressed: () {
                      Get.offAll(const DashboardScreen(),
                          transition: Transition.leftToRight);
                    },
                    color: Colors.indigoAccent,
                    child: const Text(
                      "Go Back To Home",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  )
                ],
              );
            }
            return const SpinKitSquareCircle(
              color: Colors.orange,
              size: 50.0,
            );
          }),
    );
  }
}
