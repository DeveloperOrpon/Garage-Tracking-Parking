import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:parking_koi/model/message_model.dart';
import 'package:parking_koi/services/Auth_service.dart';

import '../database/dbhelper.dart';
import '../model/booking_model.dart';
import '../model/garage_model.dart';
import '../model/notification_model.dart';
import '../model/parking_model.dart';
import '../model/parking_rating_model.dart';
import '../model/user_model.dart';
import '../model/withdraw_money_model.dart';
import '../pages/admin/core/json/divisionjson.dart';
import '../pages/admin/models/city_model.dart';
import '../pages/admin/models/division_model.dart';
import '../pages/admin/models/vat_model.dart';

class MapProvider extends ChangeNotifier {
  UserModel? userModel;
  ServiceCost? serviceCost;
  List<ParkingModel> parkingList = [];
  List<GarageModel> garageList = [];
  List<GarageModel> myActiveGarages = [];
  List<ParkingModel> activeParkingList = [];
  List<ParkingModel> unActiveParkingList = [];
  List<ParkingModel> myParkingList = [];
  List<BookingModel> allBookingList = [];
  List<MessageModel> userMessagesList = [];
  List<NotificationModelOfUser> notificationList = [];
  List<WithDrawMoneyModel> withDrawList = [];

  late Position userPosition;
  late String userAddress;
  int _slidingValue = 0;
  List pagesList = [];

  List<DivisionModel> divisionList = [];
  List<CityModel> cityList = [];
  List<CityModel> selectCityListByDivision = [];

  checkCityAvalable(String dId) {
    selectCityListByDivision = [];
    selectCityListByDivision =
        cityList.where((element) => element.divisionId == dId).toList();
  }

  final homePageController = PageController();
  int _homepageIndex = 0;

  int get homepageIndex => _homepageIndex;

  set homepageIndex(int value) {
    _homepageIndex = value;
    notifyListeners();
  }

  int get slidingValue => _slidingValue;

  set slidingValue(int value) {
    _slidingValue = value;
    notifyListeners();
  }

  getUserInfo() {
    DbHelper.getUserInfo(AuthService.currentUser!.uid).listen((snapshot) {
      userModel = UserModel.fromMap(snapshot.data()!);
      notifyListeners();
    });
  }

  getAllParkingPoint() {
    DbHelper.getAllParkingPoint().listen((snapshot) {
      parkingList = List.generate(snapshot.docs.length,
          (index) => ParkingModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }

  getMyParkingPoint() {
    DbHelper.getAllParkingPoint().listen((snapshot) {
      myParkingList = parkingList
          .where((element) => element.uId == userModel!.uid)
          .toList();
      notifyListeners();
    });
  }

  List<ParkingModel> getMyParkingPointAlive() {
    final list = <ParkingModel>[];
    for (ParkingModel parkingModel in myParkingList) {
      if (parkingModel.isActive) {
        list.add(parkingModel);
      }
    }
    return list;
  }

  List<ParkingModel> getMyParkingPointNotAlive() {
    final list = <ParkingModel>[];
    for (ParkingModel parkingModel in myParkingList) {
      if (!parkingModel.isActive) {
        list.add(parkingModel);
      }
    }
    return list;
  }

  List<ParkingModel> getUserParkingPointById(String uid) {
    return parkingList.where((element) => element.uId == uid).toList();
  }

  getActiveParkingPoint() {
    DbHelper.getAllParkingPoint().listen((snapshot) {
      activeParkingList =
          parkingList.where((element) => element.isActive == true).toList();
      notifyListeners();
    });
  }

  getUnActiveParkingPoint() {
    DbHelper.getAllParkingPoint().listen((snapshot) {
      unActiveParkingList =
          parkingList.where((element) => element.isActive == false).toList();
      notifyListeners();
    });
  }

  Future<void> updateParkingField(
      {required String parkId, required String field, required dynamic value}) {
    return DbHelper.updateParkingField(parkId, {field: value});
  }

  updateProfile(String fieldName, String? value) async {
    EasyLoading.show(status: "Updating.....");
    await DbHelper.updateUserProfileField(
        AuthService.currentUser!.uid, {fieldName: value});
    EasyLoading.dismiss();
  }

  Future<void> deleteParking(String parkId) {
    return DbHelper.deleteParking(parkId);
  }

  ///garage info
  getAllGarageInfo() {
    DbHelper.getAllGarageInfo().listen((snapshot) {
      garageList = List.generate(snapshot.docs.length,
          (index) => GarageModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }

  getMyGarageInfo() {
    DbHelper.getAllGarageInfo().listen((snapshot) {
      myActiveGarages = garageList
          .where((element) =>
              element.ownerUId == AuthService.currentUser!.uid &&
              element.isActive)
          .toList();
      notifyListeners();
    });
  }

  List<GarageModel> getGarageRequest() {
    final list = <GarageModel>[];
    for (GarageModel bookingModel in garageList) {
      if (!bookingModel.isActive) {
        list.add(bookingModel);
      }
    }
    return list;
  }

  List<GarageModel> getGarageRequestAccept() {
    final list = <GarageModel>[];
    for (GarageModel bookingModel in garageList) {
      if (bookingModel.isActive) {
        list.add(bookingModel);
      }
    }
    return list;
  }

  ///get location data like division and city
  getAvailableLocation() {
    divisionList = [];
    cityList = [];
    for (Map map in divisionRes) {
      divisionList.add(DivisionModel.fromJson(map));
    }
    for (Map map in cityRes) {
      cityList.add(CityModel.fromJson(map));
    }
  }

  getAllBookedParking() {
    DbHelper.getAllBookedParking().listen((snapshot) {
      allBookingList = List.generate(snapshot.docs.length,
          (index) => BookingModel.fromMap(snapshot.docs[index].data()));
      allBookingList.sort((a, b) {
        var dateA = a.bookingTime;
        var dateB = b.bookingTime;
        return dateB.compareTo(dateA);
      });
      notifyListeners();
    });
  }

  List<BookingModel> getMyBookingList() {
    return allBookingList
        .where((element) => element.userUId == AuthService.currentUser!.uid)
        .toList();
  }

  List<BookingModel> getMyAcceptBookingList() {
    return allBookingList
        .where((element) =>
            element.userUId == AuthService.currentUser!.uid && element.isAccept)
        .toList();
  }

  List<BookingModel> getMyRequestBookingList() {
    return allBookingList
        .where((element) =>
            element.userUId == AuthService.currentUser!.uid &&
            !element.isAccept)
        .toList();
  }

  bool doesAlreadyBookingExit(String pId) {
    bool isHave = false;
    List<BookingModel> myBooking = allBookingList
        .where((element) =>
            element.userUId == AuthService.currentUser!.uid &&
            !element.isAccept)
        .toList();

    for (BookingModel bookingModel in myBooking) {
      if (bookingModel.parkingPId == pId) {
        isHave = true;
        break;
      }
    }
    return isHave;
  }

  List<BookingModel> getMyParkingBookingRequestList() {
    List<BookingModel> list = [];
    for (BookingModel bookingModel in allBookingList) {
      for (ParkingModel parkingModel in activeParkingList) {
        if (bookingModel.parkingPId == parkingModel.parkId &&
            !bookingModel.isAccept) {
          if (parkingModel.uId == AuthService.currentUser!.uid) {
            list.add(bookingModel);
          }
        }
      }
    }
    return list;
  }

  getAddressFromLatLong() async {
    EasyLoading.show(status: "Location Updating..");
    print("getAddressFromLatLong");

    try {
      List placemarks = await placemarkFromCoordinates(
          userPosition.latitude, userPosition.longitude);
      Placemark place = placemarks[0];
      userAddress = "${place.subAdministrativeArea!},${place.country!}";
      notifyListeners();
      print("addres ${place.subAdministrativeArea}");

      EasyLoading.dismiss();
      updateProfile(userFieldLocation, userAddress);
      updateProfile(userFieldLat, userPosition.latitude.toString());
      updateProfile(userFieldLon, userPosition.longitude.toString());
    } catch (error) {
      EasyLoading.dismiss();
    }
  }

  determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        determinePosition();
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    userPosition = await Geolocator.getCurrentPosition();
    notifyListeners();
  }

  bookingParkingPlace(
      BookingModel bookingModel, ParkingModel parkingModel) async {
    EasyLoading.show(status: "booked.....");
    try {
      await DbHelper.bookingRequestForParking(
          bookingModel, parkingModel, userModel!);
      EasyLoading.dismiss();
      Get.snackbar("Information", "Booking Request Confirm Wait For Review",
          duration: const Duration(seconds: 2),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.orange,
          showProgressIndicator: true);
    } catch (error) {
      rethrow;
    }
  }

  //rating info
  List<ParkingRatingModel> parkingRating = [];

  getRatingInfoByParkingId(String pId) {
    DbHelper.getRatingOfAParking(pId).listen((snapshot) {
      final allParkingRating = List.generate(snapshot.docs.length,
          (index) => ParkingRatingModel.fromMap(snapshot.docs[index].data()));
      parkingRating =
          allParkingRating.where((element) => element.adminAccept).toList();
      notifyListeners();
    });
  }

  List<ParkingRatingModel> allRatingModelList = [];

  getRatingRequest() {
    DbHelper.getRatingRequest().listen((snapshot) {
      allRatingModelList = List.generate(snapshot.docs.length,
          (index) => ParkingRatingModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }

//get my parking comment request
  List<ParkingRatingModel> getMyParkingRatingRequest() {
    List<ParkingRatingModel> list = [];
    for (ParkingRatingModel parkingRatingModel in allRatingModelList) {
      for (ParkingModel parkingModel in activeParkingList) {
        if (parkingModel.parkId == parkingRatingModel.parkingId) {
          if (parkingModel.uId == AuthService.currentUser!.uid) {
            list.add(parkingRatingModel);
          }
        }
      }
    }
    return list;
  }

  //getNotificationList

  getNotifications() {
    DbHelper.getUserNotification(AuthService.currentUser!.uid)
        .listen((snapshot) {
      notificationList = List.generate(
          snapshot.docs.length,
          (index) =>
              NotificationModelOfUser.fromMap(snapshot.docs[index].data()));
      notificationList.sort((a, b) {
        var dateA = a.notificationTime;
        var dateB = b.notificationTime;
        return dateB.compareTo(dateA);
      });
      notifyListeners();
    });
  }

  int numberOfNewNotification() {
    return notificationList
        .where((element) => !element.isShowUser)
        .toList()
        .length;
  }

  getUserMessages() {
    DbHelper.getUserMessages(AuthService.currentUser!.uid).listen((snapshot) {
      userMessagesList = List.generate(snapshot.docs.length,
          (index) => MessageModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }

  List<MessageModel> getUserMessageByUId(String uId) {
    return userMessagesList
        .where((element) => element.revivedId == uId || element.senderId == uId)
        .toList();
  }

  List<String> messageUserList() {
    var seen = <String>{};
    for (MessageModel message in userMessagesList) {
      seen.add(message.revivedId);
      seen.add(message.senderId);
    }
    seen.remove(AuthService.currentUser!.uid);
    return seen.toList();
  }

  getServiceCost() {
    DbHelper.getServiceCost().then((value) {
      serviceCost = ServiceCost.fromMap(value.data()!);
      notifyListeners();
    });
  }

  deleteAllUserMessage(List<MessageModel> messages) async {
    EasyLoading.show(status: "Deleting..");
    for (MessageModel messageModel in messages) {
      await DbHelper.deleteMessage(messageModel, AuthService.currentUser!.uid);
    }
    EasyLoading.dismiss();
  }

  getAllWithDrawRequestList() {
    DbHelper.getAllWithDrawRequest().listen((snapshot) {
      withDrawList = List.generate(snapshot.docs.length,
          (index) => WithDrawMoneyModel.fromMap(snapshot.docs[index].data()));
      withDrawList.sort((a, b) {
        var dateA = a.withdrawRequestTime;
        var dateB = b.withdrawRequestTime;
        return dateB.compareTo(dateA);
      });
      withDrawList.sort((a, b) {
        if (!b.withdrawStatus) {
          return 1;
        }
        return -1;
      });
      notifyListeners();
    });
  }

  List<WithDrawMoneyModel> getMyWithDrawRequestList() {
    List<WithDrawMoneyModel> list = [];
    for (WithDrawMoneyModel moneyModel in withDrawList) {
      if (moneyModel.garageOwnerId == userModel!.uid) {
        list.add(moneyModel);
      }
    }
    return list;
  }
}
