import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../pages/add_parking_info.dart';

class AddParkingPlace extends StatefulWidget {
  const AddParkingPlace({Key? key}) : super(key: key);

  @override
  State<AddParkingPlace> createState() => _AddParkingPlaceState();
}

class _AddParkingPlaceState extends State<AddParkingPlace> {
  LocationData? currentLocation;
  final Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> markers = {};
  LatLng selectPosition = const LatLng(0, 0);

  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          currentLocation == null
              ? const Center(
                  child: SpinKitWave(
                    color: Colors.orange,
                    size: 60.0,
                  ),
                )
              : GoogleMap(
                  zoomControlsEnabled: false,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(currentLocation!.latitude!,
                        currentLocation!.longitude!),
                    zoom: 13.5,
                  ),
                  onMapCreated: (mapController) {
                    _controller.complete(mapController);
                  },
                  onCameraMove: (position) {
                    selectPosition = position.target;
                  },
                ),
          Positioned(
            bottom: 30,
            left: 20,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.shade200,
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset: Offset(0, 2),
                      )
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Image.asset(
                      'asset/image/home.png',
                      height: 35,
                      width: 35,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                CupertinoButton.filled(
                  onPressed: () {
                    Get.to(() => const AddParkingInfoPage(),
                        arguments: selectPosition);
                  },
                  child: const Text(
                    "Add Parking Place",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
              child: Center(
            child: Image.asset(
              "asset/image/parking.png",
              width: 40,
              height: 60,
            ),
          ))
        ],
      ),
    );
  }

  void getCurrentLocation() async {
    Location location = Location();
    location.getLocation().then(
      (location) {
        currentLocation = location;
        selectPosition = LatLng(location.latitude!, location.longitude!);
        setState(() {});
      },
    );
    GoogleMapController googleMapController = await _controller.future;
    location.onLocationChanged.listen(
      (newLoc) {
        currentLocation = newLoc;
        setState(() {});
      },
    );
  }
}
