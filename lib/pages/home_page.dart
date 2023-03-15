import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parking_koi/pages/parking_ads_calendar.dart';
import 'package:parking_koi/pages/profile_page.dart';
import 'package:parking_koi/pages/search_page.dart';
import 'package:parking_koi/provider/adminProvider.dart';
import 'package:provider/provider.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

import '../controllers/home_controller.dart';
import '../custom_widget/bottom_navigation_bar.dart';
import '../custom_widget/feature_item_view.dart';
import '../database/dbhelper.dart';
import '../map/ads_in_map.dart';
import '../model/parking_rating_model.dart';
import '../provider/mapProvider.dart';
import '../utils/clipper.dart';
import '../utils/const.dart';
import '../utils/featureData.dart';
import 'View_parkingAds_page.dart';
import 'about_page.dart';
import 'garages_preview.dart';
import 'history_page.dart';
import 'message_page.dart';
import 'notification_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mapProvider = Provider.of<MapProvider>(context, listen: false);
    var adminProvider = Provider.of<AdminProvider>(context, listen: false);

    final controller = Get.find<HomeController>();
    mapProvider.getUserInfo();
    controller.notificationGetStatus();
    mapProvider.getAllParkingPoint();
    mapProvider.getMyParkingPoint();
    mapProvider.determinePosition();
    mapProvider.getAddressFromLatLong();
    mapProvider.getAllBookedParking();
    mapProvider.getAllGarageInfo();
    mapProvider.getActiveParkingPoint();
    mapProvider.getNotifications();
    mapProvider.getUserMessages();
    mapProvider.getServiceCost();
    adminProvider.adminInList();
    adminProvider.userAdminList();
    adminProvider.getAllTransactionList();
    adminProvider.getAllBookedParking();
    mapProvider.getAllBookedParking();
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: const BottomNavigationBarWidget(),
        body: PageView(
          controller: mapProvider.homePageController,
          onPageChanged: (value) {
            mapProvider.homepageIndex = value;
            log("Index $value");
          },
          children: [
            HomePageContent(),
            const MessagePage(),
            const HistoryPages(),
            const ProfilePage(),
          ],
        ),
      ),
    );
  }

  Future<bool> _onWillPop(BuildContext context) async {
    bool? exitResult = await showDialog(
      context: context,
      builder: (context) => _buildExitDialog(context),
    );
    return exitResult ?? false;
  }

  AlertDialog _buildExitDialog(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.orange,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      title: const Text(
        'Please confirm',
        style: TextStyle(color: Colors.white),
      ),
      content: const Text(
        'Do you want to exit the app?',
        style: TextStyle(color: Colors.white),
      ),
      actions: <Widget>[
        OutlinedButton(
          onPressed: () => Navigator.of(context).pop(false),
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.green,
          ),
          child: const Text(
            'No',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        OutlinedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.redAccent,
          ),
          child: const Text(
            'Yes',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Consumer<MapProvider> HomePageContent() {
    return Consumer<MapProvider>(
      builder: (context, provider, child) => CustomScrollView(
        slivers: [
          SliverAppBar(
            actions: [
              IconButton(
                padding: const EdgeInsets.only(right: 20, top: 10),
                onPressed: () {
                  Get.to(const NotificationPage(),
                      transition: Transition.upToDown);
                },
                icon: Badge.count(
                  count: provider.numberOfNewNotification(),
                  child: const Icon(
                    CupertinoIcons.bell,
                    size: 32,
                    shadows: [
                      Shadow(
                        color: Colors.black12,
                      )
                    ],
                  ),
                ),
              ),
            ],
            backgroundColor: Colors.transparent,
            expandedHeight: 300,
            flexibleSpace: FlexibleSpaceBar(
              background: ClipPath(
                clipper: RoundedClipper(),
                child: Container(
                  width: double.infinity,
                  height: 300.0,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.orange,
                        Colors.orange.withOpacity(.5),
                      ],
                      end: Alignment.topCenter,
                      begin: Alignment.bottomCenter,
                    ),
                  ),
                  child: Center(
                    child: Image.asset(
                      "asset/image/logo.png",
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.to(() => const ParkingAdsMap(),
                              transition: Transition.leftToRightWithFade);
                        },
                        child: FeatureItemView(
                          featureData: featureDemoData[0],
                          index: 0,
                        ),
                      ),
                      InkWell(
                          onTap: () {
                            Get.to(() => const ParkingAdsInCalendar(),
                                transition: Transition.leftToRightWithFade);
                          },
                          child: FeatureItemView(
                            featureData: featureDemoData[1],
                            index: 1,
                          )),
                      InkWell(
                        onTap: () {
                          Get.to(() => const SearchParking(),
                              transition: Transition.leftToRightWithFade);
                        },
                        child: FeatureItemView(
                          featureData: featureDemoData[2],
                          index: 2,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.to(() => const AllGaragesPage(),
                              transition: Transition.leftToRightWithFade);
                        },
                        child: FeatureItemView(
                          featureData: featureDemoData[3],
                          index: 3,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(() => const AboutPage(),
                              transition: Transition.leftToRightWithFade);
                        },
                        child: FeatureItemView(
                          featureData: featureDemoData[4],
                          index: 4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.only(left: 18.0, top: 10, bottom: 10),
                  child: TextAnimator(
                    "Top Parking Ads :",
                    atRestEffect:
                        WidgetRestingEffects.pulse(effectStrength: 0.6),
                    incomingEffect:
                        WidgetTransitionEffects.incomingSlideInFromTop(
                            blur: const Offset(0, 20), scale: 2),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  height: 180,
                  width: MediaQuery.of(context).size.width,
                  child: CarouselSlider(
                    items: provider.parkingList.map((parking) {
                      return InkWell(
                        onTap: () {
                          Get.to(ViewParkingAdsPage(parkingModel: parking),
                              transition: Transition.leftToRight);
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
                                      borderRadius: BorderRadius.circular(20),
                                      child: CachedNetworkImage(
                                        width: Get.width * .4,
                                        fit: BoxFit.cover,
                                        imageUrl: parking.parkImageList[0],
                                        placeholder: (context, url) =>
                                            const CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      ),
                                    ),
                                    Container(
                                      width: Get.width * .4,
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.transparent,
                                            Colors.black.withOpacity(.8)
                                          ],
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                          stops: [0.6, 1], //start of color
                                        ),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.topCenter,
                                      padding: const EdgeInsets.all(8),
                                      width: Get.width * .4,
                                      height: 30,
                                      child: FittedBox(
                                        child: Text(
                                          parking.title,
                                          style: const TextStyle(
                                              color: Colors.orange,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "$takaSymbol${parking.parkingCost}/h",
                                        style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.green,
                                        ),
                                      ),
                                      Text("Slot : ${parking.capacity}"),
                                      FutureBuilder(
                                        future:
                                            DbHelper.getAllActiveRatingByIdInfo(
                                                parking.parkId),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            final allParkingRating =
                                                List.generate(
                                                    snapshot.data!.docs.length,
                                                    (index) =>
                                                        ParkingRatingModel
                                                            .fromMap(snapshot
                                                                .data!
                                                                .docs[index]
                                                                .data()));
                                            final parkingRating =
                                                allParkingRating
                                                    .where((element) =>
                                                        element.adminAccept)
                                                    .toList();
                                            double rating = 0.0;
                                            for (ParkingRatingModel ratingModel
                                                in parkingRating) {
                                              rating +=
                                                  num.parse(ratingModel.rating);
                                            }
                                            return Text(
                                                "Rating : ${(rating / parkingRating.length).toStringAsFixed(2)}");
                                          }
                                          return Text("Loading");
                                        },
                                      ),
                                      const SizedBox(height: 10),
                                      Container(
                                        alignment: Alignment.center,
                                        height: 35,
                                        width: 62,
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: CupertinoColors.activeGreen,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: const FittedBox(
                                          child: Text(
                                            "Book Now",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
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
                      );
                    }).toList(),
                    options: CarouselOptions(
                        autoPlayCurve: Curves.fastOutSlowIn,
                        scrollPhysics: const BouncingScrollPhysics(),
                        reverse: false,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 3),
                        autoPlayAnimationDuration:
                            const Duration(milliseconds: 800)),
                  ),
                ),
                const SizedBox(
                  height: 300,
                )
              ],
            )
          ]))
        ],
      ),
    );
  }
}
