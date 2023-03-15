import 'dart:async';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:parking_koi/pages/chat_page.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/home_controller.dart';
import '../controllers/map_controller.dart';
import '../database/dbhelper.dart';
import '../model/booking_model.dart';
import '../model/parking_model.dart';
import '../model/parking_rating_model.dart';
import '../model/user_model.dart';
import '../pages/View_parkingAds_page.dart';
import '../pages/fullScreenImage.dart';
import '../pages/profile_page.dart';
import '../pages/search_page.dart';
import '../provider/mapProvider.dart';
import '../utils/const.dart';
import '../utils/helper_function.dart';

class ParkingAdsMap extends StatefulWidget {
  const ParkingAdsMap({Key? key}) : super(key: key);

  @override
  State<ParkingAdsMap> createState() => _ParkingAdsMapState();
}

class _ParkingAdsMapState extends State<ParkingAdsMap> {
  LocationData? currentLocation;
  final Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> markers = {};
  final controller = Get.find<HomeController>();
  final mapGetXController = Get.find<MapController>();
  final controllerCustom = TextEditingController();
  int packSelect = 3;
  bool isShowImage = false;
  bool onlinePayment = true;
  ParkingModel? userSelectModel;
  String? selectVehicleType;

  @override
  Widget build(BuildContext context) {
    getCurrentLocation();
    return Scaffold(
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: _currentLocation,
            child: const Icon(
              Icons.my_location,
              size: 30,
              color: CupertinoColors.black,
            )),
      ),
      body: Consumer<MapProvider>(
        builder: (context, provider, child) => Stack(
          children: [
            currentLocation == null || isShowImage
                ? const Center(
                    child: SpinKitWave(
                      color: Colors.orange,
                      size: 60.0,
                    ),
                  )
                : GoogleMap(
                    indoorViewEnabled: true,
                    //trafficEnabled: true,
                    compassEnabled: true,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(currentLocation!.latitude!,
                          currentLocation!.longitude!),
                      zoom: 13.5,
                    ),
                    markers: getMarkers(provider),
                    onMapCreated: (mapController) {
                      _controller.complete(mapController);
                    },
                  ),
            Positioned(
              top: 85,
              child: InkWell(
                onTap: () {
                  Get.to(const SearchParking(),
                      transition: Transition.leftToRightWithFade);
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  padding: const EdgeInsets.all(5),
                  width: MediaQuery.of(context).size.width - 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const IconButton(
                        onPressed: null,
                        icon: Icon(CupertinoIcons.location_fill),
                      ),
                      Text(
                        "Search for parking",
                        style: TextStyle(
                            fontSize: 18, color: Colors.grey.shade500),
                      ),
                      Container(
                        width: 2,
                        height: 20,
                        color: Colors.grey,
                      ),
                      const Icon(Icons.add_road),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 30,
              left: 20,
              child: InkWell(
                onTap: () => Get.back(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.shade200,
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset: const Offset(0, 2),
                      )
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Image.asset(
                    'asset/image/home.png',
                    height: 35,
                    width: 35,
                  ),
                ),
              ),
            ),
            //---image show--------
            if (isShowImage)
              Positioned(
                top: (Get.height / 2) - 100,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            isShowImage = !isShowImage;
                            showModalBottomSheet(
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              )),
                              context: context,
                              builder: (builder) {
                                return Container(
                                  padding: const EdgeInsets.all(15),
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        topRight: Radius.circular(30),
                                      )),
                                  child: _buildBottonNavigationMethod(
                                      userSelectModel!, provider),
                                );
                              },
                            );
                          });
                        },
                        icon: const Icon(
                          Icons.cancel,
                          size: 40,
                          color: Colors.orange,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        alignment: Alignment.center,
                        height: 200,
                        width: Get.width,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: userSelectModel!.parkImageList.length,
                          itemBuilder: (context, index) => InkWell(
                            onTap: () {
                              Get.to(FullScreenPage(
                                imageUrl: userSelectModel!.parkImageList[index],
                              ));
                            },
                            child: Container(
                              margin: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.orange, width: 5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Hero(
                                  tag: userSelectModel!.parkImageList[index],
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        userSelectModel!.parkImageList[index],
                                    height: 200,
                                    width: 200,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  Set<Marker> getMarkers(MapProvider provider) {
    for (ParkingModel parkingModel in provider.parkingList) {
      if (parkingModel.isActive) {
        markers.add(
          Marker(
              markerId: MarkerId(parkingModel.parkId),
              position: LatLng(double.parse(parkingModel.lat),
                  double.parse(parkingModel.lon)),
              infoWindow: InfoWindow(
                title: parkingModel.title,
                snippet: parkingModel.parkingCost + takaSymbol,
              ),
              icon: mapGetXController.parkingBitmap,
              onTap: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  )),
                  context: context,
                  builder: (builder) {
                    return Container(
                      padding: const EdgeInsets.all(15),
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          )),
                      child:
                          _buildBottonNavigationMethod(parkingModel, provider),
                    );
                  },
                );
              }),
        );
      }
    }
    return markers;
  }

  void getCurrentLocation() async {
    Location location = Location();
    location.getLocation().then(
      (location) {
        currentLocation = location;
        setState(() {});
      },
    );
    GoogleMapController googleMapController = await _controller.future;
    location.onLocationChanged.listen(
      (newLoc) {
        currentLocation = newLoc;

        // googleMapController.animateCamera(
        //   CameraUpdate.newCameraPosition(
        //     CameraPosition(
        //       zoom: 13.5,
        //       target: LatLng(
        //         newLoc.latitude!,
        //         newLoc.longitude!,
        //       ),
        //     ),
        //   ),
        // );
        //setState(() {});
      },
    );
  }

  StatefulBuilder _buildBottonNavigationMethod(
      ParkingModel parkingModel, MapProvider provider) {
    return StatefulBuilder(
      builder: (context, state) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 5,
            width: 100,
            decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(10)),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      parkingModel.title,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    TextButton.icon(
                      onPressed: null,
                      icon: const Icon(
                        Icons.location_on_outlined,
                        size: 32,
                        color: Colors.orange,
                      ),
                      label: Text(parkingModel.address,
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton.icon(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.blue.shade300,
                          ),
                          onPressed: null,
                          icon: const Icon(
                            Icons.directions_walk,
                            size: 32,
                            color: Colors.white,
                          ),
                          label: Text(
                              calculateDistance(
                                provider.userPosition.latitude,
                                provider.userPosition.longitude,
                                double.parse(parkingModel.lat),
                                double.parse(parkingModel.lon),
                              ).toString(),
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.white)),
                        ),
                        TextButton.icon(
                          onPressed: null,
                          icon: const Icon(
                            Icons.car_repair_rounded,
                            size: 32,
                            color: Colors.orange,
                          ),
                          label: Text(
                              "${parkingModel.capacity}  (${parkingModel.capacityRemaining})",
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey)),
                        ),
                        TextButton(
                            onPressed: null,
                            child: Text(
                                "$takaSymbol ${parkingModel.parkingCost}",
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.orange)))
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        Navigator.pop(context);
                        userSelectModel = parkingModel;
                        isShowImage = !isShowImage;
                      });
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: CachedNetworkImage(
                        imageUrl: parkingModel.parkImageList[0],
                        height: 80,
                        width: 80,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: BeveledRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            side: BorderSide(
                                width: 1,
                                color: Colors.amber.withOpacity(.5)))),
                    onPressed: null,
                    child: FutureBuilder(
                      future: DbHelper.getAllActiveRatingByIdInfo(
                          parkingModel.parkId),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final allParkingRating = List.generate(
                              snapshot.data!.docs.length,
                              (index) => ParkingRatingModel.fromMap(
                                  snapshot.data!.docs[index].data()));
                          final parkingRating = allParkingRating
                              .where((element) => element.adminAccept)
                              .toList();
                          double rating = 0.0;
                          for (ParkingRatingModel ratingModel
                              in parkingRating) {
                            rating += num.parse(ratingModel.rating);
                          }
                          return Text(
                            "${(rating / parkingRating.length).toStringAsFixed(2)}",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          );
                        }
                        return Text("0.0");
                      },
                    ),
                  )
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const SizedBox(width: 10),
              parkingContract(
                  title: "Call", icon: Icons.call, parkingModel: parkingModel),
              const SizedBox(width: 10),
              parkingContract(
                  title: "Direction",
                  icon: Icons.directions,
                  parkingModel: parkingModel),
              const SizedBox(width: 10),
              parkingContract(
                  title: "About",
                  icon: Icons.info,
                  fill: true,
                  parkingModel: parkingModel),
              const SizedBox(width: 10)
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              const Spacer(),
              ElevatedButton.icon(
                label: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Message/Any Query/Help?",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                icon: const Icon(
                  Icons.message,
                  color: Colors.white,
                ),
                onPressed: () async {
                  // message page
                  EasyLoading.show(status: "Wait");
                  await DbHelper.getUserInfoMap(parkingModel.uId).then((value) {
                    final userModel = UserModel.fromMap(value.data()!);
                    EasyLoading.dismiss();
                    Get.back();
                    Get.to(ChatPage(senderUseModel: userModel),
                        transition: Transition.leftToRightWithFade);
                  }).catchError((onError) {
                    EasyLoading.dismiss();
                  });
                },
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: const [
              Text(
                "Security :",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            alignment: Alignment.center,
            height: 60,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: parkingModel.facilityList.map((e) {
                return Container(
                  margin: const EdgeInsets.all(3),
                  padding: const EdgeInsets.all(12),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(.07),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.7),
                          spreadRadius: 4,
                          blurRadius: 3,
                          offset: Offset(0, 3),
                        )
                      ]),
                  child: Text(
                    e,
                    style: const TextStyle(
                      color: Colors.orange,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: const [
              Text(
                "Parking Time :",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              const SizedBox(width: 5),
              parkingPackage(parkingModel, 1, state, provider),
              const SizedBox(width: 5),
              parkingPackage(parkingModel, 2, state, provider),
              const SizedBox(width: 5),
              parkingPackage(parkingModel, 3, state, provider),
              const SizedBox(width: 5),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () {
                    Get.to(ViewParkingAdsPage(parkingModel: parkingModel),
                        transition: Transition.leftToRightWithFade);
                  },
                  child: const Text("Custom Hour and Day",
                      style: TextStyle(color: Colors.white))),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: const [
              Text(
                "Payment Method :",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    state(() {
                      onlinePayment = true;
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: onlinePayment ? Colors.blue : Colors.white,
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text("Online Payment"),
                  ),
                ),
              ),
              const SizedBox(width: 30),
              Expanded(
                child: InkWell(
                  onTap: () {
                    state(() {
                      onlinePayment = false;
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: onlinePayment ? Colors.white : Colors.blue,
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text("Offline Payment"),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text(
              "Select Vehicle Type",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: ChipsChoice<dynamic>.single(
              value: selectVehicleType,
              onChanged: (val) => state(() => selectVehicleType = val),
              choiceItems: C2Choice.listFrom<dynamic, dynamic>(
                source: parkingModel.selectVehicleTypeList,
                value: (i, v) => v,
                label: (i, v) => v,
              ),
            ),
          ),
          const SizedBox(height: 10),
          CupertinoButton.filled(
            child: Text(
              "Book For ${calculateAmount(num.parse(parkingModel.parkingCost), packSelect == 4 ? num.parse(controllerCustom.text).toInt() : packSelect, provider.serviceCost == null ? 0 : num.parse(provider.serviceCost!.commissionParking).toInt())} $takaSymbol",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              if (selectVehicleType == null) {
                Get.snackbar(
                  "Select All Information!",
                  "Please select VehicleType",
                  snackPosition: SnackPosition.TOP,
                  backgroundColor: Colors.orange,
                  colorText: Colors.white,
                  onTap: (snack) {
                    Get.back();
                    Get.to(() => const ProfilePage());
                  },
                );
                return;
              }
              _confirmBooking(parkingModel, provider, packSelect);
            },
          )
        ],
      ),
    );
  }

  Expanded parkingPackage(ParkingModel parkingModel, int title,
      StateSetter state, MapProvider mapProvider) {
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {});
          state(() {
            packSelect = title;
          });
        },
        child: Container(
          height: 65,
          decoration: BoxDecoration(
            color: title == packSelect ? Colors.blueAccent : Colors.white,
            border: Border.all(width: 1, color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "$title hour",
                style: TextStyle(
                  fontSize: 14,
                  color: title == packSelect ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "${calculateAmount(num.parse(parkingModel.parkingCost), title, mapProvider.serviceCost == null ? 0 : num.parse(mapProvider.serviceCost!.commissionParking).toInt())} $takaSymbol",
                style: TextStyle(
                  fontSize: 14,
                  color: title == packSelect ? Colors.white : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Expanded parkingContract(
      {required String title,
      required IconData icon,
      bool fill = false,
      required ParkingModel parkingModel}) {
    return Expanded(
      child: InkWell(
        onTap: () async {
          if (title == "Call") {
            final data = await DbHelper.getUserInfoMap(parkingModel.uId);
            final userModel = UserModel.fromMap(data.data()!);
            await launchUrl(Uri.parse('tel:${userModel.phoneNumber}'));
          } else if (title == "Direction") {
            String googleUrl =
                'https://www.google.com/maps/dir/?api=1&destination=${parkingModel.lat},${parkingModel.lon}';
            if (await canLaunch(googleUrl)) {
              await launch(googleUrl);
            } else {
              throw 'Could not open the map.';
            }
          } else {
            Get.to(ViewParkingAdsPage(parkingModel: parkingModel),
                transition: Transition.leftToRightWithFade);
          }
        },
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: fill ? Colors.orange : Colors.orange.withOpacity(.2),
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                icon,
                color: fill ? Colors.white : Colors.orange,
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: fill ? Colors.white : Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _currentLocation() async {
    final GoogleMapController controller = await _controller.future;
    LocationData cLocation;
    var location = Location();
    try {
      cLocation = await location.getLocation();
    } on Exception {
      rethrow;
    }

    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(cLocation.latitude!, cLocation.longitude!),
        zoom: 15.5,
      ),
    ));
  }

  void _confirmBooking(
      ParkingModel parkingModel, MapProvider provider, int packSelect) {
    var cost = calculateAmount(
        num.parse(parkingModel.parkingCost),
        packSelect,
        provider.serviceCost == null
            ? 0
            : num.parse(provider.serviceCost!.commissionParking).toInt());
    if (provider.doesAlreadyBookingExit(parkingModel.parkId)) {
      Fluttertoast.showToast(
        msg: "You Are Already Booked This Place",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 18.0,
      );
      return;
    }
    if (num.parse(provider.userModel!.balance) - cost <= 0 && onlinePayment) {
      Get.snackbar(
        "Your Balance is to low!",
        "Please Recharge your account",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        onTap: (snack) {
          Get.back();
          Get.to(() => const ProfilePage());
        },
      );
      return;
    }

    final bookingModel = BookingModel(
      bId: DateTime.now().microsecondsSinceEpoch.toString(),
      parkingPId: parkingModel.parkId,
      selectVehicleType: selectVehicleType!,
      userUId: provider.userModel!.uid,
      duration: packSelect.toString(),
      onlinePayment: onlinePayment,
      cost: calculateAmount(
              num.parse(parkingModel.parkingCost),
              packSelect,
              provider.serviceCost == null
                  ? 0
                  : num.parse(provider.serviceCost!.commissionParking).toInt())
          .toString(),
      bookingTime: Timestamp.now(),
    );

    try {
      provider.bookingParkingPlace(bookingModel, parkingModel);
      Fluttertoast.showToast(
        msg: "Please Wait for Conformation",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 18.0,
      );
    } catch (error) {
      Get.snackbar(error.toString(), "message");
    }
  }
}
