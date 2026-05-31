import 'package:flutter/material.dart';

borderRadius(
  Color backgroundColor,
  double radius,
) {
  return BoxDecoration(
    color: backgroundColor,
    borderRadius: BorderRadius.all(
      Radius.circular(radius),
    ),
  );
}
