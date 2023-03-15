import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../database/dbhelper.dart';
import '../models/vat_model.dart';

class VatAndCouponCodePage extends StatefulWidget {
  const VatAndCouponCodePage({Key? key}) : super(key: key);

  @override
  State<VatAndCouponCodePage> createState() => _VatAndCouponCodePageState();
}

class _VatAndCouponCodePageState extends State<VatAndCouponCodePage> {
  final vatController = TextEditingController();
  final commissionController = TextEditingController();
  bool wait = true;

  @override
  Future<void> didChangeDependencies() async {
    if (!await DbHelper.doesServiceInfoExist()) {
      DbHelper.saveServiceInfo(ServiceCost(vat: '0', commissionParking: '0'))
          .then((value) {
        setState(() {
          wait = false;
        });
      });
    } else {
      setState(() {
        wait = false;
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Set Vat and Coupon"),
        ),
        body: !wait
            ? FutureBuilder(
                future: DbHelper.getServiceCost(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final serviceModel =
                        ServiceCost.fromMap(snapshot.data!.data()!);
                    vatController.text = serviceModel.vat;
                    commissionController.text = serviceModel.commissionParking;
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Vat(Per) Parking : ",
                              style: TextStyle(fontSize: 19),
                            ),
                            SizedBox(
                              width: 100,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  controller: vatController,
                                  decoration: InputDecoration(
                                    filled: true,
                                    focusColor: Colors.grey.shade300,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Text(
                              "% ",
                              style: TextStyle(fontSize: 19),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Commission Parking : ",
                              style: TextStyle(fontSize: 19),
                            ),
                            SizedBox(
                              width: 100,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: commissionController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    filled: true,
                                    focusColor: Colors.grey.shade300,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Text(
                              "% ",
                              style: TextStyle(fontSize: 19),
                            ),
                          ],
                        ),
                        const Text(
                          "List Of Coupon Code:",
                          style: TextStyle(fontSize: 19),
                        ),
                        Expanded(
                            child: ListView.builder(
                          itemCount: 5,
                          itemBuilder: (context, index) => Container(
                            margin: EdgeInsets.all(4),
                            child: ListTile(
                              tileColor: Colors.grey.shade200,
                              title: Text("65465356"),
                              trailing: IconButton(
                                  onPressed: () {}, icon: Icon(Icons.copy)),
                            ),
                          ),
                        )),
                        ElevatedButton(
                            onPressed: () {
                              _saveServiceCostInfo();
                            },
                            child: Text("Update"))
                      ],
                    );
                  }
                  return const SpinKitRotatingCircle(
                    color: Colors.orange,
                    size: 50.0,
                  );
                },
              )
            : const SpinKitRotatingCircle(
                color: Colors.orange,
                size: 50.0,
              ));
  }

  void _saveServiceCostInfo() {
    EasyLoading.show(status: "Wait");
    final serviceModel = ServiceCost(
        vat: vatController.text, commissionParking: commissionController.text);
    DbHelper.saveServiceInfo(serviceModel).then((value) {
      EasyLoading.dismiss();
    }).catchError((onError) {
      EasyLoading.dismiss();
      log(onError.toString());
    });
  }
}
