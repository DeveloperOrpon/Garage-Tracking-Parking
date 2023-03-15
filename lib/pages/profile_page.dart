import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parking_koi/pages/payment_page.dart';
import 'package:parking_koi/pages/setting_page.dart';
import 'package:provider/provider.dart';
import 'package:widget_circular_animator/widget_circular_animator.dart';

import '../custom_widget/bookingInfoWidget.dart';
import '../database/dbhelper.dart';
import '../model/user_model.dart';
import '../provider/mapProvider.dart';
import '../utils/const.dart';
import '../utils/helper_function.dart';
import 'View_user_profile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _slidingValue = 0;
  @override
  Widget build(BuildContext context) {
    int index = 0;
    return Consumer<MapProvider>(
        builder: (context, provider, child) => CustomScrollView(
              slivers: [
                SliverAppBar(
                  title: const Text(
                    "Profile ",
                    style: TextStyle(color: Colors.white),
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: IconButton(
                          onPressed: () {
                            Get.to(
                                () => ViewUserProfile(
                                      userModel: provider.userModel!,
                                    ),
                                transition: Transition.leftToRightWithFade);
                          },
                          icon: const Icon(
                            Icons.view_comfortable,
                            color: Colors.white,
                            size: 32,
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: IconButton(
                          onPressed: () {
                            Get.to(() => const SettingPage());
                          },
                          icon: const Icon(
                            Icons.settings,
                            color: Colors.white,
                            size: 32,
                          )),
                    ),
                  ],
                ),
                SliverList(
                    delegate: SliverChildListDelegate([
                  const SizedBox(height: 10),
                  profileInfo(),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Valance (Taka)",
                          style: TextStyle(fontSize: 18),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          height: 60,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade300,
                                  offset: Offset(2, 2),
                                  spreadRadius: 2,
                                  blurRadius: 2,
                                )
                              ]),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                provider.userModel!.balance + takaSymbol,
                                style: const TextStyle(
                                    color: Colors.orange,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
                              ),
                              InkWell(
                                onTap: () {
                                  Get.to(() => const PaymentPage());
                                },
                                child: const CircleAvatar(
                                  backgroundColor: Colors.orange,
                                  radius: 15,
                                  child: Icon(
                                    Icons.add,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: const Padding(
                      padding: EdgeInsets.only(left: 15.0, top: 10),
                      child: Text(
                        "My Booking Information",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CupertinoSlidingSegmentedControl(
                      backgroundColor: Colors.white,
                      thumbColor: Colors.orange,
                      groupValue: _slidingValue,
                      children: {
                        0: Container(
                          padding: const EdgeInsets.only(
                              left: 20, top: 10, right: 20, bottom: 10),
                          child: Text(
                            "Confirm",
                            style: TextStyle(
                                color: _slidingValue == 0
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 18),
                          ),
                        ),
                        1: Container(
                          padding: const EdgeInsets.only(
                              left: 20, top: 10, right: 20, bottom: 10),
                          child: Text(
                            "Request",
                            style: TextStyle(
                                color: _slidingValue == 1
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 18),
                          ),
                        ),
                      },
                      onValueChanged: (value) {
                        setState(() {
                          _slidingValue = value!;
                        });
                      },
                    ),
                  ),
                  _slidingValue == 0
                      ? provider.getMyAcceptBookingList().isEmpty
                          ? Column(
                              children: const [
                                Center(
                                  child: Text("No Booking Info"),
                                )
                              ],
                            )
                          : Column(
                              children: provider.getMyAcceptBookingList().map(
                                (e) {
                                  index++;
                                  return AnimationLimiter(
                                    child: AnimationConfiguration.staggeredList(
                                      position: index,
                                      duration:
                                          const Duration(milliseconds: 350),
                                      child: SlideAnimation(
                                        verticalOffset: -150.0,
                                        child: FadeInAnimation(
                                          child: BookingItemWidget(
                                              bookingModel: e,
                                              provider: provider),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ).toList(),
                            )
                      : provider.getMyRequestBookingList().isEmpty
                          ? Column(
                              children: const [
                                Center(
                                  child: Text("No Booking Info"),
                                )
                              ],
                            )
                          : Column(
                              children: provider.getMyRequestBookingList().map(
                                (e) {
                                  index++;
                                  return AnimationLimiter(
                                    child: AnimationConfiguration.staggeredList(
                                      position: index,
                                      duration:
                                          const Duration(milliseconds: 350),
                                      child: SlideAnimation(
                                        verticalOffset: -150.0,
                                        child: FadeInAnimation(
                                          child: BookingItemWidget(
                                              bookingModel: e,
                                              provider: provider),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ).toList(),
                            ),
                ]))
              ],
            ));
  }

  Consumer profileInfo() {
    return Consumer<MapProvider>(
      builder: (context, provider, child) {
        final userInfo = provider.userModel;
        return Container(
          padding: const EdgeInsets.all(20.0),
          decoration:
              BoxDecoration(color: Colors.grey.shade100, boxShadow: const [
            BoxShadow(
              color: Colors.amber,
              blurRadius: 2,
              spreadRadius: 2,
              offset: Offset(5, 6),
            )
          ]),
          child: Row(
            children: [
              Stack(
                children: [
                  WidgetCircularAnimator(
                    outerColor: Colors.orange,
                    singleRing: true,
                    size: 80,
                    child: userInfo!.profileUrl == null
                        ? Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey[200]),
                            child: Icon(
                              Icons.person_outline,
                              color: Colors.deepOrange[200],
                              size: 40,
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: CachedNetworkImage(
                              imageUrl: userInfo.profileUrl!,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: IconButton(
                        onPressed: () {
                          _saveProfilePhoto(provider);
                        },
                        icon: const Icon(
                          Icons.add,
                          color: Colors.grey,
                          size: 40,
                        )),
                  )
                ],
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: Get.width * .5,
                          child: FittedBox(
                            child: Text(
                              "Name : ${userInfo.name ?? "not set yet"}",
                              style: const TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            showTextInputDialog(
                                title: "Update Profile",
                                hind: "Enter Your Name Here",
                                onTap: (value) {
                                  provider.updateProfile(userFieldName, value);
                                });
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.red,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: Get.width * .5,
                          child: FittedBox(
                            child: Text(
                              "Phone : +88${userInfo.phoneNumber}",
                              style: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            showTextInputDialog(
                                title: "Update Profile",
                                hind: "Enter Phone Number with +880",
                                onTap: (value) {
                                  provider.updateProfile(userFieldPhone, value);
                                });
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.red,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: Get.width * .5,
                          child: FittedBox(
                            child: Text(
                              "Email :${userInfo.email}",
                              style: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            showTextInputDialog(
                                title: "Update Email",
                                hind: "Enter Email Address",
                                onTap: (value) {
                                  provider.updateProfile(userFieldEmail, value);
                                });
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.red,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
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
