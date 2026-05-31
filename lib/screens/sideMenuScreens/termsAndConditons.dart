import 'package:flutter/material.dart';
import 'package:himrishtey/utils/common.dart';

class TermsAndConditions extends StatefulWidget {
  const TermsAndConditions({super.key});

  @override
  State<TermsAndConditions> createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: headingBig("Terms & Conditions"),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          heading("Overview"),
          SizedBox(
            height: 10,
          ),
          Text("Here's a hearty welcome big and warm enough  to encompass  you all  your presence makes us happy and  Its our pleasure extend a cheerful welcome  " +
              "to you all at Himrishtey.com. It is a site Make a perfect match and Bond of togetherness among to  beautiful  person. This is an agreement purely legal binding  terms terms for your membership. This agreement can be modified from time to time and it may be affected by simple notice to members. All records are maintained by computer system And need not any physical or  digital signature. Any e suggestions regarding the improvement of the site is always welcome. "),
          SizedBox(
            height: 10,
          ),
          heading("Terms and Conditions"),
          Text(
              "Conditions and terms  use of Him Rishtey platform.   Its mandatory to use this site only By those who are  Eligible for marriage as per the law motu.  this site is not meant for promoting illicit  or sexual relation Any illicit relationship.   Himrishtey.com has full right to terminate  any member membership if found in any illicit  relationship without any refund.   You may leave your membership at any time by  informing himrishtey.com. in writing.    If you Terminate your membership you will not be  eligible  for any refund. Himrishtey.com  is fully entitled to terminate your membership for any  breach of agreement.  actionsite  is meant only for personal use only for subscriber the contents of site may not be used for any commercial activities.  Appropriate legal action will be taken against any illegal and unauthorised use of the site. Himrishtey site have all proprietary rights copyrights material trademark and other proprietary information. Site may delete any content messages photos profiles which is not required for any purpose . Any vulgar content will not be authorised and strict  action will be taken against defaulter. Subscriber of the site sole responsible for the content, messages, photos or any material display or share by him or her."),
          SizedBox(
            height: 10,
          ),
          heading("Acceptance of the End User License Agreement (EULA)"),
          Text(
              "By using the HimRishtey app, you acknowledge that you have read, understood, and agree to the End User License Agreement (EULA). The EULA governs the licensing of this App to you and details your rights to use the App on your device."),
        ],
      ),
    );
  }
}
