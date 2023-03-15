import 'package:cached_network_image/cached_network_image.dart';
import 'package:colorize_text_avatar/colorize_text_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marquee/marquee.dart';
import 'package:parking_koi/pages/garage/parking_request_garage.dart';
import 'package:parking_koi/pages/garage/parking_review_comment_request.dart';
import 'package:parking_koi/pages/garage/show_messages.dart';
import 'package:parking_koi/pages/garage/show_my_garages.dart';
import 'package:parking_koi/pages/garage/show_my_parking_Booked.dart';
import 'package:parking_koi/pages/garage/show_my_parking_ads.dart';
import 'package:parking_koi/pages/garage/update_garage_user_profile.dart';
import 'package:parking_koi/pages/garage/withdraw_money_page.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../../database/dbhelper.dart';
import '../../map/add_parking_place_map.dart';
import '../../model/user_model.dart';
import '../../provider/adminProvider.dart';
import '../../provider/mapProvider.dart';
import '../../services/Auth_service.dart';
import '../../utils/helper_function.dart';
import '../add_garage_page.dart';
import '../admin/core/constants/color_constants.dart';
import '../admin/dashboard/admin_info_add_in_userAccount.dart';
import '../admin/dashboard/components/mini_information_widget.dart';
import '../chat_page.dart';
import '../redirect_page.dart';

class GarageUserDashBoardPage extends StatefulWidget {
  const GarageUserDashBoardPage({Key? key}) : super(key: key);

  @override
  State<GarageUserDashBoardPage> createState() =>
      _GarageUserDashBoardPageState();
}

class _GarageUserDashBoardPageState extends State<GarageUserDashBoardPage> {
  bool isGarageOwner = false;

  @override
  void didChangeDependencies() async {
    isGarageOwner = await getGarageOwnerStatus();
    if (isGarageOwner) {
      final adminProvider = Provider.of<AdminProvider>(context, listen: false);
      var mapProvider = Provider.of<MapProvider>(context, listen: false);
      mapProvider.getAllParkingPoint();
      mapProvider.getMyParkingPoint();
      mapProvider.getActiveParkingPoint();
      mapProvider.getUnActiveParkingPoint();
      mapProvider.getAllGarageInfo();
      mapProvider.getMyGarageInfo();
      mapProvider.getAllBookedParking();
      mapProvider.getAvailableLocation();
      mapProvider.getActiveParkingPoint();
      adminProvider.getAllBookedParking();
      adminProvider.getAllUser();
      adminProvider.getAllTransactionList();
      mapProvider.getRatingRequest();
      mapProvider.getUserMessages();
      adminProvider.adminInList();
      adminProvider.userAdminList();
      mapProvider.getAllWithDrawRequestList();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Consumer<MapProvider>(
      builder: (context, mapProvider, child) {
        if (mapProvider.userModel != null) {
          return Scaffold(
              floatingActionButton: isGarageOwner
                  ? FloatingActionButton.extended(
                      onPressed: () {
                        _contractAdmin();
                      },
                      label: Row(
                        children: const [
                          Icon(
                            Icons.emergency,
                            color: Colors.white,
                          ),
                          Text(
                            "Message Admin",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    )
                  : null,
              appBar: AppBar(
                title: const Text("Garage DashBoard"),
                actions: [
                  if (isGarageOwner)
                    Container(
                      margin: const EdgeInsets.all(5),
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: IconButton(
                          onPressed: () {
                            Get.to(const GarageOwnerMessagePage(),
                                transition: Transition.leftToRightWithFade);
                          },
                          icon: const Icon(
                            Icons.message_outlined,
                            color: Colors.white,
                          )),
                    ),
                  if (isGarageOwner)
                    Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.all(5),
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: IconButton(
                          onPressed: () {
                            EasyLoading.show(status: "LogOut Please Wait");
                            AuthService.logout().then((value) {
                              setGarageOwnerStatus(false);
                              EasyLoading.dismiss();
                              Get.offAll(const RedirectPage(),
                                  transition: Transition.fade);
                            });
                          },
                          icon: const Icon(
                            Icons.login_rounded,
                            color: Colors.white,
                          )),
                    )
                ],
              ),
              body: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: EdgeInsets.only(top: 10),
                        alignment: Alignment.topCenter,
                        height: 120,
                        width: Get.width,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(15),
                              bottomLeft: Radius.circular(15),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.orange.shade200,
                                offset: Offset(2, 2),
                                spreadRadius: 5,
                                blurRadius: 5,
                              )
                            ]),
                        child: ListTile(
                          leading: Stack(
                            children: [
                              mapProvider.userModel!.profileUrl != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(40),
                                      child: CachedNetworkImage(
                                        width: 60,
                                        height: 80,
                                        fit: BoxFit.cover,
                                        imageUrl:
                                            mapProvider.userModel!.profileUrl!,
                                        placeholder: (context, url) =>
                                            const CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                    )
                                  : const CircleAvatar(radius: 40),
                              Positioned(
                                left: 0,
                                right: 0,
                                top: 0,
                                bottom: 0,
                                child: IconButton(
                                    onPressed: () {
                                      _saveProfilePhoto(mapProvider);
                                    },
                                    icon: const Icon(
                                      Icons.add,
                                      color: Colors.red,
                                      size: 40,
                                    )),
                              )
                            ],
                          ),
                          title: Text(
                              "${mapProvider.userModel!.name!} (${mapProvider.userModel!.accountActive ? "Active" : "InActive"})"),
                          subtitle: Text(mapProvider.userModel!.location!),
                          trailing: Text(
                            mapProvider.userModel!.balance.toString(),
                            style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: TextButton(
                          onPressed: () {
                            Get.to(
                                UpdateGarageOwnerProfile(
                                    userModel: mapProvider.userModel!),
                                transition: Transition.leftToRightWithFade);
                          },
                          child: const Text(
                            "Edit",
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: TextButton(
                          onPressed: () {
                            Get.to(
                                UpdateGarageOwnerProfile(
                                    userModel: mapProvider.userModel!),
                                transition: Transition.leftToRightWithFade);
                          },
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(elevation: 0),
                            onPressed: () {
                              Get.to(const WithDrawMoneyPage(),
                                  transition: Transition.leftToRightWithFade);
                            },
                            icon: const Icon(
                              FontAwesomeIcons.dollar,
                              color: Colors.white,
                            ),
                            label: const Text(
                              "Withdraw Money",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (mapProvider.userModel!.nIdGarageOwnerUrl == null &&
                      isGarageOwner)
                    Container(
                      alignment: Alignment.center,
                      width: Get.width,
                      height: 35,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Marquee(
                        text: "Please Complete Your Garage Information",
                        scrollAxis: Axis.horizontal,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        blankSpace: 20.0,
                        velocity: 100.0,
                        pauseAfterRound: Duration(seconds: 0),
                        showFadingOnlyWhenScrolling: true,
                        fadingEdgeStartFraction: 0.1,
                        fadingEdgeEndFraction: 0.1,
                        numberOfRounds: 10000,
                        startPadding: 10.0,
                        accelerationDuration: const Duration(seconds: 1),
                        accelerationCurve: Curves.linear,
                        decelerationDuration: const Duration(milliseconds: 500),
                        decelerationCurve: Curves.easeOut,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  if (mapProvider.userModel!.nIdGarageOwnerUrl == null &&
                      isGarageOwner)
                    Consumer<MapProvider>(
                      builder: (context, mapProvider, child) =>
                          OutlinedButton.icon(
                        onPressed: () {
                          _uploadNIdImage(mapProvider);
                        },
                        label: const Text("Upload Your NID Image"),
                        icon: Icon(FontAwesomeIcons.creditCard),
                      ),
                    ),
                  Expanded(
                    child: IgnorePointer(
                      ignoring: !mapProvider.userModel!.accountActive,
                      child: ListView(
                        children: [
                          if (isGarageOwner)
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton.icon(
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: defaultPadding * 1.5,
                                        vertical: defaultPadding / 2,
                                      ),
                                    ),
                                    onPressed: () async {
                                      if (await DbHelper.doesUserExist(
                                          AuthService.currentUser!.uid)) {
                                        Get.to(const AddGaragePage(),
                                            transition:
                                                Transition.rightToLeftWithFade);
                                      } else {
                                        QuickAlert.show(
                                          confirmBtnText: "Create An Account",
                                          context: context,
                                          onConfirmBtnTap: () {
                                            Get.back();
                                            Get.to(
                                                const AdminUserAccountCreate(),
                                                transition: Transition
                                                    .rightToLeftWithFade);
                                          },
                                          type: QuickAlertType.warning,
                                          text: 'You Has Not Any User Account!',
                                        );
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                    label: const Text(
                                      "Add Garage",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  ElevatedButton.icon(
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: defaultPadding * 1.5,
                                        vertical: defaultPadding / 2,
                                      ),
                                    ),
                                    onPressed: () {
                                      if (mapProvider
                                          .myActiveGarages.isNotEmpty) {
                                        Get.to(const AddParkingPlace(),
                                            transition:
                                                Transition.rightToLeftWithFade);
                                      } else {
                                        QuickAlert.show(
                                          confirmBtnText: "You Have No Garage!",
                                          context: context,
                                          onConfirmBtnTap: () {
                                            Get.back();
                                            Get.to(const AddGaragePage(),
                                                transition: Transition
                                                    .rightToLeftWithFade);
                                          },
                                          type: QuickAlertType.warning,
                                          text: 'Create A Garage',
                                        );
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                    label: const Text(
                                      "Add Parking",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: listGarageItems.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisSpacing: 15,
                                mainAxisSpacing: 15,
                                crossAxisCount: _size.width < 650 ? 2 : 4,
                                childAspectRatio: _size.width < 650 ? 1.2 : 1,
                              ),
                              itemBuilder: (context, index) => InkWell(
                                onTap: () {
                                  if (index == 2) {
                                    Get.to(const ShowMyGarages(),
                                        transition:
                                            Transition.rightToLeftWithFade);
                                  }
                                  if (index == 1) {
                                    Get.to(const ShowMyParkingBooked(),
                                        transition:
                                            Transition.rightToLeftWithFade);
                                  }
                                  if (index == 0) {
                                    Get.to(const ShowMyParkingAds(),
                                        transition:
                                            Transition.rightToLeftWithFade);
                                  }
                                  if (index == 4) {
                                    Get.to(const GarageOwnerParkingRequest(),
                                        transition:
                                            Transition.rightToLeftWithFade);
                                  }
                                  if (index == 3) {
                                    Get.to(const ParkingReviewCommentRequest(),
                                        transition:
                                            Transition.rightToLeftWithFade);
                                  }
                                },
                                child: _garageCard(listGarageItems[index],
                                    context, mapProvider, index),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ));
        }
        return const SpinKitSquareCircle(
          color: Colors.orangeAccent,
          size: 50.0,
        );
      },
    );
  }

  Container _garageCard(GarageDashBordItemClass item, BuildContext context,
      MapProvider mapProvider, int index) {
    return Container(
      padding: const EdgeInsets.all(15),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(15 * 0.75),
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: item.color.withOpacity(0.1),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Icon(
                  item.leadingIcon,
                  color: item.color,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  item.title,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          ProgressLine(
            color: item.color,
            percentage: 100,
          ),
          Consumer<AdminProvider>(
            builder: (context, adminProvider, child) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  index == 2
                      ? mapProvider.myActiveGarages.length.toString()
                      : index == 1
                          ? adminProvider.myParkedBooked.length.toString()
                          : index == 0
                              ? mapProvider.myParkingList.length.toString()
                              : index == 4
                                  ? mapProvider
                                      .getMyParkingBookingRequestList()
                                      .length
                                      .toString()
                                  : mapProvider
                                      .getMyParkingRatingRequest()
                                      .length
                                      .toString(),
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: item.color),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> _uploadNIdImage(MapProvider mapProvider) async {
    final ImagePicker _picker = ImagePicker();
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      EasyLoading.show(status: "Uploading Photo..");
      var selectImage = pickedImage.path;
      String downloadUrl = await DbHelper.uploadImage(selectImage);
      await mapProvider.updateProfile(userFieldIsGarageNidUrl, downloadUrl);
      EasyLoading.dismiss();
    }
  }

  void _contractAdmin() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Consumer<AdminProvider>(
        builder: (context, adminProvider, child) {
          return Container(
            height: Get.height / 2,
            width: Get.width,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(30),
                topLeft: Radius.circular(30),
              ),
            ),
            child: ListView(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    CupertinoIcons.chevron_down_circle_fill,
                    color: Colors.orangeAccent,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Text(
                    "Contract Of Admin List :",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 30),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: adminProvider.adminList
                      .map((e) => FutureBuilder(
                            future: DbHelper.doesUserExist(e.uId),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                if (snapshot.data!) {
                                  return FutureBuilder(
                                    future: DbHelper.getUserInfoMap(e.uId),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        final userModel = UserModel.fromMap(
                                            snapshot.data!.data()!);

                                        return Container(
                                          margin: const EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.red,
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: ListTile(
                                            onTap: () {
                                              Get.to(
                                                  ChatPage(
                                                      senderUseModel:
                                                          userModel),
                                                  transition: Transition
                                                      .leftToRightWithFade);
                                            },
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            title: Text(userModel.name ??
                                                userModel.phoneNumber),
                                            subtitle: Text(userModel.email ??
                                                userModel.uid),
                                            leading: userModel.profileUrl !=
                                                    null
                                                ? ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                    child: CachedNetworkImage(
                                                      imageUrl:
                                                          userModel.profileUrl!,
                                                      width: 50,
                                                      height: 50,
                                                      placeholder: (context,
                                                              url) =>
                                                          CircularProgressIndicator(),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Icon(Icons.error),
                                                    ),
                                                  )
                                                : TextAvatar(
                                                    text: userModel.name,
                                                  ),
                                            trailing: const Icon(
                                              Icons.message,
                                              color: Colors.blue,
                                            ),
                                          ),
                                        );
                                      }
                                      return const SpinKitSquareCircle(
                                        color: Colors.orange,
                                        size: 50.0,
                                      );
                                    },
                                  );
                                } else {
                                  return Container();
                                }
                              }
                              return const SpinKitSquareCircle(
                                color: Colors.orange,
                                size: 50.0,
                              );
                            },
                          ))
                      .toList(),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  _saveProfilePhoto(MapProvider provider) async {
    final ImagePicker _picker = ImagePicker();
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      EasyLoading.show(status: "Uploading Photo..");
      var selectImage = pickedImage.path;
      String downloadUrl = await DbHelper.uploadImage(selectImage);
      await provider.updateProfile(userFieldUProfileUrl, downloadUrl);
      EasyLoading.dismiss();
    }
  }
}

List<GarageDashBordItemClass> listGarageItems = [
  GarageDashBordItemClass(
    Icons.maps_home_work_sharp,
    "My Parking Ads",
    '10',
    '10',
    Colors.orangeAccent,
    '5',
  ),
  GarageDashBordItemClass(
    Icons.bookmark,
    "Parking Booked",
    '10',
    '10',
    Colors.blue,
    '5',
  ),
  GarageDashBordItemClass(
    Icons.garage,
    "Garage Information",
    '10',
    '10',
    Colors.pink,
    '5',
  ),
  GarageDashBordItemClass(
    Icons.reviews,
    "Parking Review",
    '10',
    '10',
    Colors.teal,
    '5',
  ),
  GarageDashBordItemClass(
    Icons.garage_outlined,
    "Parking Request",
    '10',
    '10',
    Colors.purpleAccent,
    '5',
  ),
];

class GarageDashBordItemClass {
  IconData leadingIcon;
  String title;
  String booked;
  String unBooked;
  Color color;
  String batch;

  GarageDashBordItemClass(this.leadingIcon, this.title, this.booked,
      this.unBooked, this.color, this.batch);
}
