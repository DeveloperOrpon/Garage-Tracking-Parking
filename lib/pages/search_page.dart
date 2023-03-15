import 'dart:developer';

import 'package:colorize_text_avatar/colorize_text_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../database/dbhelper.dart';
import '../model/garage_model.dart';
import '../model/parking_model.dart';
import '../provider/mapProvider.dart';
import '../utils/const.dart';
import 'View_garage_page.dart';
import 'View_parkingAds_page.dart';
import 'admin/models/searchModel.dart';

class SearchParking extends StatefulWidget {
  const SearchParking({Key? key}) : super(key: key);

  @override
  State<SearchParking> createState() => _SearchParkingState();
}

class _SearchParkingState extends State<SearchParking> {
  List<SearchModel> allSearchList = [];
  List<SearchModel> selectSearchList = [];
  MapProvider? mapProvider;
  final searchController = TextEditingController();

  @override
  void didChangeDependencies() {
    mapProvider = Provider.of<MapProvider>(context, listen: false);
    List<SearchModel> parkingSearchList = List.generate(
        mapProvider!.activeParkingList.length,
        (index) => SearchModel(
            title: mapProvider!.activeParkingList[index].title,
            id: mapProvider!.activeParkingList[index].parkId,
            imageUrl: mapProvider!.activeParkingList[index].parkImageList[0],
            type: "parkingModel"));
    List<SearchModel> garageSearchList = List.generate(
        mapProvider!.getGarageRequestAccept().length,
        (index) => SearchModel(
            title: mapProvider!.getGarageRequestAccept()[index].name,
            id: mapProvider!.getGarageRequestAccept()[index].gId,
            imageUrl: mapProvider!.garageList[index].coverImage,
            type: "garageModel"));

    allSearchList.addAll(parkingSearchList);
    allSearchList.addAll(garageSearchList);
    allSearchList.shuffle();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Parking Places "),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                selectSearchList = allSearchList
                    .where((element) => element.title
                        .toLowerCase()
                        .contains(searchController.text.toLowerCase()))
                    .toList();
                log(selectSearchList.toString());
                setState(() {});
              },
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search Parking & Garage Here",
                hintStyle: const TextStyle(color: Colors.grey),
                suffixIcon: const Icon(
                  Icons.search_rounded,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(
                    color: Colors.orangeAccent,
                  ),
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(
                    color: Colors.orangeAccent,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
              child: selectSearchList.isNotEmpty
                  ? ListView.builder(
                      itemCount: selectSearchList.length,
                      itemBuilder: (context, index) {
                        final item = selectSearchList[index];
                        return InkWell(
                          onTap: () {
                            if (item.type == "parkingModel") {
                              DbHelper.getParkingById(item.id)
                                  .listen((snapshot) {
                                final parkingModel =
                                    ParkingModel.fromMap(snapshot.data()!);
                                Get.to(ViewParkingAdsPage(
                                  parkingModel: parkingModel,
                                ));
                              });
                            } else if (item.type == "garageModel") {
                              EasyLoading.show(status: "Wait");
                              DbHelper.getGarageInfoById(item.id).then((value) {
                                final garageModel =
                                    GarageModel.fromMap(value.data()!);
                                EasyLoading.dismiss();
                                Get.to(ViewGarageViewPage(
                                  garageModel: garageModel,
                                ));
                              });
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: movieListGradient[index % 10],
                            ),
                            child: ListTile(
                              title: Text(item.title),
                              leading: item.imageUrl != null
                                  ? CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        item.imageUrl!,
                                      ),
                                    )
                                  : TextAvatar(
                                      size: 35,
                                      backgroundColor: Colors.white,
                                      textColor: Colors.white,
                                      fontSize: 14,
                                      upperCase: true,
                                      numberLetters: 1,
                                      shape: Shape.Rectangle,
                                      text: item.title,
                                    ),
                              trailing: Text(item.type == "garageModel"
                                  ? "Garage"
                                  : item.type == "userModel"
                                      ? "User"
                                      : "Parking Post"),
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        "Search for Parking & Garages",
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                    ))
        ],
      ),
    );
  }
}
