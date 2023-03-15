import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../provider/mapProvider.dart';
import '../View_parkingAds_page.dart';

class ShowMyParkingAds extends StatelessWidget {
  const ShowMyParkingAds({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("My Parking Ads"),
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
                color: Colors.orange,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                "Ads Request of Parking ${mapProvider.myParkingList.length}",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            mapProvider.getMyParkingPointNotAlive().isNotEmpty
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: mapProvider.getMyParkingPointNotAlive().map((e) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          shape: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          tileColor: Colors.redAccent.shade200,
                          title: Text("${e.title} (${e.parkId})"),
                          subtitle: Text(e.parkingCategoryName),
                          trailing: Text(e.parkingCost),
                        ),
                      );
                    }).toList(),
                  )
                : const Center(
                    child: Text("No Data Found"),
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
              child: const Text(
                "Parking Ads are Alive",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            mapProvider.getMyParkingPointAlive().isNotEmpty
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: mapProvider.getMyParkingPointAlive().map((e) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          onTap: () {
                            Get.to(ViewParkingAdsPage(parkingModel: e),
                                transition: Transition.leftToRightWithFade);
                          },
                          shape: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          tileColor: Colors.green.shade200,
                          title: Text("${e.title} (${e.parkId})"),
                          subtitle: Text(e.parkingCategoryName),
                          trailing: Text(e.parkingCost),
                        ),
                      );
                    }).toList(),
                  )
                : const Center(
                    child: Text("No Data Found"),
                  ),
          ],
        );
      }),
    );
  }
}
