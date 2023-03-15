import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entry/entry.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:parking_koi/pages/profile_page.dart';
import 'package:parking_koi/utils/const.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../database/dbhelper.dart';
import '../model/booking_model.dart';
import '../model/garage_model.dart';
import '../model/parking_model.dart';
import '../model/parking_rating_model.dart';
import '../model/user_model.dart';
import '../provider/mapProvider.dart';
import '../services/Auth_service.dart';
import '../utils/helper_function.dart';

class ViewParkingAdsPage extends StatefulWidget {
  final ParkingModel parkingModel;

  const ViewParkingAdsPage({Key? key, required this.parkingModel})
      : super(key: key);

  @override
  State<ViewParkingAdsPage> createState() => _ViewParkingAdsPageState();
}

class _ViewParkingAdsPageState extends State<ViewParkingAdsPage> {
  final commentController = TextEditingController();
  double selectRating = 3.0;
  String? selectVehicleType;
  final controllerCustom = TextEditingController();
  bool onlinePayment = true;
  bool isDailyCustom = false;

  @override
  Future<void> didChangeDependencies() async {
    Provider.of<MapProvider>(context)
        .getRatingInfoByParkingId(widget.parkingModel.parkId);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MapProvider>(
      builder: (context, mapProvider, child) => Scaffold(
        backgroundColor: Color(0xFFE4E5E7),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.white,
              expandedHeight: 160,
              title: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                      child: Text(
                    widget.parkingModel.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  )),
                  FittedBox(
                      child: Text(
                    widget.parkingModel.address,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  )),
                ],
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, right: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      height: 180,
                      width: 100,
                      fit: BoxFit.cover,
                      imageUrl: widget.parkingModel.parkImageList[0],
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                              CircularProgressIndicator(
                                  value: downloadProgress.progress),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                ),
              ],
              flexibleSpace: Container(
                margin: const EdgeInsets.only(top: 65, left: 10, right: 10),
                padding: EdgeInsets.all(15),
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton.icon(
                        onPressed: null,
                        icon: const Icon(
                          Icons.garage,
                          color: Colors.orange,
                        ),
                        label: FittedBox(
                            child: Text(
                                "${widget.parkingModel.capacity}Space Available")),
                      ),
                    ),
                    Expanded(
                      child: TextButton.icon(
                        onPressed: null,
                        icon: const Icon(
                          Icons.navigation,
                          color: Colors.orange,
                        ),
                        label: FittedBox(child: const Text("200m meters away")),
                      ),
                    ),
                  ],
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(60),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          DbHelper.getUserInfo(widget.parkingModel.uId)
                              .listen((event) async {
                            final userModel = UserModel.fromMap(event.data()!);
                            await launchUrl(
                                Uri.parse('tel:${userModel.phoneNumber}'));
                          });
                        },
                        label: const Text(
                          "Call",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        icon: const Icon(Icons.call),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            elevation: 0,
                            minimumSize: const Size.fromHeight(50)),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          String googleUrl =
                              'https://www.google.com/maps/dir/?api=1&destination=${widget.parkingModel.lat},${widget.parkingModel.lon}';
                          if (await canLaunch(googleUrl)) {
                            await launch(googleUrl);
                          } else {
                            throw 'Could not open the map.';
                          }
                        },
                        label: const Text(
                          "Direction",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        icon: const Icon(Icons.directions),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            elevation: 0,
                            minimumSize: const Size.fromHeight(50)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverList(
                delegate: SliverChildListDelegate([
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Details",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Per Hour Price ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "${widget.parkingModel.parkingCost} $takaSymbol",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Address",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.parkingModel.address,
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                    FutureBuilder(
                      future:
                          DbHelper.getGarageInfoById(widget.parkingModel.gId),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final garageModel =
                              GarageModel.fromMap(snapshot.data!.data()!);
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8.0, bottom: 8.0),
                            child: Text(
                              "${garageModel.city},${garageModel.division}",
                              style: const TextStyle(color: Colors.black),
                            ),
                          );
                        }
                        return const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Full Info of address wait..",
                            style: TextStyle(color: Colors.black),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "OPERATION",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RichText(
                        textDirection: TextDirection.rtl,
                        softWrap: true,
                        maxLines: 1,
                        textScaleFactor: 1,
                        text: TextSpan(
                          text: '',
                          style: DefaultTextStyle.of(context).style,
                          children: [
                            TextSpan(
                                text: widget.parkingModel.openTime == "24H"
                                    ? "Open now"
                                    : "Open Time",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green)),
                            TextSpan(
                                text: " - ${widget.parkingModel.openTime}",
                                style: TextStyle()),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        "Select Parking Package",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    Row(
                      children: [
                        parkingPackage(widget.parkingModel, mapProvider),
                        const SizedBox(width: 10),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        "Select Vehicle Type",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: ChipsChoice<dynamic>.single(
                        value: selectVehicleType,
                        onChanged: (val) =>
                            setState(() => selectVehicleType = val),
                        choiceItems: C2Choice.listFrom<dynamic, dynamic>(
                          source: widget.parkingModel.selectVehicleTypeList,
                          value: (i, v) => v,
                          label: (i, v) => v,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
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
                          setState(() {
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
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        "Parking Review And Comment",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.shade200,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          RatingBar.builder(
                            itemSize: 30,
                            initialRating: 3,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              setState(() {
                                selectRating = rating;
                              });
                            },
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: commentController,
                            decoration: InputDecoration(
                                filled: true,
                                hintText: "Type Comment Here!",
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton.icon(
                              onPressed: () {
                                _createRating();
                              },
                              label: Text(
                                "Post Comment",
                                style: TextStyle(color: Colors.white),
                              ),
                              icon: const Icon(
                                Icons.send,
                                color: Colors.white,
                              )),
                        ],
                      ),
                    ),
                    mapProvider.parkingRating.isNotEmpty
                        ? Container(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: mapProvider.parkingRating
                                  .map(
                                    (e) => FutureBuilder(
                                      future: DbHelper.getUserInfoMap(e.userId),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          final userModel = UserModel.fromMap(
                                              snapshot.data!.data()!);
                                          return ListTile(
                                            leading: userModel.profileUrl ==
                                                    null
                                                ? Container(
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color:
                                                            Colors.grey[200]),
                                                    child: Icon(
                                                      Icons.person_outline,
                                                      color: Colors
                                                          .deepOrange[200],
                                                      size: 40,
                                                    ),
                                                  )
                                                : ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            40),
                                                    child: CachedNetworkImage(
                                                      imageUrl:
                                                          userModel.profileUrl!,
                                                      placeholder: (context,
                                                              url) =>
                                                          const CircularProgressIndicator(),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Icon(Icons.error),
                                                    ),
                                                  ),
                                            title: Text("${userModel.name}"),
                                            subtitle: Text(e.comment),
                                            trailing: TextButton.icon(
                                                onPressed: null,
                                                icon: const Icon(
                                                  Icons.star,
                                                  color: Colors.orange,
                                                ),
                                                label: Text(
                                                  e.rating,
                                                  style: const TextStyle(
                                                      color: Colors.orange,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                          );
                                        }
                                        return const SpinKitRotatingCircle(
                                          color: Colors.orange,
                                          size: 50.0,
                                        );
                                      },
                                    ),
                                  )
                                  .toList(),
                            ),
                          )
                        : const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Text(
                              "No Review Or Comment Right Now",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.grey),
                            ),
                          ),
                    SizedBox(height: 300),
                  ],
                ),
              ),
            ]))
          ],
        ),
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        floatingActionButton: FutureBuilder(
          future: getAdminStatus(),
          builder: (context, snapshot) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 20),
                if (snapshot.data == true)
                  Expanded(
                    child: CupertinoButton(
                      color: Colors.redAccent,
                      child: const FittedBox(
                        child: Text(
                          "Delete",
                          style: TextStyle(color: CupertinoColors.white),
                        ),
                      ),
                      onPressed: () {},
                    ),
                  ),
                const SizedBox(width: 10),
                Expanded(
                  child: Consumer<MapProvider>(
                    builder: (context, provider, child) => CupertinoButton(
                      color: Colors.black,
                      child: const FittedBox(
                        child: Text(
                          "Booking Parking",
                          style: TextStyle(color: CupertinoColors.white),
                        ),
                      ),
                      onPressed: () {
                        if (selectVehicleType == null) {
                          Get.snackbar(
                            "Select All Information!",
                            "Please select Vehicle Type",
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
                        _confirmBooking(widget.parkingModel, provider);
                      },
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Expanded parkingPackage(ParkingModel parkingModel, MapProvider mapProvider) {
    return Expanded(
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => StatefulBuilder(builder: (context, state) {
              return Entry.offset(
                visible: true,
                child: AlertDialog(
                  backgroundColor: Colors.orange,
                  title: const Text(
                    "Number Of Hour/Day You Parking",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  icon: const Icon(
                    Icons.garage,
                    color: Colors.white,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: SwitchListTile(
                          value: isDailyCustom,
                          onChanged: (value) {
                            state(() {
                              isDailyCustom = !isDailyCustom;
                            });
                          },
                          title: Text("Input Daily"),
                        ),
                      ),
                      TextField(
                        keyboardType: TextInputType.number,
                        controller: controllerCustom,
                        decoration: InputDecoration(
                          hintText:
                              "Enter Number Of ${isDailyCustom ? "Day" : "Hour"}Parking",
                          hintStyle:
                              const TextStyle(color: Colors.grey, fontSize: 12),
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                              color: Colors.orange,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                              color: Colors.orange,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white),
                      child: const Text(
                        "Ok",
                        style: TextStyle(color: Colors.orange),
                      ),
                    ),
                  ],
                ),
              );
            }),
          );
        },
        child: Container(
          height: 65,
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            border: Border.all(width: 1, color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                "Custom",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "(${controllerCustom.text}${isDailyCustom ? "d" : "h"}) Hour/Day - ${calculateAmount(num.parse(parkingModel.parkingCost), isDailyCustom ? num.parse(controllerCustom.text == '' ? "0" : controllerCustom.text).toInt() * 24 : num.parse(controllerCustom.text == '' ? "0" : controllerCustom.text).toInt(), mapProvider.serviceCost == null ? 0 : num.parse(mapProvider.serviceCost!.commissionParking).toInt())}",
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmBooking(ParkingModel parkingModel, MapProvider provider) {
    String value = controllerCustom.text;
    int finalValue = num.parse(value).toInt();

    var cost = calculateAmount(
        num.parse(parkingModel.parkingCost),
        isDailyCustom ? finalValue * 24 : finalValue,
        provider.serviceCost == null
            ? 0
            : num.parse(provider.serviceCost!.commissionParking).toInt());
    if (num.parse(provider.userModel!.balance) - cost <= 0 && onlinePayment) {
      Get.snackbar(
        "Your Balance is to low!",
        "Please Recharge your account",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        onTap: (snack) {
          Get.back();
          Get.to(() => const ProfilePage());
        },
      );
      return;
    }
    if (controllerCustom.text.isEmpty) {
      Get.snackbar(
        "Information!",
        "Please select Parking Hour",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        onTap: (snack) {
          Get.back();
          Get.to(() => const ProfilePage());
        },
      );
      return;
    }
    log("Pasds");

    final bookingModel = BookingModel(
      selectVehicleType: selectVehicleType!,
      bId: DateTime.now().microsecondsSinceEpoch.toString(),
      parkingPId: parkingModel.parkId,
      userUId: provider.userModel!.uid,
      onlinePayment: onlinePayment,
      duration: isDailyCustom ? (finalValue * 24).toString() : value,
      cost: cost.toString(),
      bookingTime: Timestamp.now(),
    );
    Get.back();
    try {
      provider.bookingParkingPlace(bookingModel, parkingModel);
      Get.snackbar(
        "Your Request Sent",
        "Please Wait for Conformation",
        backgroundColor: Colors.orange,
      );
    } catch (error) {
      Get.snackbar(error.toString(), "message");
    }
  }

  void _createRating() async {
    EasyLoading.show(status: "Wait");
    final ratingModel = ParkingRatingModel(
        ratingId: DateTime.now().millisecondsSinceEpoch.toString(),
        rating: selectRating.toString(),
        comment: commentController.text.toString(),
        userId: AuthService.currentUser!.uid,
        parkingId: widget.parkingModel.parkId,
        ratingTime: Timestamp.now());
    await DbHelper.createRatingInParking(ratingModel).then((value) {
      EasyLoading.dismiss();
      Get.snackbar("Information", "Your Rating Post Wait for Admin Approval",
          duration: const Duration(seconds: 3),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.orange,
          showProgressIndicator: true);
    }).catchError((onError) {
      EasyLoading.dismiss();
      Get.snackbar("Information", "SomeThing Is Error",
          duration: const Duration(seconds: 3),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.orange,
          showProgressIndicator: true);
    });
  }
}
