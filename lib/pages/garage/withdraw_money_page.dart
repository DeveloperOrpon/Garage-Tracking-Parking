import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:parking_koi/database/dbhelper.dart';
import 'package:parking_koi/pages/garage/widthdraw_money_status.dart';
import 'package:parking_koi/provider/mapProvider.dart';
import 'package:parking_koi/services/Auth_service.dart';
import 'package:parking_koi/utils/const.dart';
import 'package:provider/provider.dart';

import '../../model/withdraw_money_model.dart';

class WithDrawMoneyPage extends StatefulWidget {
  const WithDrawMoneyPage({Key? key}) : super(key: key);

  @override
  State<WithDrawMoneyPage> createState() => _WithDrawMoneyPageState();
}

class _WithDrawMoneyPageState extends State<WithDrawMoneyPage> {
  var formKey = GlobalKey<FormState>();
  final moneyController = TextEditingController();
  final numberController = TextEditingController();
  String? withDrawMethod;
  bool isButtonActive = true;
  List<String> withDrawMethodList = ["Bkash", "Rocket", "Nogot", "Bank"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Get.to(const WithDrawMoneyStatus(),
                transition: Transition.leftToRightWithFade);
          },
          label: const Text(
            "Payment Request List",
            style: TextStyle(color: Colors.white),
          )),
      appBar: AppBar(
        title: const Text("Withdraw Money Page"),
      ),
      body: Consumer<MapProvider>(
        builder: (context, mapProvider, child) => Form(
          key: formKey,
          child: ListView(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  "Fill The Information Currently other ways this not editable Any More......",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: moneyController,
                  decoration: InputDecoration(
                      fillColor: Colors.grey.shade300,
                      filled: true,
                      border: InputBorder.none,
                      hintText: "Enter Amount $takaSymbol",
                      helperStyle:
                          const TextStyle(color: Colors.grey, fontSize: 14)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please Fill Amount";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: DropdownButtonFormField<String>(
                  key: UniqueKey(),
                  decoration: const InputDecoration(
                      labelText: 'Select Withdraw Method',
                      border: OutlineInputBorder()),
                  value: withDrawMethod,
                  items: withDrawMethodList.map((category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (method) {
                    setState(() {
                      withDrawMethod = method;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: numberController,
                  decoration: InputDecoration(
                      fillColor: Colors.grey.shade300,
                      filled: true,
                      helperText:
                          "*Bank fill provide A/C Number\n*Mobile Banking Provide Number",
                      border: InputBorder.none,
                      hintText: "Enter Number",
                      helperStyle:
                          const TextStyle(color: Colors.grey, fontSize: 14)),
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 10) {
                      return "Please Fill 10 digits";
                    }
                  },
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: CupertinoButton(
                  color: Colors.green,
                  onPressed: isButtonActive
                      ? () {
                          _createWithDrawRequest(mapProvider);
                        }
                      : null,
                  child: const Text(
                    "Submit Request",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Image.asset(
                'asset/image/paymentInfo.jpg',
                height: 100,
                width: Get.width,
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _createWithDrawRequest(MapProvider mapProvider) async {
    if (formKey.currentState!.validate() && withDrawMethod != null) {
      setState(() {
        isButtonActive = false;
      });
      if (num.parse(mapProvider.userModel!.balance).toInt() <
          num.parse(moneyController.text).toInt()) {
        setState(() {
          isButtonActive = true;
        });
        Fluttertoast.showToast(
          msg: "You are not Enough Balance",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 18.0,
        );
        return;
      }
      EasyLoading.show(status: "Wait");
      final withDrawMoneyModel = WithDrawMoneyModel(
        garageOwnerId: AuthService.currentUser!.uid,
        tId: "W-${DateTime.now().millisecondsSinceEpoch}",
        withDrawBalance: moneyController.text,
        paymentMethod: withDrawMethod!,
        paymentNumber: numberController.text,
        withdrawRequestTime: Timestamp.now(),
      );
      clear();
      log(withDrawMoneyModel.toString());
      log(mapProvider.userModel!.toString());
      await DbHelper.withDrawRequest(withDrawMoneyModel, mapProvider.userModel!)
          .then((value) {
        EasyLoading.dismiss();
        Get.snackbar("Information", "Request To Admin Wait 72 Hour",
            duration: const Duration(seconds: 2),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            showProgressIndicator: true);
        setState(() {
          isButtonActive = true;
        });
      }).catchError((onError) {
        EasyLoading.dismiss();
        log(onError.toString());
        Get.snackbar("Information", onError.toString(),
            duration: const Duration(seconds: 2),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            showProgressIndicator: true);
        setState(() {
          isButtonActive = true;
        });
      });
    } else {
      Fluttertoast.showToast(
        msg: "Enter all Information",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 18.0,
      );
      setState(() {
        isButtonActive = true;
      });
    }
  }

  clear() {
    moneyController.text = '';
    numberController.text = '';
    withDrawMethod = null;
  }
}
