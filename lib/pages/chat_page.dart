import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colorize_text_avatar/colorize_text_avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parking_koi/database/dbhelper.dart';
import 'package:parking_koi/model/message_model.dart';
import 'package:parking_koi/model/user_model.dart';
import 'package:parking_koi/provider/mapProvider.dart';
import 'package:parking_koi/services/Auth_service.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../provider/adminProvider.dart';

class ChatPage extends StatefulWidget {
  final UserModel senderUseModel;

  const ChatPage({
    Key? key,
    required this.senderUseModel,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  var _focusNode = FocusNode();

  focusListener() {
    setState(() {});
  }

  @override
  void initState() {
    _focusNode.addListener(focusListener);
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.removeListener(focusListener);
    super.dispose();
  }

  TextEditingController msgcontroller = TextEditingController();
  SampleItem? selectedMenu;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xffF5F5F5),
        appBar: AppBar(
          shadowColor: Colors.transparent,
          toolbarHeight: 100,
          elevation: 5,
          scrolledUnderElevation: 5,
          backgroundColor: const Color(0xffFFFFFF),
          automaticallyImplyLeading: true,
          leading: const BackButton(color: Colors.black),
          title: SizedBox(
            width: 290,
            height: 59,
            child: Row(
              children: [
                SizedBox(
                    width: 65,
                    height: 70,
                    child: widget.senderUseModel.profileUrl != null
                        ? CircleAvatar(
                            radius: 50,
                            backgroundImage:
                                NetworkImage(widget.senderUseModel.profileUrl!),
                            //  child: Image.network(widget.image!),
                          )
                        : TextAvatar(
                            text: widget.senderUseModel.name,
                          )),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.senderUseModel.name ??
                          widget.senderUseModel.phoneNumber,
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff222222),
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      '24/7 Service',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.green,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          actions: [
            Consumer<MapProvider>(
              builder: (context, value, child) => PopupMenuButton<SampleItem>(
                color: Colors.red,
                icon: Image.asset(
                  'asset/image/more.png',
                  height: 35,
                  width: 35,
                ),
                initialValue: selectedMenu,
                onSelected: (SampleItem item) {
                  selectedMenu = item;
                },
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem<SampleItem>(
                    value: SampleItem.itemOne,
                    child: const Text(
                      'Delete All Chat',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      _deleteAllChat(value);
                    },
                  ),
                ],
              ),
            )
          ],
        ),
        body: Consumer<MapProvider>(
          builder: (context, mapProvider, child) => Column(
            children: [
              Expanded(
                child: mapProvider
                        .getUserMessageByUId(widget.senderUseModel.uid)
                        .isNotEmpty
                    ? Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        child: ListView.builder(
                          itemCount: mapProvider
                              .getUserMessageByUId(widget.senderUseModel.uid)
                              .length,
                          itemBuilder: (context, index) {
                            var message = mapProvider.getUserMessageByUId(
                                widget.senderUseModel.uid)[index];
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: message.senderId ==
                                      AuthService.currentUser!.uid
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  margin: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: message.senderId ==
                                            AuthService.currentUser!.uid
                                        ? Colors.blue
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SelectableText(
                                        message.message,
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w300,
                                          color: message.senderId !=
                                                  AuthService.currentUser!.uid
                                              ? Colors.blue
                                              : Colors.white,
                                        ),
                                      ),
                                      Text(
                                        timeago.format(
                                            DateTime.fromMillisecondsSinceEpoch(
                                                message.sentTime
                                                    .millisecondsSinceEpoch)),
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontSize: 6,
                                          fontWeight: FontWeight.w300,
                                          color: message.senderId !=
                                                  AuthService.currentUser!.uid
                                              ? Colors.blue
                                              : Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      )
                    : const Center(
                        child: Text("No Message at yet"),
                      ),
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 20, left: 20),
                      width: MediaQuery.of(context).size.width - 100,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Color(0xffF3F3F3),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0xffDBDBDB),
                            blurRadius: 15,
                            spreadRadius: 1.5,
                          ),
                        ],
                      ),
                      child: TextFormField(
                        keyboardAppearance: Brightness.dark,
                        //textInputAction: TextInputAction.continueAction,
                        controller: msgcontroller,
                        maxLines: 35,
                        focusNode: _focusNode,
                        decoration: InputDecoration(
                          hintText: 'Message...',
                          hintStyle: GoogleFonts.inter(
                            fontSize: 16,
                            color: Color(0xffB5B4B4),
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.only(
                            top: 19,
                            left: 20,
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(
                                top: 0, left: 10, right: 10),
                            child: Image.asset(
                              "asset/image/smile.png",
                              color: Colors.black,
                              height: 27,
                              width: 27,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 10,
                        right: 0,
                        left: 10,
                      ),
                      child: FloatingActionButton(
                        elevation: 15,
                        onPressed: () {},
                        child: ElevatedButton(
                          onPressed: () {
                            _sentMessage();
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Color(0xffFFFFFF),
                            backgroundColor: Color(0xff2865DC),
                            shape: CircleBorder(),
                            disabledForegroundColor:
                                Color(0xff2865DC).withOpacity(0.38),
                            disabledBackgroundColor:
                                Color(0xff2865DC).withOpacity(0.12),
                            padding: EdgeInsets.all(10),
                          ),
                          child: Image.asset(
                            "asset/image/send1.png",
                            color: Colors.white,
                            height: 36,
                            width: 27,
                          ),
                        ),
                      ),
                    ),
                  ]),
            ],
          ),
        ),
      ),
    );
  }

  void _sentMessage() {
    log("message");
    if (msgcontroller.text.isNotEmpty) {
      final messageModel = MessageModel(
        mId: "M-${DateTime.now().millisecondsSinceEpoch}",
        senderId: AuthService.currentUser!.uid,
        revivedId: widget.senderUseModel.uid,
        message: msgcontroller.text,
        sentTime: Timestamp.now(),
      );
      msgcontroller.text = '';
      DbHelper.sentMessage(messageModel: messageModel);
    } else {
      Get.snackbar(
        "Information",
        "Write SomeThing In Text",
        duration: Duration(seconds: 1),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
      );
    }
  }

  void _deleteAllChat(MapProvider mapProvider) {
    mapProvider.deleteAllUserMessage(
        mapProvider.getUserMessageByUId(widget.senderUseModel.uid));
  }
}
