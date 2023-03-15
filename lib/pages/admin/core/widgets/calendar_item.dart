import 'package:colorize_text_avatar/colorize_text_avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../database/dbhelper.dart';
import '../../../../model/booking_model.dart';
import '../../../../utils/const.dart';
import '../../../booking_confirm_page.dart';
import '../constants/color_constants.dart';
import '../models/data.dart';
import '../utils/colorful_tag.dart';

class CalendarItem extends StatelessWidget {
  final CalendarData calendarItemData;

  const CalendarItem({Key? key, required this.calendarItemData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await DbHelper.getBookedInfoById(calendarItemData.id).then((value) {
          final bookingModel = BookingModel.fromMap(value.data()!);
          Get.to(BookingConfirmPage(
            bookingModel: bookingModel,
          ));
        });
      },
      child: Container(
        padding: const EdgeInsets.all(4),
        margin: EdgeInsets.all(3),
        decoration: BoxDecoration(
            color: Colors.green, borderRadius: BorderRadius.circular(15)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextAvatar(
                  text: calendarItemData.title,
                  size: 50,
                  backgroundColor: Colors.white,
                  textColor: Colors.white,
                  fontSize: 14,
                  upperCase: true,
                  numberLetters: 1,
                  shape: Shape.Rectangle,
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "ID-: ${calendarItemData.userName}",
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        border: Border.all(
                          color: getRoleColor(calendarItemData.cost),
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(4.0),
                        ),
                      ),
                      child: Text(
                        "${calendarItemData.cost}$takaSymbol",
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(fontSize: 12),
                      ),
                    )
                  ],
                )
              ],
            ),
            _Date(date: calendarItemData.getDate())
          ],
        ),
      ),
    );
  }
}

class _Date extends StatelessWidget {
  final String date;

  const _Date({Key? key, required this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: greenColor.withOpacity(0.5),
        ),
      ),
      child: Text(
        "End On :$date",
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}
