import 'package:flutter/material.dart';

import 'common.dart';

defaultGradient() {
  return BoxDecoration(
      gradient: LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [primaryColor, secondryColor],
  ));
}
