import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../database/dbhelper.dart';
import '../../../../model/garage_model.dart';
import '../../../../model/parking_model.dart';
import '../../../../model/user_model.dart';
import '../../../../provider/adminProvider.dart';
import '../../../View_garage_page.dart';
import '../../../View_parkingAds_page.dart';
import '../../../View_user_profile.dart';
import '../../core/constants/color_constants.dart';
import '../../models/all_search_delegate.dart';
import 'calendart_widget.dart';

class Header extends StatelessWidget {
  const Header({
    required this.adminProvider,
    Key? key,
  }) : super(key: key);
  final AdminProvider adminProvider;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hello, ${adminProvider.adminModel!.name} 👋",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    "Welcome to your dashboard",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),
            ),
            DottedBorder(
              color: Colors.orange,
              strokeWidth: 2,
              radius: const Radius.circular(10),
              dashPattern: const [8, 4],
              child: IconButton(
                onPressed: () {
                  Get.to(CalendarWidget(adminProvider: adminProvider));
                },
                icon: const Icon(
                  Icons.calendar_month_rounded,
                  size: 28,
                  color: Colors.orange,
                ),
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: const [
            Expanded(child: SearchField()),
          ],
        )
        //CalendarWidget(
        //                                           adminProvider: adminProvider)
      ],
    );
  }
}

class SearchField extends StatelessWidget {
  const SearchField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 8, right: 8),
      padding: const EdgeInsets.all(8),
      height: 70,
      decoration: BoxDecoration(
        //color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: () {
          _searchBar(context);
        },
        splashColor: Colors.orange,
        child: Row(
          children: [
            const Expanded(
              child: Text(
                "Search Places and Garage",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(defaultPadding * 0.75),
              margin: const EdgeInsets.all(defaultPadding / 2),
              decoration: const BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: SvgPicture.asset(
                "asset/icons/Search.svg",
              ),
            ),
          ],
        ),
      ),
    );
  }

  _searchBar(BuildContext context) {
    showSearch(context: context, delegate: FullSearchDelegate()).then((value) {
      if (value![0].type == "userModel") {
        DbHelper.getUserInfo(value[0].id).listen((snapshot) {
          final userModel = UserModel.fromMap(snapshot.data()!);
          Get.to(ViewUserProfile(userModel: userModel));
        });
      } else if (value[0].type == "parkingModel") {
        DbHelper.getParkingById(value[0].id).listen((snapshot) {
          final parkingModel = ParkingModel.fromMap(snapshot.data()!);
          Get.to(ViewParkingAdsPage(
            parkingModel: parkingModel,
          ));
        });
      } else if (value[0].type == "garageModel") {
        EasyLoading.show(status: "Wait");
        DbHelper.getGarageInfoById(value[0].id).then((value) {
          final garageModel = GarageModel.fromMap(value.data()!);
          EasyLoading.dismiss();
          Get.to(ViewGarageViewPage(
            garageModel: garageModel,
          ));
        });
      }
    });
  }
}
