import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colorize_text_avatar/colorize_text_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../database/dbhelper.dart';
import '../../../model/admin_model.dart';
import '../../../model/booking_model.dart';
import '../../../model/money_transsion_model.dart';
import '../../../model/notification_model.dart';
import '../../../model/parking_model.dart';
import '../../../model/user_model.dart';
import '../../../provider/adminProvider.dart';
import '../../../services/Auth_service.dart';
import '../../../utils/const.dart';

class ParkingRequestPage extends StatelessWidget {
  const ParkingRequestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Parking Request List"),
      ),
      body: Consumer<AdminProvider>(builder: (context, adminProvider, child) {
        return ListView(
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.only(
                  left: 40, right: 40, top: 10, bottom: 10),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Text(
                "All the request for parking ",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: adminProvider.getBookingRequest().isNotEmpty
                  ? adminProvider.getBookingRequest().map((bookingModel) {
                      return _requestUI(bookingModel);
                    }).toList()
                  : [
                      Container(
                        alignment: Alignment.center,
                        height: 80,
                        child: const Text(
                          "There Has No Parking Request",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
            ),

            //accepts list
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
                "The request are Accepts List ",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: adminProvider.getBookingRequestAccept().isNotEmpty
                  ? adminProvider.getBookingRequestAccept().map((bookingModel) {
                      return Card(
                        color: Colors.grey.shade300,
                        elevation: 4,
                        shadowColor: Colors.orange,
                        child: ListTile(
                          leading: const Icon(
                            Icons.garage,
                            color: Colors.green,
                          ),
                          title: Text(
                            "ID - ${bookingModel.bId}",
                            style: const TextStyle(
                                fontSize: 12,
                                color: Colors.green,
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: FutureBuilder(
                            future: DbHelper.doesUserExist(
                                bookingModel.acceptAdminUId!),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return !snapshot.data!
                                    ? FutureBuilder(
                                        future: FirebaseFirestore.instance
                                            .collection(collectionAdmin)
                                            .doc(bookingModel.acceptAdminUId)
                                            .get(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            final adminModel =
                                                AdminModel.fromMap(
                                                    snapshot.data!.data()!);
                                            return Text(
                                              "Accept by ${adminModel.name}",
                                              style: const TextStyle(
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
                                        future: DbHelper.getUserInfoMap(
                                            bookingModel.acceptAdminUId!),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            final userModel = UserModel.fromMap(
                                                snapshot.data!.data()!);
                                            return Text(
                                              "Accept by ${userModel.name}",
                                              style: const TextStyle(
                                                fontSize: 10,
                                                color: Colors.red,
                                              ),
                                            );
                                          }
                                          return const SpinKitWave(
                                            color: Colors.orange,
                                            size: 50.0,
                                          );
                                        },
                                      );
                              }
                              return const SpinKitWave(
                                color: Colors.orange,
                                size: 50.0,
                              );
                            },
                          ),
                          trailing: DateTime.now().millisecondsSinceEpoch >
                                  num.parse(bookingModel.endTime).toInt()
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
                                  controller: CountdownTimerController(
                                    endTime:
                                        num.parse(bookingModel.endTime).toInt(),
                                    onEnd: () {},
                                  ),
                                  onEnd: () {},
                                  endTime:
                                      num.parse(bookingModel.endTime).toInt(),
                                ),
                        ),
                      );
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
        );
      }),
    );
  }

  Padding _requestUI(BookingModel bookingModel) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Colors.grey.shade300,
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
                      Text(
                        "${bookingModel.cost}$takaSymbol",
                        style: const TextStyle(
                            color: Colors.orange, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.arrow_drop_down_circle_outlined,
                        color: Colors.orange,
                      )
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
                      "Rent Duration- ${bookingModel.duration} ${parkingModel.parkingCategoryName}",
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
                    const ElevatedButton(
                        onPressed: null, child: Text("User Information")),
                    FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection(collectionUser)
                          .doc(bookingModel.userUId)
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final userModel =
                              UserModel.fromMap(snapshot.data!.data()!);
                          return Row(
                            children: [
                              userModel.profileUrl != null
                                  ? CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(userModel.profileUrl!),
                                    )
                                  : TextAvatar(
                                      size: 35,
                                      backgroundColor: Colors.white,
                                      textColor: Colors.white,
                                      fontSize: 14,
                                      upperCase: true,
                                      numberLetters: 1,
                                      shape: Shape.Rectangle,
                                      text: userModel.name!,
                                    ),
                              const SizedBox(width: 6),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "UserName : ${userModel.name}",
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    "UserName : ${userModel.phoneNumber}",
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          );
                        }
                        return const SpinKitWave(
                          color: Colors.orange,
                          size: 50.0,
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _acceptRequest(bookingModel);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green),
                          child: const Text(
                            "Accept",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent),
                          child: const Text(
                            "Delete",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
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

  void _acceptRequest(BookingModel bookingModel) async {
    EasyLoading.show(status: "Waiting.....");
    final map = await DbHelper.getParkingInfoById(bookingModel.parkingPId);
    final parkModel = ParkingModel.fromMap(map.data()!);
    final userMap = await DbHelper.getUserInfoMap(parkModel.uId);
    final garageOwnerModel = UserModel.fromMap(userMap.data()!);

    String balanceNow =
        (num.parse(garageOwnerModel.balance) + num.parse(bookingModel.cost))
            .toStringAsFixed(2);

    log("nameowner : ${garageOwnerModel.name ?? garageOwnerModel.phoneNumber} balance now $balanceNow");
    int endTime = DateTime.now().millisecondsSinceEpoch +
        Duration(hours: int.parse(bookingModel.duration)).inMilliseconds;
    //make a collectionTransaction model
    final moneyTransactionModel = MoneyTransactionModel(
      tId: "T-${DateTime.now().millisecondsSinceEpoch}",
      bId: bookingModel.bId,
      pId: parkModel.parkId,
      tType: "Parking-Booking",
      amount: bookingModel.cost,
      vat: '0',
      userId: bookingModel.userUId,
      gOwnerId: garageOwnerModel.uid,
      tGenerateTime: Timestamp.now(),
    );
    final notificationModel = NotificationModelOfUser(
      title: "Booking Is Confirm Tap To Review",
      id: "N-${DateTime.now().millisecondsSinceEpoch}",
      otherId: parkModel.parkId,
      type: "Parking-Booking",
      notificationTime: Timestamp.now(),
    );
    await DbHelper.bookingRequestAccept(
            {
              bookingFieldIsAccept: true,
              bookingFieldAcceptAdminUId: AuthService.currentUser!.uid,
              bookingFieldEndTime: endTime.toString(),
              bookingFieldStartTime:
                  DateTime.now().millisecondsSinceEpoch.toString(),
            },
            bookingModel,
            garageOwnerModel,
            {
              userFieldBalance: balanceNow,
            },
            moneyTransactionModel,
            notificationModel)
        .then((value) {
      EasyLoading.dismiss();
    }).catchError((onError) {
      EasyLoading.dismiss();
      log("error id=s ${onError.toString()}");
    });
  }
}
