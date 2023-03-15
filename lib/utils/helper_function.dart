import 'dart:developer' as LOG;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/parking_model.dart';
import 'const.dart';

Future<String?> showTextInputDialog(
    {required String title,
    required String hind,
    required Function onTap}) async {
  final textFieldController = TextEditingController();
  return showDialog(
      context: Get.context!,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: textFieldController,
            decoration: InputDecoration(
                hintText: hind, filled: true, border: InputBorder.none),
          ),
          actions: <Widget>[
            OutlinedButton(
              child: const Text("NO"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () {
                onTap(textFieldController.text);
                Navigator.pop(context, textFieldController.text);
              },
            ),
          ],
        );
      });
}

num calculateAmount(num cost, int package, int discount) {
  if (package == 1) {
    return cost;
  }
  LOG.log("Discount $discount");
  return (cost * package) + ((cost * package) % discount);
}

calculateDistance(lat1, lon1, lat2, lon2) {
  var p = 0.017453292519943295;
  var a = 0.5 -
      cos((lat2 - lat1) * p) / 2 +
      cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
  var distance = 12742 * asin(sqrt(a));
  if (distance > 1) {
    return "${distance.toStringAsFixed(2)} KM";
  } else {
    return "${(distance * 1000).toStringAsFixed(2)} M";
  }
}

//SharedPreferences

Future<bool> setAdminStatus(bool status) async {
  final pref = await SharedPreferences.getInstance();
  return pref.setBool(isAdmin, status);
}

Future<bool> getAdminStatus() async {
  final pref = await SharedPreferences.getInstance();
  return pref.getBool(isAdmin) ?? false;
}

Future<bool> setGarageOwnerStatus(bool status) async {
  final pref = await SharedPreferences.getInstance();
  return pref.setBool(isGarageOwner, status);
}

Future<bool> getGarageOwnerStatus() async {
  final pref = await SharedPreferences.getInstance();
  return pref.getBool(isGarageOwner) ?? false;
}

String calculateNumberOfParkingPlaces(List<ParkingModel> parkingList) {
  num total = 0;
  for (ParkingModel parkingModel in parkingList) {
    total = total + num.parse(parkingModel.capacity);
  }
  return total.toString();
}

double makePercentage({required int total, required int available}) {
  LOG.log("total $total available $available");
  return (available * 100) / total;
}

List shuffle(List array) {
  var random = Random();
  for (var i = array.length - 1; i > 0; i--) {
    var n = random.nextInt(i + 1);
    var temp = array[i];
    array[i] = array[n];
    array[n] = temp;
  }
  return array;
}
