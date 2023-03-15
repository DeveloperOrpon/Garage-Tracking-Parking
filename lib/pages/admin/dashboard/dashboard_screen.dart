import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:parking_koi/pages/admin/dashboard/parking_request_page.dart';
import 'package:parking_koi/pages/admin/dashboard/show_Users_page.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../../../database/dbhelper.dart';
import '../../../provider/adminProvider.dart';
import '../../../provider/mapProvider.dart';
import '../../../services/Auth_service.dart';
import '../../../utils/helper_function.dart';
import '../../garage/garage_user_dashboard.dart';
import '../../garage/show_messages.dart';
import '../../redirect_page.dart';
import '../core/constants/color_constants.dart';
import 'add_request_page.dart';
import 'admin_info_add_in_userAccount.dart';
import 'all_parkingList_page.dart';
import 'components/charts.dart';
import 'components/header.dart';
import 'components/mini_information_card.dart';
import 'components/recent_forums.dart';
import 'components/recent_users copy.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context, listen: false);
    var mapProvider = Provider.of<MapProvider>(context, listen: false);
    adminProvider.getAdminInfo();
    mapProvider.getAllParkingPoint();
    mapProvider.getUserInfo();
    mapProvider.getMyParkingPoint();
    mapProvider.getActiveParkingPoint();
    mapProvider.getUnActiveParkingPoint();
    mapProvider.getAllGarageInfo();
    mapProvider.getMyGarageInfo();
    mapProvider.getAllBookedParking();
    mapProvider.getAvailableLocation();
    adminProvider.getAllBookedParking();
    adminProvider.getAllUser();
    adminProvider.getAllTransactionList();
    adminProvider.addBookingInfoInCalender();
    mapProvider.getUserMessages();
    mapProvider.getAllWithDrawRequestList();
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Consumer<AdminProvider>(
        builder: (context, provider, child) {
          return provider.adminModel == null
              ? const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Scaffold(
                  drawer: _CustomNavigationDrawer(provider, context),
                  floatingActionButton: FloatingActionButton.extended(
                    backgroundColor: Colors.green,
                    onPressed: () {
                      Get.to(const GarageOwnerMessagePage(),
                          transition: Transition.leftToRightWithFade);
                    },
                    label: Row(
                      children: const [
                        Icon(
                          Icons.message_sharp,
                          color: Colors.white,
                        ),
                        Text(
                          "Chat List",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  appBar: AppBar(
                    title: const Text("Dashboard "),
                    actions: [
                      Container(
                        margin: const EdgeInsets.only(left: defaultPadding),
                        padding: const EdgeInsets.symmetric(
                          horizontal: defaultPadding,
                          vertical: defaultPadding / 2,
                        ),
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundImage:
                                  NetworkImage(provider.adminModel!.imageUrl),
                            ),
                            PopupMenuButton<SampleItem>(
                              color: Colors.grey.shade200,
                              icon: const Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.white,
                              ),
                              initialValue: provider.selectedMenu,
                              onSelected: (SampleItem item) {
                                provider.selectedMenu = item;
                              },
                              itemBuilder: (BuildContext context) => [
                                PopupMenuItem<SampleItem>(
                                  value: SampleItem.itemOne,
                                  child: const Text(
                                    'LogOut',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  onTap: () async {
                                    EasyLoading.show(status: "Wait...");

                                    await AuthService.logout().then((value) {
                                      setAdminStatus(false);
                                      EasyLoading.dismiss();
                                      Get.offAll(const RedirectPage());
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  body: SafeArea(
                    child: Scrollbar(
                      thumbVisibility: true,
                      thickness: 8,
                      radius: const Radius.circular(20),
                      child: SingleChildScrollView(
                        child: Container(
                          padding: const EdgeInsets.all(defaultPadding),
                          child: Column(
                            children: [
                              Header(adminProvider: provider),
                              const SizedBox(height: defaultPadding),
                              const Chart(),
                              const MiniInformation(),
                              const SizedBox(height: defaultPadding),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: Column(
                                      children: const [
                                        SizedBox(height: 9),
                                        RecentUsers(),
                                        SizedBox(height: 9),
                                        RecentPostInMap(),
                                        SizedBox(height: 100),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }

  _CustomNavigationDrawer(AdminProvider adminProvider, BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
      child: Container(
        height: Get.height,
        width: Get.width * .6,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Image.asset('asset/image/logo.png'),
            const SizedBox(height: 10),
            const Text("Parking & Garage Tracking",
                style: TextStyle(
                    fontWeight: FontWeight.w600, color: Colors.orange)),
            Container(
              margin: const EdgeInsets.only(top: 10),
              height: 2,
              width: 90,
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            const SizedBox(height: 40),

            //garage Profile
            if (adminProvider.adminModel!.isGarage)
              ListTile(
                onTap: () async {
                  if (await DbHelper.doesUserExist(
                      AuthService.currentUser!.uid)) {
                    Get.to(const GarageUserDashBoardPage(),
                        curve: Curves.bounceInOut,
                        transition: Transition.leftToRight);
                  } else {
                    QuickAlert.show(
                      confirmBtnText: "Create An Account",
                      context: context,
                      onConfirmBtnTap: () {
                        Get.back();
                        Get.to(const AdminUserAccountCreate(),
                            transition: Transition.rightToLeftWithFade);
                      },
                      type: QuickAlertType.warning,
                      text: 'You Has Not Any User Account!',
                    );
                  }
                },
                leading: Container(
                  padding: const EdgeInsets.all(defaultPadding * 0.75),
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xfff5af19).withOpacity(0.1),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: const Icon(
                    Icons.paste_rounded,
                    color: Colors.orange,
                    size: 18,
                  ),
                ),
                title: const Text("Garage Profile"),
              ),

            ListTile(
              onTap: () {
                Get.back();
              },
              leading: Container(
                padding: const EdgeInsets.all(defaultPadding * 0.75),
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: const Color(0xfff5af19).withOpacity(0.1),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: const Icon(
                  Icons.dashboard,
                  color: Colors.orange,
                  size: 18,
                ),
              ),
              title: const Text("Dashboard"),
            ),
            ListTile(
              onTap: () {
                Get.to(const AllParkingShowPage(),
                    curve: Curves.bounceInOut,
                    transition: Transition.leftToRight);
              },
              leading: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: const Color(0xfff5af19).withOpacity(0.1),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: const Icon(
                  Icons.garage_rounded,
                  color: Colors.orange,
                ),
              ),
              title: const Text("All Parking & Garage"),
            ),
            ListTile(
              onTap: () {
                Get.to(const ParkingRequestPage(),
                    curve: Curves.bounceInOut,
                    transition: Transition.leftToRight);
              },
              leading: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: const Color(0xfff5af19).withOpacity(0.1),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: const Icon(
                  Icons.garage_outlined,
                  color: Colors.orange,
                ),
              ),
              title: const Text("P&G Request"),
            ),
            ListTile(
              onTap: () {
                Get.to(const AddRequestOfParkingGarage(),
                    curve: Curves.bounceInOut,
                    transition: Transition.leftToRight);
              },
              leading: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: const Color(0xfff5af19).withOpacity(0.1),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: const Icon(
                  Icons.add_location_alt_rounded,
                  color: Colors.orange,
                ),
              ),
              title: Text("P&G Add Request"),
            ),
            ListTile(
              onTap: () {
                Get.to(const ShowAllUserPage(),
                    curve: Curves.bounceInOut,
                    transition: Transition.leftToRight);
              },
              leading: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: const Color(0xfff5af19).withOpacity(0.1),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: const Icon(
                  Icons.perm_contact_calendar_rounded,
                  color: Colors.orange,
                ),
              ),
              title: const Text("Show All Users"),
            ),
            ListTile(
              leading: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: const Color(0xfff5af19).withOpacity(0.1),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: const Icon(
                  Icons.admin_panel_settings,
                  color: Colors.orange,
                ),
              ),
              title: Text("Admin Info"),
            ),
            Spacer(),
            Text(
              "Version:1.0.0",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            SizedBox(height: 20),
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
}
