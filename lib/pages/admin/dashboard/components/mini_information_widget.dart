import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../../provider/adminProvider.dart';
import '../../../../provider/mapProvider.dart';
import '../../../../utils/helper_function.dart';
import '../../core/constants/color_constants.dart';
import '../../models/daily_info_model.dart';
import '../CommentRatingApprovePage.dart';
import '../add_request_page.dart';
import '../all_garage_page.dart';
import '../all_parkingList_page.dart';
import '../become_garage_owner_request.dart';
import '../cash_withdraw_request.dart';
import '../garage_ads_request_page.dart';
import '../parking_request_page.dart';
import '../show_Users_page.dart';
import '../vat_coupon_code_page.dart';

class MiniInformationWidget extends StatelessWidget {
  const MiniInformationWidget({
    Key? key,
    required this.dailyData,
  }) : super(key: key);
  final DailyInfoModel dailyData;

  @override
  Widget build(BuildContext context) {
    return Consumer<MapProvider>(
      builder: (context, provider, child) => InkWell(
        onTap: () {
          dailyData.title == "All Parking"
              ? Get.to(const AllParkingShowPage(),
                  curve: Curves.bounceInOut, transition: Transition.leftToRight)
              : dailyData.title == "Parking Booking Request"
                  ? Get.to(const ParkingRequestPage(),
                      curve: Curves.bounceInOut,
                      transition: Transition.leftToRight)
                  : dailyData.title == "Ads Request"
                      ? Get.to(const AddRequestOfParkingGarage(),
                          curve: Curves.bounceInOut,
                          transition: Transition.leftToRight)
                      : dailyData.title == "Show All User"
                          ? Get.to(const ShowAllUserPage(),
                              curve: Curves.bounceInOut,
                              transition: Transition.leftToRight)
                          : dailyData.title == "All Garage"
                              ? Get.to(const AllGarageShowPage(),
                                  curve: Curves.bounceInOut,
                                  transition: Transition.leftToRight)
                              : dailyData.title == "Garage Request"
                                  ? Get.to(const GarageAdsRequestPage(),
                                      curve: Curves.bounceInOut,
                                      transition: Transition.leftToRight)
                                  : dailyData.title == "Vat and Coupon Code"
                                      ? Get.to(const VatAndCouponCodePage(),
                                          curve: Curves.bounceInOut,
                                          transition: Transition.leftToRight)
                                      : dailyData.title ==
                                              "Become A Garage Owner Request"
                                          ? Get.to(
                                              const BecomeGarageOwnerRequest(),
                                              curve: Curves.bounceInOut,
                                              transition:
                                                  Transition.leftToRight)
                                          : dailyData.title ==
                                                  "Cash Withdraw Request"
                                              ? Get.to(
                                                  const CashWithDrawRequest(),
                                                  curve: Curves.bounceInOut,
                                                  transition:
                                                      Transition.leftToRight)
                                              : Get.to(
                                                  const CommentRatingApprovePage(),
                                                  curve: Curves.bounceInOut,
                                                  transition:
                                                      Transition.leftToRight);
        },
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.all(defaultPadding),
              decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orangeAccent.withOpacity(.2),
                      offset: const Offset(2, 2),
                      spreadRadius: 1,
                      blurRadius: 6,
                    )
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(defaultPadding * 0.75),
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: dailyData.color!.withOpacity(0.1),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Icon(
                      dailyData.icon,
                      color: dailyData.color,
                      size: 18,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Text(
                          textAlign: TextAlign.center,
                          dailyData.title!,
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  ProgressLine(
                    color: dailyData.color!,
                    percentage: 100,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Consumer<AdminProvider>(
                        builder: (context, adminProvider, child) => Text(
                          dailyData.title == "All Parking"
                              ? calculateNumberOfParkingPlaces(
                                  provider.parkingList)
                              : dailyData.title == "Parking Booking Request"
                                  ? ''
                                  : dailyData.title == "Ads Request"
                                      ? ''
                                      : dailyData.title == "Show All User"
                                          ? adminProvider.allUserList.length
                                              .toString()
                                          : dailyData.title == "All Garage"
                                              ? provider
                                                  .getGarageRequestAccept()
                                                  .length
                                                  .toString()
                                              : dailyData.title ==
                                                      "Garage Request"
                                                  ? ''
                                                  : '',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: dailyData.color),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            if (dailyData.title == "Ads Request" &&
                provider.unActiveParkingList.isNotEmpty)
              Positioned(
                right: -5,
                top: -5,
                child: CircleAvatar(
                  backgroundColor: Colors.red,
                  radius: 14,
                  child: Text(provider.unActiveParkingList.length.toString()),
                ),
              ),
            //adminProvider.getBookingRequest()

            if (dailyData.title == "Parking Booking Request")
              Positioned(
                right: -5,
                top: -5,
                child: Consumer<AdminProvider>(
                    builder: (context, adminProvider, child) =>
                        adminProvider.getBookingRequest().isNotEmpty
                            ? CircleAvatar(
                                backgroundColor: Colors.red,
                                radius: 14,
                                child: Text(adminProvider
                                    .getBookingRequest()
                                    .length
                                    .toString()),
                              )
                            : Container()),
              ),
            if (dailyData.title == "Garage Request")
              Positioned(
                right: -5,
                top: -5,
                child: Consumer<MapProvider>(
                    builder: (context, mapProvider, child) =>
                        mapProvider.getGarageRequest().isNotEmpty
                            ? CircleAvatar(
                                backgroundColor: Colors.red,
                                radius: 14,
                                child: Text(mapProvider
                                    .getGarageRequest()
                                    .length
                                    .toString()),
                              )
                            : Container()),
              ),
            if (dailyData.title == "Comment & Rating Request")
              Positioned(
                right: -5,
                top: -5,
                child: Consumer<MapProvider>(
                  builder: (context, mapProvider, child) => mapProvider
                          .allRatingModelList.isNotEmpty
                      ? CircleAvatar(
                          backgroundColor: Colors.red,
                          radius: 14,
                          child: Text(
                              mapProvider.allRatingModelList.length.toString()),
                        )
                      : Container(),
                ),
              ),
            if (dailyData.title == "Become A Garage Owner Request")
              Positioned(
                right: -5,
                top: -5,
                child: Consumer<AdminProvider>(
                  builder: (context, adminProvider, child) =>
                      adminProvider.getRequestGarageOwner().isNotEmpty
                          ? CircleAvatar(
                              backgroundColor: Colors.red,
                              radius: 14,
                              child: Text(adminProvider
                                  .getRequestGarageOwner()
                                  .length
                                  .toString()),
                            )
                          : Container(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class LineChartWidget extends StatelessWidget {
  const LineChartWidget({
    Key? key,
    required this.colors,
    required this.spotsData,
  }) : super(key: key);
  final List<Color>? colors;
  final List<FlSpot>? spotsData;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 20,
          child: LineChart(
            LineChartData(
                lineBarsData: [
                  LineChartBarData(
                      spots: spotsData,
                      belowBarData: BarAreaData(show: false),
                      aboveBarData: BarAreaData(show: false),
                      isCurved: true,
                      dotData: FlDotData(show: false),
                      color: Colors.orangeAccent,
                      barWidth: 3),
                ],
                lineTouchData: LineTouchData(enabled: false),
                titlesData: FlTitlesData(show: false),
                gridData: FlGridData(show: false),
                borderData: FlBorderData(show: false)),
            swapAnimationDuration: Duration(seconds: 1),
            swapAnimationCurve: Curves.bounceInOut,
          ),
        ),
      ],
    );
  }
}

class ProgressLine extends StatelessWidget {
  const ProgressLine({
    Key? key,
    this.color = primaryColor,
    required this.percentage,
  }) : super(key: key);

  final Color color;
  final int percentage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 5,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) => Container(
            width: constraints.maxWidth * (percentage / 100),
            height: 5,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
      ],
    );
  }
}
