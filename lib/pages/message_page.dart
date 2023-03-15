import 'package:cached_network_image/cached_network_image.dart';
import 'package:colorize_text_avatar/colorize_text_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:parking_koi/database/dbhelper.dart';
import 'package:parking_koi/model/user_model.dart';
import 'package:parking_koi/provider/mapProvider.dart';
import 'package:provider/provider.dart';

import 'chat_page.dart';

class MessagePage extends StatelessWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<MapProvider>(
      builder: (context, mapProvider, child) {
        return mapProvider.messageUserList().isNotEmpty
            ? Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: 60,
                    width: Get.width,
                    margin: EdgeInsets.only(top: 30, left: 10, right: 10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(5, 5),
                            blurRadius: 20,
                            spreadRadius: 10,
                          )
                        ]),
                    child: const Text(
                      "Conversion",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: mapProvider.messageUserList().length,
                      itemBuilder: (context, index) {
                        final userId = mapProvider.messageUserList()[index];
                        return AnimationLimiter(
                          child: AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 350),
                            child: SlideAnimation(
                              verticalOffset: -150.0,
                              child: FadeInAnimation(
                                child: FutureBuilder(
                                  future: DbHelper.getUserInfoMap(userId),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      final userModel = UserModel.fromMap(
                                          snapshot.data!.data()!);
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ListTile(
                                          onTap: () {
                                            Get.to(
                                                ChatPage(
                                                    senderUseModel: userModel),
                                                transition: Transition
                                                    .leftToRightWithFade);
                                          },
                                          tileColor: Colors.orange.shade200,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          title: Text(
                                              "${userModel.name} (${userModel.isGarageOwner ? "Garage Owner" : "Admin"})"),
                                          subtitle: Text(
                                              userModel.email ?? userModel.uid),
                                          leading: userModel.profileUrl != null
                                              ? ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  child: CachedNetworkImage(
                                                    width: 50,
                                                    height: 50,
                                                    fit: BoxFit.cover,
                                                    imageUrl:
                                                        userModel.profileUrl!,
                                                    placeholder: (context,
                                                            url) =>
                                                        CircularProgressIndicator(),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Icon(Icons.error),
                                                  ),
                                                )
                                              : TextAvatar(
                                                  text: userModel.name,
                                                ),
                                          trailing: const Icon(
                                            Icons.message,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      );
                                    }
                                    return const SpinKitSquareCircle(
                                      color: Colors.orange,
                                      size: 50.0,
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'asset/image/mail.png',
                      width: 100,
                      height: 100,
                    ),
                    Text("No Message Histroy"),
                  ],
                ),
              );
      },
    );
  }
}
