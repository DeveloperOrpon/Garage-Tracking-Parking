import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../model/garage_model.dart';
import '../../../../model/user_model.dart';
import '../../../View_garage_page.dart';

class GarageItemWidget extends StatelessWidget {
  final GarageModel garageModel;
  final int index;

  const GarageItemWidget(
      {Key? key, required this.index, required this.garageModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CachedNetworkImage(
                  imageUrl: garageModel.coverImage,
                  height: Get.height * .18,
                  width: Get.width * .8,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
              Container(
                height: Get.height * .18,
                width: Get.width * .8,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(16),
                    topLeft: Radius.circular(16),
                  ),
                  gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.blueAccent,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [.4, 1]),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        textAlign: TextAlign.center,
                        garageModel.name,
                        style: TextStyle(
                            color: Colors.white.withOpacity(.8),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Icon(
                      Icons.star,
                      color: Colors.orange,
                      size: 22,
                    ),
                    Text(
                      "(${garageModel.rating})",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withOpacity(.8),
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            width: Get.width * .8,
            decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
                border: Border.all(
                  color: Colors.blueAccent,
                )),
            child: ExpansionTile(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
              title: FutureBuilder(
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
                      style: TextStyle(color: Colors.orange, fontSize: 16),
                    );
                  }
                  return const Text("Loading..");
                },
              ),
              subtitle: Text(
                "Address :${garageModel.address},${garageModel.city},${garageModel.division}",
                style: TextStyle(color: Colors.green, fontSize: 12),
              ),
              children: [
                Text(
                  "Additional Information",
                  style: TextStyle(
                    color: Colors.white.withOpacity(.8),
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  color: Colors.white.withOpacity(.8),
                  height: 1,
                  width: Get.width / 2,
                ),
                Text(
                  "Total Space : ${garageModel.totalSpace} (square metre)",
                  style: TextStyle(
                    color: Colors.white.withOpacity(.8),
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Text(
                  "Total Parking Ads : ${garageModel.parkingAdsPIds?.length}",
                  style: TextStyle(
                    color: Colors.white.withOpacity(.8),
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Text(
                  "About: : ${garageModel.additionalInformation}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(.8),
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CupertinoButton(
                    color: Colors.orange,
                    onPressed: () {
                      Get.to(ViewGarageViewPage(garageModel: garageModel),
                          transition: Transition.leftToRightWithFade);
                    },
                    child: const Text(
                      "Details",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
