import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

import '../../provider/mapProvider.dart';
import '../admin/dashboard/ui/garage_item_ui.dart';

class ShowMyGarages extends StatelessWidget {
  const ShowMyGarages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text("My Garage Available"),
      ),
      body: Consumer<MapProvider>(
          builder: (context, mapProvider, child) =>
              mapProvider.myActiveGarages.isNotEmpty
                  ? ListView.builder(
                      itemCount: mapProvider.myActiveGarages.length,
                      itemBuilder: (context, index) =>
                          AnimationConfiguration.staggeredList(
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
                              garageModel: mapProvider.myActiveGarages[index],
                              index: index,
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
