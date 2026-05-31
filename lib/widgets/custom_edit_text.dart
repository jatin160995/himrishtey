import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/common.dart';

class CustomEditText extends StatefulWidget {
  bool isActive;
  TextEditingController textEditingController;
  double fontSize;
  TextInputType textInputType;
  String placeholder;
  FontWeight fontWeight;
  Color backgroundColor;
  bool isPassword;
  int length;
  CustomEditText(this.isActive, this.fontSize, this.textEditingController,
      this.textInputType, this.placeholder,
      {this.fontWeight = FontWeight.normal,
      this.backgroundColor = const Color(0xFFF1F1F1),
      this.isPassword = false,
      this.length = 1000});

  @override
  State<CustomEditText> createState() => _CustomEditTextState();
}

class _CustomEditTextState extends State<CustomEditText> {
  @override
  Widget build(BuildContext context) {
    return Container(
      //width: MediaQuery.of(context).size.width * 0.75,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      padding: EdgeInsets.all(12),
      child: CupertinoTextField(
        obscureText: widget.isPassword,
        enabled: widget.isActive,
        keyboardType: widget.textInputType,
        controller: widget.textEditingController,
        maxLength: widget.length,
        inputFormatters: <TextInputFormatter>[
          widget.placeholder == "Full Name"
              ? UpperCaseTextFormatter()
              : TextInputFormatter.withFunction(
                  (oldValue, newValue) => newValue)
        ],
        onChanged: (t) {
          //validateEmail(t);
        },
        placeholderStyle: TextStyle(
            color: textLightest(),
            fontSize: widget.fontSize,
            fontWeight: widget.fontWeight,
            fontFamily: "poppins"),
        placeholder: widget.placeholder,
        padding: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          border: Border.all(color: transparent),
          color: transparent,
        ),
        style: TextStyle(
            fontSize: widget.fontSize,
            fontWeight: widget.fontWeight,
            fontFamily: "poppins",
            color: textDark()),
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: capitalize(newValue.text),
      selection: newValue.selection,
    );
  }
}

String capitalize(String value) {
  if (value.trim().isEmpty) return "";
  var tem = value.split(" ");
  List finalValues = [];
  for (var temp in tem) {
    finalValues.add(temp.capitalize());
  }
  print(finalValues);

  return finalValues.join(" ");
}
