import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:horizontal_calendar/horizontal_calendar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../model/parking_model.dart';
import '../provider/mapProvider.dart';
import '../utils/const.dart';
import 'View_parkingAds_page.dart';

class ParkingAdsInCalendar extends StatefulWidget {
  const ParkingAdsInCalendar({Key? key}) : super(key: key);

  @override
  State<ParkingAdsInCalendar> createState() => _ParkingAdsInCalendarState();
}

class _ParkingAdsInCalendarState extends State<ParkingAdsInCalendar> {
  List<ParkingModel> selectedDayBooking = [];
  @override
  void didChangeDependencies() {
    getDayBookingModel(
        DateTime.now().day.toString(),
        DateTime.now().month.toString(),
        Provider.of<MapProvider>(context, listen: false));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Parking Available "),
      ),
      body: Consumer<MapProvider>(
        builder: (context, mapProvider, child) => ListView(
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              child: DottedBorder(
                color: Colors.pink,
                strokeWidth: 1,
                radius: const Radius.circular(10),
                dashPattern: const [8, 4],
                child: Container(
                  margin: EdgeInsets.only(bottom: 25, left: 5, right: 5),
                  child: HorizontalCalendar(
                    date: DateTime.now(),
                    initialDate:
                        DateTime(DateTime.now().year, DateTime.now().month - 6),
                    lastDate:
                        DateTime(DateTime.now().year, DateTime.now().month + 6),
                    textColor: Colors.black45,
                    backgroundColor: Colors.white,
                    selectedColor: Colors.orangeAccent,
                    showMonth: true,
                    onDateSelected: (date) {
                      final selectDay = DateFormat('dd')
                          .format(DateFormat('yyyy-MM-dd').parse(date));
                      var selectMonth = DateFormat('MM')
                          .format(DateFormat('yyyy-MM-dd').parse(date));
                      if (selectMonth[0] == '0') {
                        selectMonth = selectMonth[1];
                      }
                      getDayBookingModel(selectDay, selectMonth, mapProvider);
                      log(selectMonth);
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: selectedDayBooking.isNotEmpty
                  ? selectedDayBooking
                      .map((parking) => AnimationConfiguration.staggeredList(
                            position: 1,
                            delay: const Duration(milliseconds: 100),
                            child: SlideAnimation(
                              duration: const Duration(milliseconds: 2500),
                              curve: Curves.fastLinearToSlowEaseIn,
                              horizontalOffset: -250,
                              child: ScaleAnimation(
                                duration: const Duration(milliseconds: 1500),
                                curve: Curves.fastLinearToSlowEaseIn,
                                child: InkWell(
                                  onTap: () {
                                    Get.to(
                                        ViewParkingAdsPage(
                                          parkingModel: parking,
                                        ),
                                        transition: Transition.zoom);
                                  },
                                  child: Card(
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Row(
                                        children: [
                                          Stack(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                child: CachedNetworkImage(
                                                  width: Get.width * .44,
                                                  height: 200,
                                                  fit: BoxFit.cover,
                                                  imageUrl:
                                                      parking.parkImageList[0],
                                                  placeholder: (context, url) =>
                                                      const CircularProgressIndicator(),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      const Icon(Icons.error),
                                                ),
                                              ),
                                              Container(
                                                width: Get.width * .44,
                                                padding:
                                                    const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      Colors.transparent,
                                                      Colors.black
                                                          .withOpacity(.8)
                                                    ],
                                                    begin:
                                                        Alignment.bottomCenter,
                                                    end: Alignment.topCenter,
                                                    stops: const [
                                                      0.6,
                                                      1
                                                    ], //start of color
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            width:
                                                (Get.width - Get.width * .33) -
                                                    70,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                FittedBox(
                                                    child: Text(
                                                        " ${parking.title}")),
                                                Text(
                                                    "$takaSymbol${parking.capacity}/h"),
                                                Text(
                                                    "Slot : ${parking.capacity}"),
                                                Text(
                                                    "Rating : ${parking.rating}"),
                                                const SizedBox(height: 10),
                                                Container(
                                                  alignment: Alignment.center,
                                                  height: 45,
                                                  width: 80,
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    color: CupertinoColors
                                                        .activeGreen,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: const FittedBox(
                                                    child: Text(
                                                      "Book Now",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ))
                      .toList()
                  : [
                      const SizedBox(height: 30),
                      Center(child: Text("No Parking Infomation!!")),
                    ],
            ),
          ],
        ),
      ),
    );
  }

  getDayBookingModel(String day, String month, MapProvider provider) {
    selectedDayBooking = provider.parkingList.where((element) {
      return DateTime.fromMillisecondsSinceEpoch(
                      element.createTime.millisecondsSinceEpoch)
                  .day
                  .toString() ==
              day &&
          DateTime.fromMillisecondsSinceEpoch(
                      element.createTime.millisecondsSinceEpoch)
                  .month
                  .toString() ==
              month;
    }).toList();
    setState(() {});
  }
}
