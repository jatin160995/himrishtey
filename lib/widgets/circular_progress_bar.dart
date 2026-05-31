import 'package:circular_seek_bar/circular_seek_bar.dart';
import 'package:flutter/material.dart';
import 'package:himrishtey/utils/common.dart';

class CircularProgress extends StatelessWidget {
  dynamic value;
  CircularProgress(this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 80,
        child: Stack(
          children: [
            CircularSeekBar(
              width: double.infinity,
              height: 80,
              progress: double.parse(value.toString()),
              barWidth: 8,
              startAngle: 45,
              sweepAngle: 270,
              strokeCap: StrokeCap.round,
              progressGradientColors: const [
                primaryAccent,
                secondryColor,
                primaryColor,
              ],
              animation: true,
              interactive: false,
            ),
            Align(
              alignment: Alignment.center,
              child: heading(value.toString() + "%"),
            )
          ],
        ));
    ;
  }
}
