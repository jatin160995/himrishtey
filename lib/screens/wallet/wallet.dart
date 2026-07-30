import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_observer/Observable.dart';
import 'package:flutter_observer/Observer.dart';
import 'package:himrishtey/controllers/get_values.dart';
import 'package:himrishtey/payment/payment_screen.dart';
import 'package:himrishtey/utils/common.dart';
import 'package:himrishtey/utils/container_radius.dart';
import 'package:himrishtey/utils/variables/api_endpoints.dart';
import 'package:himrishtey/utils/variables/globals.dart';
import 'package:himrishtey/utils/variables/observer_variables.dart';
import 'package:himrishtey/utils/variables/shared_prefrences.dart';
import 'package:himrishtey/widgets/custom_edit_text.dart';
import 'package:himrishtey/widgets/loader.dart';
import 'package:himrishtey/widgets/transaction_cell.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

//id rzp_test_z96mAzEUzvwEcP
//secret MotLjjlR1f0LbAlpPDHSe0HQ

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> with Observer {
  bool isLoading = false;

  @override
  void initState() {
    Observable.instance.addObserver(this);
    super.initState();
    getDataPost();
  }

  @override
  void dispose() {
    Observable.instance.removeObserver(this);
    super.dispose();
  }

  @override
  update(Observable observable, String? notifyName, Map? map) {
    // showToast(notifyName!);
    getDataPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor(),
      appBar: AppBar(
        title: headingBig("Wallet"),
        actions: [
          Container(
            child: Row(),
          )
        ],
      ),
      body: isLoading
          ? Center(child: Loader())
          : ListView(
              padding: EdgeInsets.all(20),
              children: [
                cardWidget(),
                SizedBox(
                  height: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        heading("Recent Transactions"),
                        // TextButton(
                        //     onPressed: () {},
                        //     child: Text(
                        //       "View All",
                        //       style: TextStyle(
                        //           color: primaryColor, fontFamily: "medium"),
                        //     ))
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      children: transactionsList(),
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    heading("Offers"),
                    Text(
                      "Limited time offers",
                      style: TextStyle(color: textLightest(), fontSize: 12),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: offersList(),
                    )
                  ],
                )
              ],
            ),
    );
  }

  var nameSaved;
  var mobileNumberSaved;
  var emailSaved;
  var profileIdSaved;
  getUserValues(dynamic plan) async {
    nameSaved = await getString(key: fullName);
    mobileNumberSaved = await getString(key: mobileNumber);
    emailSaved = await getString(key: email);

    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => PaymentScreen(nameSaved, mobileNumberSaved,
                emailSaved, plan['amount'], plan['title'], true, plan)));
  }

  List<Widget> offersList() {
    List<Widget> offerWidgets = [];
    for (int i = 0; i < walletData['wallet_offers'].length; i++) {
      offerWidgets.add(offerCell(walletData['wallet_offers'][i]));
    }

    return offerWidgets;
  }

  List<Widget> transactionsList() {
    List<Widget> transactionWidgets = [];
    List txnList = walletData['wallet_transactions'];
    txnList = txnList.reversed.toList();
    for (int i = 0; i < txnList.length; i++) {
      transactionWidgets.add(TransactionCell(txnList[i]));
    }
    return transactionWidgets;
  }

  offerCell(dynamic offer) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 7.5),
      decoration: borderRadius(lightBackgroundColor(), 15),
      padding: EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      offer['title'],
                      style: TextStyle(
                          color: textDark(),
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Text(
                  offer['description'],
                  style: TextStyle(
                      color: textMedium(),
                      fontSize: 12,
                      fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Text(
                currencySign + offer['amount'],
                style: TextStyle(
                    color: textDark(),
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                decoration: borderRadius(white, 5),
                height: 35,
                child: TextButton(
                    onPressed: () {
                      getUserValues(offer);
                    },
                    child: Text(
                      "Buy Now",
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 13,
                          fontWeight: FontWeight.bold),
                    )),
              ),
            ],
          )
        ],
      ),
    );
  }

  cardWidget() {
    return Container(
      //padding: EdgeInsets.all(30),
      decoration: borderRadius(Color(0xFF1E1D1D), 20),
      height: 240,
      child: Stack(
        children: [
          // Align(
          //   alignment: Alignment.centerRight,
          //   child: Image.asset(
          //     "assets/images/card-bg.png",
          //     fit: BoxFit.fitWidth,
          //     color: Color(0xFF333333),
          //   ),
          // ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              padding: EdgeInsets.all(30),
              child: Icon(
                Icons.wallet_rounded,
                color: white,
                size: 30,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "My Balance",
                    style: TextStyle(
                        color: white,
                        fontWeight: FontWeight.normal,
                        fontSize: 20),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    coinSign +
                        ((walletData['wallet_balance'] == null)
                            ? "0"
                            : walletData['wallet_balance']),
                    style: TextStyle(
                        color: white,
                        fontWeight: FontWeight.bold,
                        fontSize: 40),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "You can add upto 10k in your account",
                    style: TextStyle(
                        color: darkLightestText,
                        fontWeight: FontWeight.normal,
                        fontSize: 14),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        decoration: borderRadius(Colors.black, 5),
                        height: 35,
                        child: TextButton(
                            onPressed: () {
                              // Platform.isIOS
                              //     ? getData(callback_number_url)
                              //     :
                              _showAddMoneyDialog();
                            },
                            child: Text(
                              // Platform.isIOS
                              //     ? "Request callback to add coin"
                              //     :
                              "Add Money",
                              style: TextStyle(
                                  color: white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            )),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  dynamic walletData = {};

  GetValues getValues = new GetValues();
  getDataPost() async {
    loadingState(true);
    String? userIdSaved = await getString(key: userId);
    dynamic responseData =
        await getValues.getValues(get_wallet_url, {"user_id": userIdSaved});
    if (responseData['success']) {
      loadingState(false);
      walletData = responseData["data"];
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

  Future<void> _showAddMoneyDialog() async {
    TextEditingController amountController = new TextEditingController();

    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: white,
          title: const Text('Add Money'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                CustomEditText(true, 16, amountController, TextInputType.number,
                    "Enter Amount"),
              ],
            ),
          ),
          actions: <Widget>[
            Container(
              decoration: borderRadius(primaryColor, 8),
              child: TextButton(
                child: const Text(
                  'Add',
                  style: TextStyle(color: white),
                ),
                onPressed: () {
                  if (amountController.text.trim() == '') {
                    showToast("Please enter amount");
                    return;
                  }
                  int enteredAmount = int.tryParse(amountController.text) ?? 0;
                  if (enteredAmount < 50) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('The minimum amount must be 50.')),
                    );
                    return;
                  }
                  getUserValues({
                    'add_on_percentage': amountController.text,
                    'amount': amountController.text,
                    'title': 'Add money'
                  });
                  Navigator.of(context).pop();
                },
              ),
            )
          ],
        );
      },
    );
  }

  //CallbackFeature
  bool isLoadingCallback = false;

  getData(String url) async {
    dynamic responseData = await getValues.get(url);
    loadingCallbackState(true);
    if (responseData['success']) {
      loadingCallbackState(false);
      // showToast(responseData['number']['number'].toString());
      sendOtp(responseData['number']['number']);
    } else {
      loadingCallbackState(false);
      showToast("Something went wrong");
      return [];
    }
  }

  sendOtp(String number) async {
    loadingCallbackState(true);
    dynamic responseData = await getValues.getValues(callback_url, {
      'user_id': userInfo['id'],
      'user_name': userInfo['full_name'],
      "number": number
    });

    print(responseData.toString());

    if (responseData['Status'] == "OK") {
      loadingCallbackState(false);
      showToast("You will receive a callback within 10 minutes.");
      // Navigator.pop(context, "1");
    } else {
      loadingCallbackState(false);
      showToast("Something went wrong");
      return [];
    }
  }

  loadingCallbackState(bool state) {
    setState(() {
      isLoadingCallback = state;
    });
  }
}
