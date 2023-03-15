import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../../model/parking_model.dart';
import '../../../../provider/mapProvider.dart';
import '../../../../utils/const.dart';
import '../../../View_parkingAds_page.dart';
import '../../core/constants/color_constants.dart';
import '../update_parking_places.dart';

class RecentPostInMap extends StatelessWidget {
  const RecentPostInMap({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<MapProvider>(
      builder: (context, mapProvider, child) => Container(
        padding: const EdgeInsets.all(defaultPadding),
        decoration: BoxDecoration(
          color: Colors.green.shade100,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orangeAccent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "Recent Post On Map",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                horizontalMargin: 0,
                columnSpacing: defaultPadding,
                columns: const [
                  DataColumn(
                    label: Text("Name (P/G)"),
                  ),
                  DataColumn(
                    label: Text("Location"),
                  ),
                  DataColumn(
                    label: Text("Rate $takaSymbol"),
                  ),
                  DataColumn(
                    label: Text("Action"),
                  ),
                ],
                rows: List.generate(
                  mapProvider.activeParkingList.length % 10,
                  (index) => recentUserDataRow(
                      mapProvider.activeParkingList[index], context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

DataRow recentUserDataRow(ParkingModel parkingModel, BuildContext context) {
  return DataRow(
    onLongPress: () {
      Get.to(ViewParkingAdsPage(
        parkingModel: parkingModel,
      ));
    },
    cells: [
      DataCell(Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.orangeAccent.withOpacity(.2),
            border: Border.all(color: Colors.orangeAccent),
            borderRadius: const BorderRadius.all(Radius.circular(5.0) //
                ),
          ),
          child: Text(parkingModel.title))),
      DataCell(Text(parkingModel.address)),
      DataCell(Text("${parkingModel.parkingCost} $takaSymbol")),
      DataCell(Row(
        children: [
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.withOpacity(0.5),
            ),
            icon: const Icon(
              Icons.edit,
              size: 14,
            ),
            onPressed: () {
              Get.to(const UpdateParkingPlace(),
                  arguments: parkingModel, transition: Transition.cupertino);
            },
            // Edit
            label: const Text("Edit"),
          ),
          const SizedBox(
            width: 6,
          ),
          const SizedBox(width: 6),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.withOpacity(0.5),
            ),
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                        title: const Center(
                          child: Text("Confirm Deletion"),
                        ),
                        content: Container(
                          color: Colors.grey.shade200,
                          height: 122,
                          child: Column(
                            children: [
                              Text(
                                  textAlign: TextAlign.center,
                                  "Are you sure want to delete \n'${parkingModel.title}'?"),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton.icon(
                                      icon: const Icon(Icons.close, size: 14),
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.grey),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      label: const Text("Cancel")),
                                  const SizedBox(width: 20),
                                  ElevatedButton.icon(
                                      icon: const Icon(
                                        Icons.delete,
                                        size: 14,
                                      ),
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red),
                                      onPressed: () {},
                                      label: const Text("Delete"))
                                ],
                              )
                            ],
                          ),
                        ));
                  });
            },
            // Delete
            label: const Text("Delete"),
          ),
        ],
      ))
    ],
  );
}
