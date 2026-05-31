import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:himrishtey/screens/profile_detail.dart';
import 'package:himrishtey/widgets/loading_image.dart';

import '../utils/common.dart';
import '../utils/container_radius.dart';

class ProfileCell extends StatefulWidget {
  dynamic user;
  double width;
  ProfileCell(this.user, {super.key, this.width = -1});

  @override
  State<ProfileCell> createState() => _ProfileCellState();
}

class _ProfileCellState extends State<ProfileCell> {
  double width = 0;
  double height = 0;
  @override
  Widget build(BuildContext context) {
    // print(widget.user['photo'].toString().contains("member-photo")
    //     ? ("https://himrishtey.com/photos/photo/" +
    //         widget.user['photo'].toString())
    //     : widget.user['photo']);
    width = widget.width == -1
        ? MediaQuery.of(context).size.width * 0.43
        : widget.width;
    height = MediaQuery.of(context).size.width * 0.6;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfileDetail(widget.user)),
        );
      },
      child: Container(
        width: width,
        height: height,
        //padding: EdgeInsets.all(10),
        //margin: EdgeInsets.only(right: 14),
        decoration: borderRadius(white, 8),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Container(
              height: height,
              width: width,
              child: LoadingImage(
                  widget.user['photo'].toString().contains("member-photo")
                      ? (imageUrlPrefix() + widget.user['photo'].toString())
                      : widget.user['photo']),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                        width: width,
                        padding: EdgeInsets.all(7),
                        height: 75,
                        decoration: BoxDecoration(color: Color(0xa0ffffff)),
                        child: Row(
                          children: [
                            Expanded(
                                flex: 7,
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            widget.user['full_name'].toString(),
                                            maxLines: 1,
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: textDark()),
                                          ),
                                          SizedBox(
                                            width: 3,
                                          ),
                                          widget.user['member_type'] == "normal"
                                              ? Container()
                                              : Icon(
                                                  Icons.verified,
                                                  color: Colors.blue,
                                                  size: 20,
                                                )
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(widget.user['profile_id'],
                                              maxLines: 1,
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.normal,
                                                  color: textMedium())),
                                          Text(
                                              widget.user['age_years']
                                                      .toString() +
                                                  " | " +
                                                  widget.user['height'],
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  fontFamily: "medium",
                                                  color: textMedium())),
                                        ],
                                      ),
                                      Text(
                                          widget.user['religion'] +
                                              " | " +
                                              widget.user['cast'],
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(
                                              fontSize: 12.5,
                                              fontWeight: FontWeight.normal,
                                              color: textLightest())),
                                    ],
                                  ),
                                )),
                            /* Expanded(
                                flex: 3,
                                child: Container(
                                  decoration: borderRadius(transparent, 40),
                                )),*/
                          ],
                        )),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
