import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colorize_text_avatar/colorize_text_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:parking_koi/model/money_transsion_model.dart';
import 'package:parking_koi/model/notification_model.dart';
import 'package:parking_koi/pages/chat_page.dart';
import 'package:provider/provider.dart';

import '../../database/dbhelper.dart';
import '../../model/booking_model.dart';
import '../../model/parking_model.dart';
import '../../model/user_model.dart';
import '../../provider/mapProvider.dart';
import '../../services/Auth_service.dart';
import '../../utils/const.dart';

class GarageOwnerParkingRequest extends StatelessWidget {
  const GarageOwnerParkingRequest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Parking Request"),
      ),
      body: Consumer<MapProvider>(
        builder: (context, mapProvider, child) => mapProvider
                .getMyParkingBookingRequestList()
                .isNotEmpty
            ? ListView.builder(
                itemCount: mapProvider.getMyParkingBookingRequestList().length,
                itemBuilder: (context, index) => AnimationLimiter(
                  child: AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 350),
                    child: SlideAnimation(
                      verticalOffset: -150.0,
                      child: FadeInAnimation(
                        child: _requestUI(mapProvider
                            .getMyParkingBookingRequestList()[index]),
                      ),
                    ),
                  ),
                ),
              )
            : const Center(
                child: Text("No Parking Request"),
              ),
      ),
    );
  }

  Padding _requestUI(BookingModel bookingModel) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Card(
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
                                color: Colors.orange,
                                fontWeight: FontWeight.bold),
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
                            onPressed: null,
                            child: Text("Booking Information")),
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
                                          backgroundImage: NetworkImage(
                                              userModel.profileUrl!),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                  Spacer(),
                                  ElevatedButton(
                                      onPressed: () {
                                        Get.to(
                                            ChatPage(senderUseModel: userModel),
                                            transition:
                                                Transition.leftToRightWithFade);
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green),
                                      child: const Text(
                                        "Message",
                                        style: TextStyle(color: Colors.white),
                                      ))
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
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          )
        ],
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

    log("homeowner : ${garageOwnerModel.name ?? garageOwnerModel.phoneNumber} balance now $balanceNow");
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
    //create notificationModel
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
