import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:parking_koi/model/money_transsion_model.dart';

import '../database/dbhelper.dart';
import '../model/admin_model.dart';
import '../model/booking_model.dart';
import '../model/parking_model.dart';
import '../model/user_model.dart';
import '../pages/admin/core/models/data.dart';
import '../pages/admin/models/recent_user_model.dart';
import '../services/Auth_service.dart';

enum SampleItem { itemOne }

class AdminProvider extends ChangeNotifier {
  AdminModel? adminModel;
  SampleItem? selectedMenu;
  List<BookingModel> allBookingList = [];
  List<UserModel> allUserList = [];
  List<CalendarData> calendarData = [];
  List<AdminModel> adminList = [];
  List<UserModel> adminUserList = [];
  List<MoneyTransactionModel> transactionModeList = [];

  getAdminInfo() {
    DbHelper.getAdminInfo(AuthService.currentUser!.uid).listen((snapshot) {
      adminModel = AdminModel.fromMap(snapshot.data()!);
      notifyListeners();
    });
  }

  getAllBookedParking() {
    DbHelper.getAllBookedParking().listen((snapshot) {
      log(snapshot.docs.length.toString());
      allBookingList = List.generate(snapshot.docs.length,
          (index) => BookingModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }

  List<BookingModel> getBookingRequest() {
    final list = <BookingModel>[];
    for (BookingModel bookingModel in allBookingList) {
      if (!bookingModel.isAccept) {
        list.add(bookingModel);
      }
    }
    return list;
  }

  List<BookingModel> getBookingRequestAccept() {
    final list = <BookingModel>[];
    for (BookingModel bookingModel in allBookingList) {
      if (bookingModel.isAccept) {
        list.add(bookingModel);
      }
    }
    return list;
  }

  List<BookingModel> myParkedBooked = [];

  getMyParkedBooked() {
    for (BookingModel bookingModel in allBookingList) {
      if (bookingModel.isAccept) {
        DbHelper.getParkingInfoById(bookingModel.parkingPId).then((value) {
          final parkingModel = ParkingModel.fromMap(value.data()!);
          log("Bookings Accepts : ${bookingModel.parkingPId} -${parkingModel.title} ${parkingModel.uId == AuthService.currentUser!.uid}");
          if (parkingModel.uId == AuthService.currentUser!.uid) {
            myParkedBooked.add(bookingModel);
            notifyListeners();
          }
        });
      }
    }
  }

  List<BookingModel> getMyParkingBooked() {
    final list = <BookingModel>[];
    for (BookingModel bookingModel in allBookingList) {
      if (bookingModel.isAccept) {
        list.add(bookingModel);
      }
    }
    return list;
  }

  getAllUser() {
    DbHelper.getAllUser().listen((snapshot) {
      allUserList = List.generate(snapshot.docs.length,
          (index) => UserModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }

  List<BookingModel> getBookingModelByUid(String uId) {
    return allBookingList
        .where((model) => model.userUId == uId && model.isAccept == true)
        .toList();
  }

  addBookingInfoInCalender() {
    calendarData = [];
    for (BookingModel bookingModel in allBookingList) {
      if (bookingModel.isAccept) {
        calendarData.add(CalendarData(
            id: bookingModel.bId,
            userName: bookingModel.bId,
            title: "BOOKING",
            date: DateTime.fromMillisecondsSinceEpoch(
                num.parse(bookingModel.endTime).toInt()),
            duration: bookingModel.duration,
            cost: bookingModel.cost,
            address: "hh"));
      }
    }
  }

  List<RecentUser> recentUserList() {
    var list = <RecentUser>[];
    for (UserModel userModel in allUserList) {
      if (userModel.createTime.toDate().day <= DateTime.now().day + 7) {
        list.add(RecentUser(
            id: userModel.uid,
            name: userModel.name ?? "No Name Set",
            email: userModel.email ?? userModel.phoneNumber,
            createTime: userModel.createTime));
      }
    }
    return list;
  }

  List<UserModel> getRequestGarageOwner() {
    return allUserList
        .where((element) => element.isGarageOwner && !element.accountActive)
        .toList();
  }

  getAllTransactionList() {
    DbHelper.getAllTransactionList().listen((snapshot) {
      transactionModeList = List.generate(
          snapshot.docs.length,
          (index) =>
              MoneyTransactionModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }

  List<MoneyTransactionModel> getUserTransactionList(String uId) {
    List<MoneyTransactionModel> list = [];
    list =
        transactionModeList.where((element) => element.userId == uId).toList();
    return list;
  }

  // admin User List

  adminInList() {
    DbHelper.listOfAdmin().listen((snapshot) {
      adminList = List.generate(snapshot.docs.length,
          (index) => AdminModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }

  userAdminList() async {
    adminUserList = [];
    log("userAdminList call");
    for (AdminModel adminModel in adminList) {
      if (await DbHelper.doesUserExist(adminModel.uId)) {
        var userMap = await DbHelper.getUserInfoMap(adminModel.uId);
        var user = UserModel.fromMap(userMap.data()!);
        adminUserList.add(user);
      }
    }
  }
}
