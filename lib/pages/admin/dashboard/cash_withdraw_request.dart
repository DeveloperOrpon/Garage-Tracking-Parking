import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:parking_koi/database/dbhelper.dart';
import 'package:parking_koi/model/admin_model.dart';
import 'package:parking_koi/model/user_model.dart';
import 'package:parking_koi/provider/mapProvider.dart';
import 'package:parking_koi/utils/const.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../model/withdraw_money_model.dart';
import '../../../services/Auth_service.dart';

class CashWithDrawRequest extends StatefulWidget {
  const CashWithDrawRequest({Key? key}) : super(key: key);

  @override
  State<CashWithDrawRequest> createState() => _CashWithDrawRequestState();
}

class _CashWithDrawRequestState extends State<CashWithDrawRequest> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cash WithDraw Request'),
      ),
      body: Consumer<MapProvider>(
        builder: (context, mapProvider, child) {
          return Column(
            children: [
              Expanded(
                child: mapProvider.withDrawList.isNotEmpty
                    ? ListView.builder(
                        itemCount: mapProvider.withDrawList.length,
                        itemBuilder: (context, index) => Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5),
                              margin: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: ExpansionTile(
                                collapsedShape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                tilePadding: const EdgeInsets.all(10),
                                collapsedBackgroundColor: mapProvider
                                        .withDrawList[index].withdrawStatus
                                    ? Colors.green.withOpacity(.2)
                                    : mapProvider
                                            .withDrawList[index].rejectStatus
                                        ? Colors.purpleAccent
                                        : Colors.red.withOpacity(.2),
                                backgroundColor: mapProvider
                                        .withDrawList[index].withdrawStatus
                                    ? Colors.green.withOpacity(.2)
                                    : Colors.red.withOpacity(.2),
                                title: Text(
                                  "ID: (${mapProvider.withDrawList[index].tId})",
                                  style: const TextStyle(fontSize: 14),
                                ),
                                leading: mapProvider
                                        .withDrawList[index].withdrawStatus
                                    ? const Icon(FontAwesomeIcons.check)
                                    : const Icon(
                                        Icons.pending_actions,
                                        color: Colors.red,
                                      ),
                                trailing: (mapProvider
                                        .withDrawList[index].withdrawStatus)
                                    ? const Text("")
                                    : ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            elevation: 0),
                                        onPressed: null,
                                        child: const Text(
                                          "Payment",
                                          style: TextStyle(fontSize: 12),
                                        )),
                                subtitle: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(timeago.format(
                                        DateTime.fromMillisecondsSinceEpoch(
                                            mapProvider
                                                .withDrawList[index]
                                                .withdrawRequestTime
                                                .millisecondsSinceEpoch))),
                                    Text(
                                      "${mapProvider.withDrawList[index].withDrawBalance}$takaSymbol",
                                      style: const TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    )
                                  ],
                                ),
                                expandedCrossAxisAlignment:
                                    CrossAxisAlignment.stretch,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          elevation: 0,
                                        ),
                                        child: const Text("Information owner")),
                                  ),
                                  FutureBuilder(
                                    future: DbHelper.getUserInfoMap(mapProvider
                                        .withDrawList[index].garageOwnerId),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        final user = UserModel.fromMap(
                                            snapshot.data!.data()!);
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  "User Name(Id) : ${user.name ?? user.uid}"),
                                              Text(
                                                  "User Contract : ${user.phoneNumber}"),
                                            ],
                                          ),
                                        );
                                      }
                                      return const SpinKitSquareCircle(
                                        color: Colors.orange,
                                        size: 50.0,
                                      );
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          elevation: 0,
                                        ),
                                        child:
                                            const Text("WithDraw Information")),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        "Payment Method : ${mapProvider.withDrawList[index].paymentMethod}"),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        "Payment Number(A/C) : ${mapProvider.withDrawList[index].paymentNumber}"),
                                  ),
                                  if (!mapProvider
                                      .withDrawList[index].withdrawStatus)
                                    Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: TextField(
                                        controller: controller,
                                        maxLines: 3,
                                        decoration: InputDecoration(
                                            fillColor: Colors.grey.shade200,
                                            filled: true,
                                            border: InputBorder.none,
                                            hintText:
                                                "Enter Any Comment any Information"),
                                      ),
                                    ),
                                  if (!mapProvider
                                          .withDrawList[index].withdrawStatus &&
                                      !mapProvider
                                          .withDrawList[index].rejectStatus)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            _acceptPayment(mapProvider
                                                .withDrawList[index].tId);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                          ),
                                          child: const Text("Payment Done"),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            _rejectPayment(mapProvider
                                                .withDrawList[index].tId);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                          ),
                                          child: const Text(
                                            "Payment Reject",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  if (mapProvider
                                      .withDrawList[index].withdrawStatus)
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ElevatedButton(
                                          onPressed: () {},
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            elevation: 0,
                                          ),
                                          child: const Text(
                                              "Confirmation Information")),
                                    ),
                                  if (mapProvider
                                      .withDrawList[index].withdrawStatus)
                                    FutureBuilder(
                                      future: DbHelper.getAdminInfoMap(
                                          mapProvider.withDrawList[index]
                                              .acceptAdminId!),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          final admin = AdminModel.fromMap(
                                              snapshot.data!.data()!);
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    "Admin Name: ${admin.name}"),
                                                Text(
                                                    "Comment: ${mapProvider.withDrawList[index].comment ?? "No Comment"}"),
                                              ],
                                            ),
                                          );
                                        }
                                        return const SpinKitSquareCircle(
                                          color: Colors.orange,
                                          size: 50.0,
                                        );
                                      },
                                    ),
                                  if (mapProvider
                                      .withDrawList[index].rejectStatus)
                                    const Padding(
                                      padding: EdgeInsets.all(15),
                                      child: ElevatedButton(
                                          onPressed: null,
                                          child: Text("Request Rejected")),
                                    ),
                                  const SizedBox(height: 30)
                                ],
                              ),
                            ),
                            if (mapProvider.withDrawList[index].withdrawStatus)
                              Positioned(
                                right: 20,
                                top: 20,
                                child: Image.asset(
                                  "asset/image/payment_com.png",
                                  height: 60,
                                  color: Colors.orange,
                                ),
                              ),
                          ],
                        ),
                      )
                    : const Center(
                        child: Text("No Withdraw Request"),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _acceptPayment(String tId) async {
    EasyLoading.show(status: "Loading...");
    await DbHelper.updateWithDrawInfo(tId, {
      withDrawFieldWithdrawStatus: true,
      withDrawFieldAcceptAdminId: AuthService.currentUser!.uid,
      withDrawFieldAcceptTime: Timestamp.now(),
      withDrawFieldComment: controller.text,
    }).then((value) {
      controller.text = '';
      EasyLoading.dismiss();
      Get.snackbar("Information", "Complete Withdraw Request",
          duration: const Duration(seconds: 2),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          showProgressIndicator: true);
    }).catchError((onError) {
      controller.text = '';
      EasyLoading.dismiss();
      Get.snackbar("Information", onError.toString(),
          duration: const Duration(seconds: 2),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          showProgressIndicator: true);
    });
  }

  void _rejectPayment(String tId) async {
    EasyLoading.show(status: "Loading...");
    await DbHelper.updateWithDrawInfo(tId, {
      withDrawFieldRejectStatus: true,
      withDrawFieldAcceptAdminId: AuthService.currentUser!.uid,
      withDrawFieldAcceptTime: Timestamp.now(),
      withDrawFieldComment: controller.text,
    }).then((value) {
      controller.text = '';
      EasyLoading.dismiss();
      Get.snackbar("Information", "Complete Withdraw Request",
          duration: const Duration(seconds: 2),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          showProgressIndicator: true);
    }).catchError((onError) {
      controller.text = '';
      EasyLoading.dismiss();
      Get.snackbar("Information", onError.toString(),
          duration: const Duration(seconds: 2),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          showProgressIndicator: true);
    });
  }
}
