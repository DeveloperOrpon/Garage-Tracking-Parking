import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colorize_text_avatar/colorize_text_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:parking_koi/pages/chat_page.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../database/dbhelper.dart';
import '../model/admin_model.dart';
import '../model/user_model.dart';
import '../provider/adminProvider.dart';
import '../provider/mapProvider.dart';
import '../utils/const.dart';

class ViewUserProfile extends StatefulWidget {
  final UserModel userModel;

  const ViewUserProfile({Key? key, required this.userModel}) : super(key: key);

  @override
  State<ViewUserProfile> createState() => _ViewUserProfileState();
}

class _ViewUserProfileState extends State<ViewUserProfile> {
  int? _slidingValue;
  bool showBalance = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userModel.name ?? "Name Not Set Yet"),
      ),
      body: Consumer<AdminProvider>(
        builder: (context, adminProvider, child) => ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.redAccent, Colors.orange],
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                  stops: [0.5, 0.9],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      InkWell(
                        onTap: () async {
                          await launchUrl(
                              Uri.parse('tel:${widget.userModel.phoneNumber}'));
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.red.shade300,
                          minRadius: 35.0,
                          child: const Icon(
                            Icons.call,
                            size: 30.0,
                          ),
                        ),
                      ),
                      widget.userModel.profileUrl != null
                          ? CircleAvatar(
                              backgroundColor: Colors.white70,
                              minRadius: 60.0,
                              child: CircleAvatar(
                                radius: 50.0,
                                backgroundImage:
                                    NetworkImage(widget.userModel.profileUrl!),
                              ),
                            )
                          : TextAvatar(
                              size: 90,
                              backgroundColor: Colors.white,
                              textColor: Colors.white,
                              fontSize: 14,
                              upperCase: true,
                              numberLetters: 1,
                              shape: Shape.Circular,
                              text: widget.userModel.name,
                            ),
                      InkWell(
                        onTap: () {
                          Get.to(ChatPage(senderUseModel: widget.userModel),
                              transition: Transition.leftToRightWithFade);
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.red.shade300,
                          minRadius: 35.0,
                          child: const Icon(
                            Icons.message,
                            size: 30.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.userModel.name ?? "Name Not Set Yet",
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    widget.userModel.phoneNumber,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CupertinoSlidingSegmentedControl(
                backgroundColor: Colors.grey.shade200,
                thumbColor: Colors.red,
                groupValue: _slidingValue,
                children: {
                  0: Container(
                    padding: const EdgeInsets.only(
                        left: 20, top: 10, right: 20, bottom: 10),
                    child: Text(
                      "Parking Booked",
                      style: TextStyle(
                          color:
                              _slidingValue == 0 ? Colors.white : Colors.black,
                          fontSize: 16),
                    ),
                  ),
                  1: Container(
                    padding: const EdgeInsets.only(
                        left: 20, top: 10, right: 20, bottom: 10),
                    child: Text(
                      "Parking Ads",
                      style: TextStyle(
                          color:
                              _slidingValue == 1 ? Colors.white : Colors.black,
                          fontSize: 16),
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
            if (_slidingValue == null)
              Column(
                children: [
                  ListTile(
                    title: const Text(
                      'Email',
                      style: TextStyle(
                        color: Colors.deepOrange,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      widget.userModel.email ?? "Not Set Yet",
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text(
                      'Address',
                      style: TextStyle(
                        color: Colors.deepOrange,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      widget.userModel.location ?? "Not Set Yet",
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text(
                      'Balance',
                      style: TextStyle(
                        color: Colors.deepOrange,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      showBalance
                          ? "${widget.userModel.balance} $takaSymbol"
                          : "***********",
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    trailing: IconButton(
                        onPressed: () {
                          setState(() {
                            showBalance = !showBalance;
                          });
                        },
                        icon: Icon(showBalance
                            ? CupertinoIcons.eye_fill
                            : CupertinoIcons.eye_slash)),
                  ),
                  const Divider(),
                  const ListTile(
                    title: Text(
                      'Transition History:',
                      style: TextStyle(
                        color: Colors.deepOrange,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  adminProvider
                          .getUserTransactionList(widget.userModel.uid)
                          .isEmpty
                      ? const Center(
                          child: Text(
                            "No Data Found",
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: adminProvider
                              .getUserTransactionList(widget.userModel.uid)
                              .map((e) => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTile(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      tileColor: Colors.green.shade200,
                                      title: Text(e.tId),
                                      trailing: Text(
                                        DateTime.fromMillisecondsSinceEpoch(e
                                                .tGenerateTime
                                                .millisecondsSinceEpoch)
                                            .toString(),
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                ],
              ),
            if (_slidingValue == 0)
              Column(
                mainAxisSize: MainAxisSize.min,
                children: adminProvider.getBookingRequestAccept().isNotEmpty
                    ? adminProvider
                        .getBookingRequestAccept()
                        .map((bookingModel) {
                        return Card(
                          color: Colors.grey.shade300,
                          elevation: 4,
                          shadowColor: Colors.orange,
                          child: ListTile(
                            leading: const Icon(
                              Icons.garage,
                              color: Colors.green,
                            ),
                            title: Text(
                              "ID - ${bookingModel.bId}",
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: FutureBuilder(
                              future: DbHelper.doesUserExist(
                                  bookingModel.acceptAdminUId!),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return !snapshot.data!
                                      ? FutureBuilder(
                                          future: FirebaseFirestore.instance
                                              .collection(collectionAdmin)
                                              .doc(bookingModel.acceptAdminUId)
                                              .get(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              final adminModel =
                                                  AdminModel.fromMap(
                                                      snapshot.data!.data()!);
                                              return Text(
                                                "Accept by (Admin) - ${adminModel.name}",
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.red,
                                                ),
                                              );
                                            }
                                            return const SpinKitWave(
                                              color: Colors.orange,
                                              size: 50.0,
                                            );
                                          })
                                      : FutureBuilder(
                                          future: DbHelper.getUserInfoMap(
                                              bookingModel.acceptAdminUId!),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              final userModel =
                                                  UserModel.fromMap(
                                                      snapshot.data!.data()!);
                                              return Text(
                                                "Accept by (Garage Owner) - ${userModel.name}",
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.red,
                                                ),
                                              );
                                            }
                                            return const SpinKitWave(
                                              color: Colors.orange,
                                              size: 50.0,
                                            );
                                          },
                                        );
                                }
                                return const SpinKitWave(
                                  color: Colors.orange,
                                  size: 50.0,
                                );
                              },
                            ),
                            trailing: DateTime.now().millisecondsSinceEpoch >
                                    num.parse(bookingModel.endTime).toInt()
                                ? const Text(
                                    "Time Expire",
                                    style: TextStyle(
                                        color: Colors.orange,
                                        fontWeight: FontWeight.bold),
                                  )
                                : CountdownTimer(
                                    textStyle: const TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold),
                                    controller: CountdownTimerController(
                                      endTime: num.parse(bookingModel.endTime)
                                          .toInt(),
                                      onEnd: () {},
                                    ),
                                    onEnd: () {},
                                    endTime:
                                        num.parse(bookingModel.endTime).toInt(),
                                  ),
                          ),
                        );
                      }).toList()
                    : [
                        Container(
                          alignment: Alignment.center,
                          height: 80,
                          child: const Text(
                            "There Has No Parking Request Accept",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
              ),
            if (_slidingValue == 1)
              Consumer<MapProvider>(
                builder: (context, mapProvider, child) => Column(
                  children: mapProvider
                          .getUserParkingPointById(widget.userModel.uid)
                          .isNotEmpty
                      ? mapProvider
                          .getUserParkingPointById(widget.userModel.uid)
                          .map((parkingModel) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  color: Colors.grey.shade300,
                                  elevation: 8,
                                  shadowColor: Colors.orange,
                                  child: ListTile(
                                    title: Text(parkingModel.title),
                                    subtitle: Text(parkingModel.gId),
                                    trailing: Text(
                                      "${parkingModel.capacity} Car Park",
                                      style: TextStyle(color: Colors.orange),
                                    ),
                                  ),
                                ),
                              ))
                          .toList()
                      : [
                          const Center(
                            child: Text("Do Parking Data"),
                          )
                        ],
                ),
              )
          ],
        ),
      ),
    );
  }
}
