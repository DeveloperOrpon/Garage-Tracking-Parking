import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:parking_koi/provider/mapProvider.dart';
import 'package:parking_koi/utils/const.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../database/dbhelper.dart';
import '../../model/admin_model.dart';
import '../../model/withdraw_money_model.dart';

class WithDrawMoneyStatus extends StatelessWidget {
  const WithDrawMoneyStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<MapProvider>(
      builder: (context, mapProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("WithDraw Request Status"),
          ),
          body: Column(
            children: [
              Expanded(
                  child: ListView.builder(
                itemCount: mapProvider.getMyWithDrawRequestList().length,
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
                        collapsedBackgroundColor:
                            mapProvider.withDrawList[index].withdrawStatus
                                ? Colors.green.withOpacity(.2)
                                : mapProvider.withDrawList[index].rejectStatus
                                    ? Colors.purpleAccent
                                    : Colors.red.withOpacity(.2),
                        backgroundColor:
                            mapProvider.withDrawList[index].withdrawStatus
                                ? Colors.green.withOpacity(.2)
                                : Colors.red.withOpacity(.2),
                        title: Text(
                          "ID: (${mapProvider.getMyWithDrawRequestList()[index].tId})",
                          style: const TextStyle(fontSize: 14),
                        ),
                        leading: mapProvider
                                .getMyWithDrawRequestList()[index]
                                .withdrawStatus
                            ? const Icon(FontAwesomeIcons.check)
                            : const Icon(
                                Icons.pending_actions,
                                color: Colors.red,
                              ),
                        trailing: Text(
                          "${mapProvider.getMyWithDrawRequestList()[index].withDrawBalance}$takaSymbol",
                          style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                        subtitle: Text(timeago.format(
                            DateTime.fromMillisecondsSinceEpoch(mapProvider
                                .getMyWithDrawRequestList()[index]
                                .withdrawRequestTime
                                .millisecondsSinceEpoch))),
                        expandedCrossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                const ElevatedButton(
                                    onPressed: null,
                                    child: Text("Payment Status")),
                                const SizedBox(width: 20),
                                ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        backgroundColor: mapProvider
                                                .getMyWithDrawRequestList()[
                                                    index]
                                                .withdrawStatus
                                            ? Colors.green
                                            : mapProvider
                                                    .getMyWithDrawRequestList()[
                                                        index]
                                                    .rejectStatus
                                                ? Colors.red
                                                : Colors.grey),
                                    child: Text(mapProvider
                                            .getMyWithDrawRequestList()[index]
                                            .withdrawStatus
                                        ? "Accept"
                                        : mapProvider
                                                .getMyWithDrawRequestList()[
                                                    index]
                                                .rejectStatus
                                            ? "Reject"
                                            : "Pending")),
                              ],
                            ),
                          ),
                          if (mapProvider
                              .getMyWithDrawRequestList()[index]
                              .withdrawStatus)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    elevation: 0,
                                  ),
                                  child:
                                      const Text("Confirmation Information")),
                            ),
                          if (mapProvider
                              .getMyWithDrawRequestList()[index]
                              .rejectStatus)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    elevation: 0,
                                  ),
                                  child: const Text("Reject Reason")),
                            ),
                          if (mapProvider
                                  .getMyWithDrawRequestList()[index]
                                  .withdrawStatus ||
                              mapProvider
                                  .getMyWithDrawRequestList()[index]
                                  .rejectStatus)
                            FutureBuilder(
                              future: DbHelper.getAdminInfoMap(mapProvider
                                  .withDrawList[index].acceptAdminId!),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final admin = AdminModel.fromMap(
                                      snapshot.data!.data()!);
                                  return Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Admin Name: ${admin.name}"),
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
                                  .getMyWithDrawRequestList()[index]
                                  .withdrawStatus ||
                              mapProvider
                                  .getMyWithDrawRequestList()[index]
                                  .rejectStatus)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                    onPressed: () {
                                      _deleteWidthRequest(
                                          mapProvider
                                                  .getMyWithDrawRequestList()[
                                              index],
                                          mapProvider);
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.redAccent),
                                    child: const Text("Delete"))
                              ],
                            ),
                          const SizedBox(height: 10)
                        ],
                      ),
                    ),
                    if (mapProvider
                        .getMyWithDrawRequestList()[index]
                        .withdrawStatus)
                      Positioned(
                        right: 80,
                        top: 10,
                        child: Image.asset(
                          "asset/image/payment_com.png",
                          height: 60,
                          color: Colors.orange,
                        ),
                      ),
                  ],
                ),
              ))
            ],
          ),
        );
      },
    );
  }

  void _deleteWidthRequest(
      WithDrawMoneyModel moneyModel, MapProvider mapProvider) async {
    EasyLoading.show(status: "Loading...");
    int balance = (num.parse(mapProvider.userModel!.balance).toInt() +
        num.parse(moneyModel.withDrawBalance).toInt());
    await DbHelper.deleteWithDrawInfo(moneyModel, balance.toString())
        .then((value) {
      EasyLoading.dismiss();
      Get.snackbar("Information", "Delete Successful",
          duration: const Duration(seconds: 2),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          showProgressIndicator: true);
    }).catchError((onError) {
      EasyLoading.dismiss();
      Get.snackbar("Information", onError.toString(),
          duration: const Duration(seconds: 2),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          showProgressIndicator: true);
    });
  }
}
