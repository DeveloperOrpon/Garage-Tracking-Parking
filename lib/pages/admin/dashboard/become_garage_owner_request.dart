import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:colorize_text_avatar/colorize_text_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../database/dbhelper.dart';
import '../../../model/user_model.dart';
import '../../../provider/adminProvider.dart';
import '../../../utils/const.dart';
import '../../fullScreenImage.dart';

class BecomeGarageOwnerRequest extends StatefulWidget {
  const BecomeGarageOwnerRequest({Key? key}) : super(key: key);

  @override
  State<BecomeGarageOwnerRequest> createState() =>
      _BecomeGarageOwnerRequestState();
}

class _BecomeGarageOwnerRequestState extends State<BecomeGarageOwnerRequest> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AdminProvider>(
      builder: (context, adminProvider, child) => Scaffold(
        appBar: AppBar(
          title: const Text("Garage Owner Request List"),
        ),
        body: adminProvider.getRequestGarageOwner().isNotEmpty
            ? ListView.builder(
                itemCount: adminProvider.getRequestGarageOwner().length,
                itemBuilder: (context, index) {
                  final user = adminProvider.getRequestGarageOwner()[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ExpansionTile(
                      textColor: Colors.white,
                      backgroundColor: Colors.pink.shade200,
                      collapsedBackgroundColor: randomColors[index % 10],
                      title: Text(user.name ?? user.phoneNumber),
                      leading: user.profileUrl == null
                          ? TextAvatar(
                              size: 35,
                              backgroundColor: Colors.white,
                              textColor: Colors.white,
                              fontSize: 14,
                              upperCase: true,
                              numberLetters: 1,
                              shape: Shape.Rectangle,
                              text: user.name ?? 'Null',
                            )
                          : CachedNetworkImage(
                              imageUrl: user.profileUrl!,
                              height: 80,
                              width: 80,
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                      subtitle: Text(user.location!),
                      trailing: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          onPressed: () {
                            _acceptGarageOwnerRequest(user);
                          },
                          child: const Text(
                            "Accept",
                            style: TextStyle(color: Colors.white),
                          )),
                      children: [
                        const Text("NID Card Information :"),
                        SizedBox(height: 20),
                        user.nIdGarageOwnerUrl == null
                            ? Text("NID Image Not Uploaded")
                            : InkWell(
                                onTap: () {
                                  Get.to(FullScreenPage(
                                      imageUrl: user.nIdGarageOwnerUrl!));
                                },
                                child: Hero(
                                  tag: user.nIdGarageOwnerUrl!,
                                  child: CachedNetworkImage(
                                    imageUrl: user.nIdGarageOwnerUrl!,
                                    height: 120,
                                    width: 300,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                ),
                              )
                      ],
                    ),
                  );
                },
              )
            : const Center(
                child: Text(
                  "No Garage Owner Request",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
      ),
    );
  }

  Future<void> _acceptGarageOwnerRequest(UserModel user) async {
    EasyLoading.show(status: "Wait");
    await DbHelper.updateUserProfileField(user.uid, {
      userFieldAccountIsActive: true,
    }).then((value) {
      EasyLoading.dismiss();
    }).catchError((onError) {
      EasyLoading.dismiss();
      log(onError.toString());
    });
  }
}
