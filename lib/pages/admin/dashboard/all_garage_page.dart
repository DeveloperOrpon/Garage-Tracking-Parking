import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:parking_koi/pages/admin/dashboard/ui/garage_item_ui.dart';
import 'package:provider/provider.dart';

import '../../../provider/mapProvider.dart';
import '../../fullScreenImage.dart';

class AllGarageShowPage extends StatelessWidget {
  const AllGarageShowPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text("List Of Garage Available"),
      ),
      body: Consumer<MapProvider>(
          builder: (context, mapProvider, child) =>
              mapProvider.getGarageRequestAccept().isNotEmpty
                  ? ListView.builder(
                      itemCount: mapProvider.getGarageRequestAccept().length,
                      itemBuilder: (context, index) => InkWell(
                        onTap: () {
                          Get.to(
                              FullScreenPage(
                                  imageUrl:
                                      mapProvider.garageList[index].coverImage),
                              transition: Transition.zoom);
                        },
                        child: AnimationConfiguration.staggeredList(
                          position: index,
                          delay: const Duration(milliseconds: 100),
                          child: SlideAnimation(
                            duration: const Duration(milliseconds: 2500),
                            curve: Curves.fastLinearToSlowEaseIn,
                            horizontalOffset: 250,
                            child: ScaleAnimation(
                              duration: const Duration(milliseconds: 1500),
                              curve: Curves.fastLinearToSlowEaseIn,
                              child: GarageItemWidget(
                                garageModel:
                                    mapProvider.getGarageRequestAccept()[index],
                                index: index,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : const Center(
                      child: Text(
                        "There Have No Garage Ads Right Now",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )),
    );
  }
}
