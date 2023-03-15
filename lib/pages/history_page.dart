import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../database/dbhelper.dart';
import '../model/booking_model.dart';
import '../model/notification_model.dart';
import '../model/parking_model.dart';
import '../provider/mapProvider.dart';
import 'View_parkingAds_page.dart';

class HistoryPages extends StatefulWidget {
  const HistoryPages({Key? key}) : super(key: key);

  @override
  State<HistoryPages> createState() => _HistoryPagesState();
}

class _HistoryPagesState extends State<HistoryPages> {
  List<NotificationModelOfUser> allNotificationList = [];
  MapProvider? mapProvider;

  @override
  void didChangeDependencies() {
    mapProvider = Provider.of<MapProvider>(context, listen: false);
    List<NotificationModelOfUser> notificationListBooking = List.generate(
      mapProvider!.getMyAcceptBookingList().length,
      (index) => NotificationModelOfUser(
        title: "Booking Is Confirm Tap To Review",
        id: mapProvider!.getMyAcceptBookingList()[index].bId,
        otherId: mapProvider!.getMyAcceptBookingList()[index].parkingPId,
        type: "bookingModel",
        notificationTime: Timestamp.fromMillisecondsSinceEpoch(
            num.parse(mapProvider!.getMyAcceptBookingList()[index].startTime)
                .toInt()),
      ),
    );

    allNotificationList.addAll(notificationListBooking);

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return allNotificationList.isEmpty
        ? Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'asset/image/history.png',
                  width: Get.width,
                  height: 200,
                ),
                const SizedBox(height: 100),
                const Text(
                  "No History",
                  style: TextStyle(fontSize: 18, color: Colors.black45),
                ),
                const SizedBox(height: 8),
                const Text(
                  "You Have No Parking History",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          )
        : SafeArea(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  height: 50,
                  width: Get.width,
                  decoration: const BoxDecoration(
                      color: Colors.orangeAccent,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      )),
                  child: const Text(
                    "Notification",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: allNotificationList.length,
                      itemBuilder: (context, index) {
                        final bookingModel = mapProvider!
                            .getMyAcceptBookingList()
                            .firstWhere((element) =>
                                element.bId == allNotificationList[index].id);
                        return AnimationLimiter(
                          child: AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 350),
                            child: SlideAnimation(
                              verticalOffset: -150.0,
                              child: FadeInAnimation(
                                child: Card(
                                  color: (allNotificationList[index].type ==
                                              "bookingModel" &&
                                          !bookingModel.showBookedUser)
                                      ? Colors.green.shade200
                                      : Colors.grey.shade200,
                                  elevation: 5,
                                  child: ListTile(
                                    onTap: () {
                                      if (allNotificationList[index].type ==
                                          "bookingModel") {
                                        DbHelper.updateBookingField(
                                            allNotificationList[index].id, {
                                          bookingFieldIsBookedUserShow: true,
                                        });
                                        DbHelper.getParkingById(
                                                allNotificationList[index]
                                                    .otherId)
                                            .listen((snapshot) {
                                          final parkingModel =
                                              ParkingModel.fromMap(
                                                  snapshot.data()!);
                                          Get.to(ViewParkingAdsPage(
                                            parkingModel: parkingModel,
                                          ))?.whenComplete(() {
                                            setState(() {});
                                          });
                                        });
                                      }
                                    },
                                    leading: const Icon(
                                      Icons.garage,
                                      color: Colors.orange,
                                    ),
                                    title:
                                        Text(allNotificationList[index].title),
                                    trailing: Text(timeago.format(
                                        DateTime.fromMillisecondsSinceEpoch(
                                            allNotificationList[index]
                                                .notificationTime
                                                .millisecondsSinceEpoch))),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
          );
  }
}
