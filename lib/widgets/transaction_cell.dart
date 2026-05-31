import 'package:flutter/material.dart';
import 'package:himrishtey/utils/common.dart';
import 'package:himrishtey/utils/container_radius.dart';

class TransactionCell extends StatelessWidget {
  dynamic transaction;
  //TransactionCell({this.transaction});
  TransactionCell(this.transaction, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: borderRadius(lightBackgroundColor(), 15),
      margin: EdgeInsets.symmetric(vertical: 7.5),
      padding: EdgeInsets.all(15),
      child: Row(children: [
        /* Container(
          height: 40,
          width: 40,
          padding: EdgeInsets.all(10),
          decoration: borderRadius(white, 20),
          child: Image.asset(
            isCredit ? "assets/images/credit.png" : "assets/images/debit.png",
            color: isCredit ? five : one,
          ),
        ),
        SizedBox(
          width: 15,
        ),*/
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              transaction['amount_added'] == "0" ||
                      transaction['amount_added'] == ""
                  ? "Debit"
                  : "Credit",
              style: TextStyle(
                  color: textDark(), fontSize: 16, fontWeight: FontWeight.bold),
            ),
            // Text(
            //   "17 Oct, 2023",
            //   style: TextStyle(
            //       color: textLightest(),
            //       fontSize: 12,
            //       fontWeight: FontWeight.normal),
            // ),
          ],
        ),
        Expanded(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              (transaction['amount_added'] == "0" ||
                          transaction['amount_added'] == ""
                      ? "-"
                      : "+") +
                  currencySign +
                  (transaction['amount_added'] == "0" ||
                          transaction['amount_added'] == ""
                      ? transaction['amount_deducted']
                      : transaction['amount_added']),
              style: TextStyle(
                  color: transaction['amount_added'] == "0" ||
                          transaction['amount_added'] == ""
                      ? one
                      : five,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ))
      ]),
    );
  }
}
