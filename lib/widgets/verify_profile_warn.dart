import 'package:flutter/material.dart';
import 'package:himrishtey/screens/auth/otp_login.dart';
import 'package:himrishtey/utils/common.dart';
import 'package:himrishtey/utils/container_radius.dart';

class VerifyProfileWarn extends StatelessWidget {
  const VerifyProfileWarn({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      decoration: borderRadius(lightBackgroundColor(), 8),
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.verified_rounded,
                color: Colors.blue,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Verify your profile",
                style: TextStyle(
                    color: textDark(),
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            "If you want to show your profile as trusted profile, please verify your profile.",
            style: TextStyle(color: textMedium(), fontSize: 14),
          )
        ],
      ),
    );
  }
}
