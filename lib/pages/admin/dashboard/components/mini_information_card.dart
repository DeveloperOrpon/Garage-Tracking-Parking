import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '../../../../database/dbhelper.dart';
import '../../../../map/add_parking_place_map.dart';
import '../../../../provider/mapProvider.dart';
import '../../../../services/Auth_service.dart';
import '../../../add_garage_page.dart';
import '../../core/constants/color_constants.dart';
import '../../models/daily_info_model.dart';
import '../admin_info_add_in_userAccount.dart';
import 'mini_information_widget.dart';

class MiniInformation extends StatelessWidget {
  const MiniInformation({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Consumer<MapProvider>(
      builder: (context, mapProvider, child) => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                      horizontal: defaultPadding * 1.5,
                      vertical: defaultPadding / 2,
                    ),
                  ),
                  onPressed: () async {
                    if (await DbHelper.doesUserExist(
                        AuthService.currentUser!.uid)) {
                      Get.to(const AddGaragePage(),
                          transition: Transition.rightToLeftWithFade);
                    } else {
                      QuickAlert.show(
                        confirmBtnText: "Create An Account",
                        context: context,
                        onConfirmBtnTap: () {
                          Get.back();
                          Get.to(const AdminUserAccountCreate(),
                              transition: Transition.rightToLeftWithFade);
                        },
                        type: QuickAlertType.warning,
                        text: 'You Has Not Any User Account!',
                      );
                    }
                  },
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  label: FittedBox(
                    child: const Text(
                      "Add Garage",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                      horizontal: defaultPadding * 1.5,
                      vertical: defaultPadding / 2,
                    ),
                  ),
                  onPressed: () {
                    if (mapProvider.myActiveGarages.isNotEmpty) {
                      Get.to(const AddParkingPlace(),
                          transition: Transition.rightToLeftWithFade);
                    } else {
                      QuickAlert.show(
                        confirmBtnText: "You Have No Garage!",
                        context: context,
                        onConfirmBtnTap: () {
                          Get.back();
                          Get.to(const AddGaragePage(),
                              transition: Transition.rightToLeftWithFade);
                        },
                        type: QuickAlertType.warning,
                        text: 'Create A Garage',
                      );
                    }
                  },
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  label: FittedBox(
                    child: const Text(
                      "Add Parking",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: defaultPadding),
          InformationCard(
            crossAxisCount: _size.width < 650 ? 2 : 4,
            childAspectRatio: _size.width < 650 ? 1.2 : 1,
          )
        ],
      ),
    );
  }
}

class InformationCard extends StatelessWidget {
  const InformationCard({
    Key? key,
    this.crossAxisCount = 5,
    this.childAspectRatio = 1,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: dailyDatas.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: defaultPadding,
        mainAxisSpacing: defaultPadding,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) =>
          MiniInformationWidget(dailyData: dailyDatas[index]),
    );
  }
}
