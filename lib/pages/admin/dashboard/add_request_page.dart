import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:parking_koi/pages/admin/dashboard/ui/add_parking_ui.dart';
import 'package:provider/provider.dart';

import '../../../provider/mapProvider.dart';

class AddRequestOfParkingGarage extends StatelessWidget {
  const AddRequestOfParkingGarage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        "Ads Request of Parking & Garage",
        style: TextStyle(fontSize: 16),
      )),
      body: Consumer<MapProvider>(
          builder: (context, provider, child) => provider
                  .unActiveParkingList.isNotEmpty
              ? ListView.builder(
                  itemCount: provider.unActiveParkingList.length,
                  itemBuilder: (context, index) => AnimationLimiter(
                    child: AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 350),
                      child: SlideAnimation(
                        verticalOffset: -150.0,
                        child: FadeInAnimation(
                          child: RequestParkingUi(
                            parkingModel: provider.unActiveParkingList[index],
                            provider: provider,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : const Center(
                  child: Text(
                    "No Ads Request For Parking In Map",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                )),
    );
  }
}
