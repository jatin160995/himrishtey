import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_observer/Observable.dart';
import 'package:himrishtey/controllers/get_values.dart';
import 'package:himrishtey/utils/common.dart';
import 'package:himrishtey/utils/container_radius.dart';
import 'package:himrishtey/utils/send_analytics.dart';
import 'package:himrishtey/utils/variables/api_endpoints.dart';
import 'package:himrishtey/utils/variables/globals.dart';
import 'package:himrishtey/utils/variables/observer_variables.dart';
import 'package:himrishtey/utils/variables/shared_prefrences.dart';
import 'package:himrishtey/widgets/loader.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentSuccessIap extends StatefulWidget {
  String txnId;
  String amount;
  String name;
  bool isWallet;
  String plan;

  PaymentSuccessIap(
      this.txnId, this.amount, this.name, this.isWallet, this.plan,
      {super.key});

  @override
  State<PaymentSuccessIap> createState() => _PaymentSuccessIapState();
}

class _PaymentSuccessIapState extends State<PaymentSuccessIap> {
  @override
  void initState() {
    // Send stats to firebase and Pixel
    sendStats("payment_success",
        map: {'event': 'payment', "txn_id": widget.txnId});

    facebookAppEvents.setAdvertiserTracking(enabled: true);
    if (widget.isWallet) {
      setStatusToServer(update_wallet_url);
    } else {
      setPlanStatusToServer(update_payment_status_url);
    }

    super.initState();
  }

  startTimer() {
    Future.delayed(
      Duration(seconds: 3),
      () {
        // Navigator.pop(context, true);
        //Navigator.pop(context, true);
        Navigator.pop(context, true);
      },
    );
  }

  GetValues getValues = new GetValues();
  bool isLoading = true;
  setPlanStatusToServer(String url) async {
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    Map map = {};
    map["user_id"] = await getString(key: userId);
    map["amount"] = widget.amount;
    map["txn_id"] = widget.txnId.toString();
    map["remark"] = 'ios';
    map["plan_id"] = widget.plan;
    map["payment_date"] = formattedDate;
    map["payment_status"] = 'paid';

    dynamic responseData = await getValues.getValues(url, map);
    loadingState(true);
    if (responseData['success']) {
      loadingState(false);

      showToast("Payment success");
      Observable.instance.notifyObservers([wallet_observer],
          notifyName: update_balance, map: {});
      Observable.instance.notifyObservers([home_observer],
          notifyName: profile_updater, map: {});
      startTimer();
      //  return responseData[keyword];
    } else {
      loadingState(false);
      showToast("Something went wrong");
      return [];
    }
  }

  setStatusToServer(String url) async {
    Map map = {};
    map["user_id"] = await getString(key: userId);
    map["amount"] = widget.plan;
    map["txn_id"] = widget.txnId;
    map["remark"] = '';

    dynamic responseData = await getValues.getValues(url, map);
    loadingState(true);
    if (responseData['success']) {
      loadingState(false);

      showToast("Payment success");
      Observable.instance.notifyObservers([wallet_observer],
          notifyName: update_balance, map: {});
      Observable.instance.notifyObservers([home_observer],
          notifyName: profile_updater, map: {});
      startTimer();
      //  return responseData[keyword];
    } else {
      loadingState(false);
      showToast("Something went wrong");
      return [];
    }
  }

  loadingState(bool state) {
    setState(() {
      isLoading = state;
    });
  }

  DateTime? currentBackPressTime;
  bool canPopNow = false;

  void onPopInvoked(bool didPop) {
    setState(() {
      canPopNow = true;
    });
    Navigator.pop(context, true);
    Navigator.pop(context, true);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: textDark(),
      body: Stack(
        children: [
          isLoading
              ? Center(child: Loader())
              : Container(
                  height: MediaQuery.of(context).size.height * 0.75,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 40, 144, 101),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(
                          MediaQuery.of(context).size.width / 2),
                      bottomRight: Radius.circular(
                          MediaQuery.of(context).size.width / 2),
                    ), //BorderRadius.all
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          height: 70,
                          child: Image.asset("assets/images/done.gif")),
                      SizedBox(height: 0),
                      Text(
                        "Payment Successful",
                        style: TextStyle(color: white),
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: 110,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                height: 60,
                                width: 60,
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: darkText,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                  border: Border.all(
                                      color: white,
                                      width: 1.0,
                                      style: BorderStyle.solid),
                                ),
                                child: Image.asset(logo),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  color: lightestText,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                  border: Border.all(
                                      color: white,
                                      width: 1.0,
                                      style: BorderStyle.solid),
                                ),
                                child: Center(
                                  child: Text(
                                    widget.name.substring(0, 1),
                                    style: TextStyle(
                                        color: white,
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "HimRishtey Marriage Beureu",
                        style: TextStyle(
                            color: white, fontSize: 20, fontFamily: "medium"),
                      ),
                      SizedBox(height: 20),
                      // Text(
                      //   currencySign + widget.amount.toString(),
                      //   style: TextStyle(
                      //       color: white,
                      //       fontSize: 33,
                      //       fontWeight: FontWeight.bold),
                      // ),
                      // SizedBox(height: 20),
                      Text(
                        "TXN ID : " + widget.txnId.toString(),
                        style: TextStyle(color: white),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Thank you for choosing our services.",
                        style: TextStyle(color: white, fontSize: 13),
                      ),
                    ],
                  ),
                ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 50,
                    width: 200,
                    margin: EdgeInsets.only(bottom: 30),
                    decoration: borderRadius(white, 8),
                    child: TextButton(
                        onPressed: () {
                          // Navigator.of(context)
                          //     .popUntil(ModalRoute.withName("/dashboard"));
                          if (Platform.isAndroid) {
                            Navigator.pop(context, true);
                            Navigator.pop(context, true);
                          }

                          Navigator.pop(context, true);
                        },
                        child: Text('Explore Profiles',
                            style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.bold))),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    height: 30,
                    child: Image.asset("assets/images/logo-2.png"),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
