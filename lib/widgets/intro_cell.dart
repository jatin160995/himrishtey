import 'package:flutter/material.dart';
import 'package:himrishtey/utils/common.dart';

class IntroCell extends StatelessWidget {
  String image;
  String heading;
  String text;
  IntroCell(this.image, this.heading, this.text);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft:
                    Radius.circular(MediaQuery.of(context).size.width * .3),
                bottomRight:
                    Radius.circular(MediaQuery.of(context).size.width * .3)),
            color: Colors.white,
          ),
          height: MediaQuery.of(context).size.height * .6,
          width: MediaQuery.of(context).size.width,
          child: Image.asset(
            image,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          margin: EdgeInsets.all(20),
          child: Column(children: [
            Text(
              heading,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: textDark(), fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: textMedium(),
                  fontSize: 14,
                  fontWeight: FontWeight.normal),
            ),
          ]),
        )
      ],
    );
  }
}
