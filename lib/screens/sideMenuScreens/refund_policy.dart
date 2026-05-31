import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:himrishtey/utils/common.dart';

class RefundPolicy extends StatefulWidget {
  const RefundPolicy({super.key});

  @override
  State<RefundPolicy> createState() => _RefundPolicyState();
}

class _RefundPolicyState extends State<RefundPolicy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: headingBig("Refund Policy"),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          heading("OVERVIEW"),
          SizedBox(
            height: 10,
          ),
          Text("himrishtey.com believes in helping its community as far as possible !" +
              "In the instance of you chose to terminate your membership, the MEMBERSHIP FEES ARE NOT REFUNDABLE under any circumstances." +
              "The membership with himrishtey is for your personal use only and it is not transferable, and you may not authorize others to use your membership, you may not assign or transfer your membership to any person or entity.")
        ],
      ),
    );
  }
}
