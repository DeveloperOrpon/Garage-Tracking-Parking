import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import '../../../database/dbhelper.dart';
import '../../../model/admin_model.dart';
import '../../../model/garage_model.dart';
import '../../../model/user_model.dart';
import '../../../provider/mapProvider.dart';
import '../../../services/Auth_service.dart';

class GarageAdsRequestPage extends StatelessWidget {
  const GarageAdsRequestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Garage Ads Request List"),
      ),
      body: Consumer<MapProvider>(builder: (context, mapProvider, child) {
        return ListView(
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.only(
                  left: 40, right: 40, top: 10, bottom: 10),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Text(
                "All the request for Garage ",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: mapProvider.getGarageRequest().isNotEmpty
                  ? mapProvider.getGarageRequest().map((garageModel) {
                      return _requestUI(garageModel);
                    }).toList()
                  : [
                      Container(
                        alignment: Alignment.center,
                        height: 80,
                        child: const Text(
                          "There Has No Parking Request",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
            ),

            //accepts list
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.only(
                  left: 40, right: 40, top: 20, bottom: 10),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                "The request are Accepts List ${mapProvider.getGarageRequestAccept().length}",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: mapProvider.getGarageRequestAccept().isNotEmpty
                  ? mapProvider.getGarageRequestAccept().map((garageModel) {
                      return Card(
                        color: Colors.green.shade100,
                        elevation: 4,
                        shadowColor: Colors.orange,
                        child: ListTile(
                          leading: const Icon(
                            Icons.garage,
                            color: Colors.green,
                          ),
                          title: Text(
                            "ID - ${garageModel.gId}",
                            style: const TextStyle(
                                fontSize: 12,
                                color: Colors.green,
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: FutureBuilder(
                              future: FirebaseFirestore.instance
                                  .collection(collectionAdmin)
                                  .doc(garageModel.acceptAdminUId)
                                  .get(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final adminModel = AdminModel.fromMap(
                                      snapshot.data!.data()!);
                                  return Text(
                                    "Accept by ${adminModel.name}",
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
                              }),
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
          ],
        );
      }),
    );
  }

  Padding _requestUI(GarageModel garageModel) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
          color: Colors.red.shade300,
          elevation: 8,
          shadowColor: Colors.orange,
          child: ExpansionTile(
            title: Text(
              garageModel.name,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Text(
              "${garageModel.address} - ${garageModel.city},${garageModel.division}",
              style: const TextStyle(
                fontSize: 10,
                color: Colors.white,
              ),
            ),
            trailing: Text(
              "${garageModel.totalSpace} ms",
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
            expandedAlignment: Alignment.topLeft,
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            childrenPadding:
                const EdgeInsets.only(left: 13, right: 13, bottom: 8),
            children: [
              const ElevatedButton(
                  onPressed: null, child: Text("Garage Information")),
              Text(
                "Garage ID- ${garageModel.gId}",
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 6),
              FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection(collectionUser)
                    .doc(garageModel.ownerUId)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final userModel = UserModel.fromMap(snapshot.data!.data()!);
                    return Text(
                      userModel.name == null
                          ? "No Name Set"
                          : "Garage Owner Name :${userModel.name!.toUpperCase()}",
                      style: const TextStyle(fontSize: 12),
                    );
                  }
                  return const Text("Loading..");
                },
              ),
              const SizedBox(height: 6),
              Text(
                "About-"
                " ${garageModel.additionalInformation}",
                style: const TextStyle(fontSize: 12),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _acceptRequest(garageModel);
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text(
                      "Accept",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent),
                    child: const Text(
                      "Delete",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              )
            ],
          )),
    );
  }

  void _acceptRequest(GarageModel garageModel) async {
    EasyLoading.show(status: "Wait....");
    await DbHelper.updateGarageInfo(garageModel.gId, {
      garageFieldIsActive: true,
      garageFieldAcceptAdminUId: AuthService.currentUser!.uid,
    }).then((value) {
      EasyLoading.dismiss();
    }).catchError((onError) {
      EasyLoading.dismiss();
      log(onError.toString());
    });
  }
}
