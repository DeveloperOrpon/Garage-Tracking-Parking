import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:parking_koi/database/dbhelper.dart';
import 'package:parking_koi/model/parking_model.dart';
import 'package:parking_koi/provider/mapProvider.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'View_parkingAds_page.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Notification List"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Consumer<MapProvider>(
          builder: (context, mapProvider, child) => mapProvider
                  .notificationList.isNotEmpty
              ? ListView.builder(
                  itemCount: mapProvider.notificationList.length,
                  itemBuilder: (context, index) {
                    final notification = mapProvider.notificationList[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        tileColor: notification.isShowUser
                            ? Colors.grey
                            : notification.type == "Parking-Booking"
                                ? Colors.green
                                : Colors.orange,
                        title: Text(
                          notification.title,
                          style: TextStyle(
                              color: notification.isShowUser
                                  ? Colors.black
                                  : Colors.white,
                              fontSize: 14,
                              letterSpacing: 1.0),
                        ),
                        leading: notification.type == "Parking-Booking"
                            ? const Icon(Icons.garage, color: Colors.white)
                            : const Icon(Icons.rate_review,
                                color: Colors.white),
                        trailing: Text(
                          timeago.format(DateTime.fromMillisecondsSinceEpoch(
                              notification
                                  .notificationTime.millisecondsSinceEpoch)),
                          style: const TextStyle(
                            color: Colors.black38,
                            fontSize: 12,
                          ),
                        ),
                        onTap: () async {
                          if (notification.type == "Parking-Booking" ||
                              notification.type == "Parking-Rating") {
                            EasyLoading.show(status: "Wait");
                            final parkingMap =
                                await DbHelper.getParkingInfoById(
                                        notification.otherId)
                                    .whenComplete(() {
                              DbHelper.updateNotificationDoc(notification.id);
                              EasyLoading.dismiss();
                            }).catchError((onError) {
                              EasyLoading.dismiss();
                            });
                            final markingModel =
                                ParkingModel.fromMap(parkingMap.data()!);
                            Get.to(ViewParkingAdsPage(
                              parkingModel: markingModel,
                            ));
                          }
                        },
                      ),
                    );
                  },
                )
              : const Center(
                  child: Text("No Notification"),
                )),
    );
  }
}
