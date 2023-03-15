import 'package:colorize_text_avatar/colorize_text_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../database/dbhelper.dart';
import '../../../../model/user_model.dart';
import '../../../../provider/adminProvider.dart';
import '../../../View_user_profile.dart';
import '../../core/constants/color_constants.dart';
import '../../models/recent_user_model.dart';

class RecentUsers extends StatelessWidget {
  const RecentUsers({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminProvider>(
      builder: (context, adminProvider, child) => Container(
        padding: const EdgeInsets.all(defaultPadding),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                "Recent Users List -:",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                horizontalMargin: 0,
                columnSpacing: defaultPadding,
                columns: const [
                  DataColumn(
                    label: Text("Surname"),
                  ),
                  DataColumn(
                    label: Text("E-mail"),
                  ),
                  DataColumn(
                    label: Text("Registration Date"),
                  ),
                  DataColumn(
                    label: Text("Operation"),
                  ),
                ],
                rows: List.generate(
                  adminProvider.recentUserList().length,
                  (index) => recentUserDataRow(
                      adminProvider.recentUserList()[index], context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

DataRow recentUserDataRow(RecentUser userInfo, BuildContext context) {
  return DataRow(
    onLongPress: () {
      EasyLoading.show(status: "Loading..");
      DbHelper.getUserInfo(userInfo.id).listen((event) {
        final userModel = UserModel.fromMap(event.data()!);
        EasyLoading.dismiss();
        Get.to(ViewUserProfile(userModel: userModel));
      });
    },
    cells: [
      DataCell(
        Row(
          children: [
            TextAvatar(
              size: 35,
              backgroundColor: Colors.white,
              textColor: Colors.white,
              fontSize: 14,
              upperCase: true,
              numberLetters: 1,
              shape: Shape.Rectangle,
              text: userInfo.name,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Text(
                userInfo.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      DataCell(Text(userInfo.email)),
      DataCell(Text(DateFormat('dd/MM/yyyy, HH:mm')
          .format(userInfo.createTime.toDate()))),
      DataCell(
        Row(
          children: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.withOpacity(0.5),
              ),
              icon: const Icon(
                Icons.edit,
                size: 14,
              ),
              onPressed: () {},
              // Edit
              label: const Text("Edit"),
            ),
            const SizedBox(
              width: 6,
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.withOpacity(0.5),
              ),
              icon: const Icon(
                Icons.visibility,
                size: 14,
              ),
              onPressed: () {
                EasyLoading.show(status: "Loading..");
                DbHelper.getUserInfo(userInfo.id).listen((event) {
                  final userModel = UserModel.fromMap(event.data()!);
                  EasyLoading.dismiss();
                  Get.to(ViewUserProfile(userModel: userModel));
                });
              },
              //View
              label: const Text("View"),
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
                                    "Are you sure want to delete \n'${userInfo.name}'?"),
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
        ),
      ),
    ],
  );
}
