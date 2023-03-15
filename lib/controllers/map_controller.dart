import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:marker_icon/marker_icon.dart';

class MapController extends GetxController {
  late BitmapDescriptor parkingBitmap;
  var packSelect = 3.obs;
  @override
  void onInit() {
    mapParkingIcon();
  }

  mapParkingIcon() async {
    parkingBitmap = await MarkerIcon.pictureAssetWithCenterText(
      text: "",
      size: const Size(120, 220),
      assetPath: 'asset/image/parking.png',
      fontSize: 25,
      fontColor: Colors.red,
      fontWeight: FontWeight.bold,
    );
  }
}
