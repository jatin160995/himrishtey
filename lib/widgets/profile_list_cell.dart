import 'package:flutter/material.dart';
import 'package:himrishtey/utils/common.dart';
import 'package:himrishtey/utils/container_radius.dart';
import 'package:himrishtey/widgets/loading_image.dart';

class ProfileListCell extends StatefulWidget {
  const ProfileListCell({super.key});

  @override
  State<ProfileListCell> createState() => _ProfileListCellState();
}

class _ProfileListCellState extends State<ProfileListCell> {
  @override
  Widget build(BuildContext context) {
    return Container(
      //height: 108,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 7.5),
      decoration: borderRadius(lightBackgroundColor(), 10),
      child: Row(
        children: [],
      ),
    );
  }
}
