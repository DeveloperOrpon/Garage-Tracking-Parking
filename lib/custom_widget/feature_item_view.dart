import 'package:entry/entry.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

import '../utils/featureData.dart';

class FeatureItemView extends StatelessWidget {
  final FeatureClass featureData;
  final int index;
  const FeatureItemView(
      {Key? key, required this.featureData, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Entry.scale(
      curve: Curves.elasticInOut,
      visible: true,
      duration: const Duration(seconds: 1),
      child: Stack(
        children: [
          _buildCard(
            backgroundColor: Colors.white,
            config: CustomConfig(
              gradients: [
                [Colors.red, Color(0xEEF44336)],
                [Colors.red[800]!, Color(0x77E57373)],
                [Colors.orange, Colors.orangeAccent],
                [Colors.orange, Color(0x55FFEB3B)]
              ],
              durations: [35000, 19440, 10800, 6000],
              heightPercentages: [0.40, 0.43, 0.45, 0.50],
              gradientBegin: Alignment.bottomLeft,
              gradientEnd: Alignment.topRight,
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            width: Get.width * 0.29,
            height: 110,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  featureData.imageUrl,
                  height: 60,
                  width: Get.width * 0.25,
                ),
                const SizedBox(height: 5),
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: TextAnimator(
                      featureData.title,
                      atRestEffect:
                          WidgetRestingEffects.pulse(effectStrength: 0.6),
                      incomingEffect:
                          WidgetTransitionEffects.incomingSlideInFromTop(
                              blur: const Offset(0, 20), scale: 2),
                      style: GoogleFonts.glegoo(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildCard({
    required Config config,
    Color? backgroundColor = Colors.transparent,
    DecorationImage? backgroundImage,
  }) {
    return Container(
      width: Get.width * 0.29,
      height: 110,
      child: Card(
        elevation: 12.0,
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0))),
        child: WaveWidget(
          config: config,
          backgroundColor: backgroundColor,
          backgroundImage: backgroundImage,
          size: Size(double.infinity, double.infinity),
          waveAmplitude: 0,
        ),
      ),
    );
  }
}
