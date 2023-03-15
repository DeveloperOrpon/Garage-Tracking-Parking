import 'dart:developer';

import 'package:colorize_text_avatar/colorize_text_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:parking_koi/pages/admin/dashboard/ui/user_search_delegate.dart';
import 'package:provider/provider.dart';

import '../../../database/dbhelper.dart';
import '../../../model/user_model.dart';
import '../../../provider/adminProvider.dart';
import '../../../utils/const.dart';

class ShowAllUserPage extends StatefulWidget {
  const ShowAllUserPage({Key? key}) : super(key: key);

  @override
  State<ShowAllUserPage> createState() => _ShowAllUserPageState();
}

class _ShowAllUserPageState extends State<ShowAllUserPage> {
  UserModel? selectUserModel;
  bool showSearchResult = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.withOpacity(.2),
      appBar: AppBar(
        title: const Text(
          "User List",
        ),
        actions: [
          !showSearchResult
              ? IconButton(
                  onPressed: () {
                    showSearch(context: context, delegate: UserSearchClass())
                        .then((uid) {
                      DbHelper.getUserInfo(uid).listen((snapshot) {
                        selectUserModel = UserModel.fromMap(snapshot.data()!);
                        showSearchResult = true;
                        setState(() {});
                      });
                      log(uid);
                    });
                  },
                  icon: const Icon(Icons.search_rounded),
                )
              : IconButton(
                  onPressed: () {
                    setState(() {
                      showSearchResult = false;
                    });
                  },
                  icon: const Icon(
                    Icons.clear,
                    size: 32,
                    color: Colors.red,
                  ))
        ],
      ),
      body: Consumer<AdminProvider>(
        builder: (context, adminProvider, child) {
          return !showSearchResult && adminProvider.allUserList.isNotEmpty
              ? ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: adminProvider.allUserList.length,
                  itemBuilder: (context, index) {
                    final userModel = adminProvider.allUserList[index];
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      delay: const Duration(milliseconds: 100),
                      child: SlideAnimation(
                        duration: const Duration(milliseconds: 2500),
                        curve: Curves.fastLinearToSlowEaseIn,
                        verticalOffset: -250,
                        child: ScaleAnimation(
                          duration: const Duration(milliseconds: 1500),
                          curve: Curves.fastLinearToSlowEaseIn,
                          child: Container(
                            margin: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: movieListGradient[index % 10],
                            ),
                            child: ExpansionTile(
                              title: Text(
                                userModel.name == null
                                    ? "No Name"
                                    : userModel.name!.toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              leading: userModel.profileUrl != null
                                  ? CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(userModel.profileUrl!),
                                    )
                                  : TextAvatar(
                                      size: 35,
                                      backgroundColor: Colors.white,
                                      textColor: Colors.white,
                                      fontSize: 14,
                                      upperCase: true,
                                      numberLetters: 1,
                                      shape: Shape.Rectangle,
                                      text: userModel.name ?? 'Null',
                                    ),
                              subtitle: Text(
                                userModel.location!,
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.black),
                              ),
                              trailing: const IconButton(
                                  onPressed: null,
                                  icon: Icon(Icons.more_vert_rounded)),

                              //more
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {},
                                      child: Text("Show Parking Ads Info"),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {},
                                      child: Text("Booking Info"),
                                    ),
                                  ],
                                ),
                                ElevatedButton(
                                  onPressed: () {},
                                  child: const Text("Show Garage Ads Info"),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                )
              : showSearchResult
                  ? Container(
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: movieListGradient[0],
                      ),
                      child: ExpansionTile(
                        title: Text(
                          selectUserModel!.name == null
                              ? "No Name"
                              : selectUserModel!.name!.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        leading: selectUserModel!.profileUrl != null
                            ? CircleAvatar(
                                backgroundImage:
                                    NetworkImage(selectUserModel!.profileUrl!),
                              )
                            : TextAvatar(
                                size: 35,
                                backgroundColor: Colors.white,
                                textColor: Colors.white,
                                fontSize: 14,
                                upperCase: true,
                                numberLetters: 1,
                                shape: Shape.Rectangle,
                                text: selectUserModel!.name!,
                              ),
                        subtitle: Text(
                          selectUserModel!.location!,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.black),
                        ),
                        trailing: const IconButton(
                            onPressed: null,
                            icon: Icon(Icons.more_vert_rounded)),

                        //more
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () {},
                                child: Text("Show Parking Ads Info"),
                              ),
                              ElevatedButton(
                                onPressed: () {},
                                child: Text("Booking Info"),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            child: const Text("Show Garage Ads Info"),
                          ),
                        ],
                      ),
                    )
                  : const Center(
                      child: Text(
                        "There Have No User",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    );
        },
      ),
    );
  }
}
