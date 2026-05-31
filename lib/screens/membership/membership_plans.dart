import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:himrishtey/controllers/get_values.dart';
import 'package:himrishtey/controllers/user_controller.dart';
import 'package:himrishtey/payment/payment_screen.dart';
import 'package:himrishtey/payment/payment_success.dart';
import 'package:himrishtey/utils/common.dart';
import 'package:himrishtey/utils/container_radius.dart';
import 'package:himrishtey/utils/variables/api_endpoints.dart';
import 'package:himrishtey/utils/variables/globals.dart';
import 'package:himrishtey/utils/variables/shared_prefrences.dart';
import 'package:himrishtey/widgets/button_loader.dart';
import 'package:himrishtey/widgets/loader.dart';

class MembershipPlans extends StatefulWidget {
  dynamic membership;
  MembershipPlans(this.membership, {super.key});

  @override
  State<MembershipPlans> createState() => _MembershipPlansState();
}

class _MembershipPlansState extends State<MembershipPlans> {
  @override
  void initState() {
    getPlans();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor(),
      appBar: AppBar(
        title: headingBig(widget.membership['membership_name']),
      ),
      body: isLoading
          ? Center(child: Loader())
          : ListView(
              padding: EdgeInsets.all(20),
              children: [
                Column(
                  children: plansWidget(),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 10),
                  //height: MediaQuery.of(context).size.height * 0.7,
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      heading("Description"),
                      Text(widget.membership['plan_description']),
                      SizedBox(height: 10),
                      heading("Terms and Conditions"),
                      Text(widget.membership['terms_and_conditions']),
                      SizedBox(height: 10),
                      heading("Features"),
                      GestureDetector(
                        onTap: () {
                          _showMyDialog();
                        },
                        child: Text.rich(TextSpan(
                            text: "● " + widget.membership['tag_line1'],
                            children: <InlineSpan>[
                              TextSpan(
                                text: 'T&C',
                                style: TextStyle(
                                    fontSize: 14, color: primaryColor),
                              )
                            ])),
                      ),
                      Text("● " + widget.membership['tag_line2'].toString()),
                      Text("● " + widget.membership['tag_line3'].toString()),
                      Text("● " + widget.membership['tag_line4'].toString()),
                      Text("● " + widget.membership['tag_line5'].toString()),
                      Text("● " + widget.membership['tag_line6'].toString()),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!

      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: white,
          title: const Text('Terms and conditions'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(widget.membership['terms_and_conditions']),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Okay'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  List colorsList = [
    Colors.purple,
    Colors.amber[800],
    Colors.blue,
    Colors.indigo
  ];
  List<Widget> plansWidget() {
    List<Widget> widgetList = [];
    for (int i = 0; i < data.length; i++) {
      widgetList.add(Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 20),
        decoration: borderRadius(colorsList[i], 20),
        padding: EdgeInsets.all(15),
        child: Stack(
          children: [
            Column(children: [
              Text(
                data[i]['plan_name'],
                style: TextStyle(
                  color: white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Allowed Contact : " + data[i]['view_contact'],
                style: TextStyle(
                    color: white,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    fontFamily: "medium"),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    currencySign + data[i]['final_cost'],
                    style: TextStyle(
                      color: white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    " / " + data[i]['duration_days'] + "days",
                    style: TextStyle(
                        color: white,
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        decorationColor: Colors.white,
                        fontFamily: "medium"),
                  ),
                ],
              ),
              Text(
                currencySign + data[i]['plan_cost'],
                style: TextStyle(
                  decoration: TextDecoration.lineThrough,
                  color: white,
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  decorationColor: Colors.white,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 35,
                width: 200,
                decoration: borderRadius(primaryColor, 10),
                child: TextButton(
                  onPressed: () {
                    // Platform.isIOS
                    //     ? getData(callback_number_url)
                    //     :
                    getUserValues(data[i]);
                  },
                  child: isLoadingCallback
                      ? ButtonLoader()
                      : Text(
                          // Platform.isIOS ? "Request callback" :
                          "Buy Now",
                          style: TextStyle(
                              color: white, fontWeight: FontWeight.bold),
                        ),
                ),
              )
            ]),
            Align(
              alignment: Alignment.topLeft,
              child: Row(
                children: [
                  Container(
                      height: 25,
                      width: 25,
                      child: Image.asset("assets/images/discount.png")),
                  Text(
                    " " + data[i]['discount_percentage'] + "% off",
                    style: TextStyle(
                        color: white,
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        decorationColor: Colors.white,
                        fontFamily: "medium"),
                  ),
                ],
              ),
            )
          ],
        ),
      ));
    }
    return widgetList;
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
            builder: (context) => PaymentScreen(
                nameSaved,
                mobileNumberSaved,
                emailSaved,
                plan['final_cost'],
                plan['plan_name'],
                false,
                plan)));
  }

  UserController userController = new UserController();
  bool isLoading = true;
  List data = [];
  getPlans() async {
    loadingState(true);
    dynamic responseData =
        await userController.getMembershipPlans(widget.membership['id']);
    if (responseData['success']) {
      data = responseData['memberships'];
      loadingState(false);
    } else {
      loadingState(false);
      showToast("Something went wrong");
    }
  }

  loadingState(bool state) {
    setState(() {
      isLoading = state;
    });
  }

  //CallbackFeature
  bool isLoadingCallback = false;
  GetValues getValues = new GetValues();

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
