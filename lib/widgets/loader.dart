import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:himrishtey/utils/common.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: SpinKitWave(
        color: primaryColor,
      ),
    );
    ;
  }
}
