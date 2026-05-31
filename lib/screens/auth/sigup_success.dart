import 'package:flutter/material.dart';
import 'package:himrishtey/screens/auth/login.dart';
import 'package:himrishtey/screens/dashboard.dart';
import 'package:himrishtey/utils/common.dart';
import 'package:himrishtey/utils/container_radius.dart';

class SignupSuccess extends StatefulWidget {
  const SignupSuccess({super.key});

  @override
  State<SignupSuccess> createState() => _SignupSuccessState();
}

class _SignupSuccessState extends State<SignupSuccess> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.blue, Colors.indigo],
          )),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.done,
                      size: 100,
                      color: white,
                    ),
                    Text(
                      "Cogratulations",
                      style: TextStyle(
                          color: white,
                          fontWeight: FontWeight.bold,
                          fontSize: 28),
                    ),
                    Text(
                      "You are now member of HimRishtey family.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: white,
                          fontWeight: FontWeight.normal,
                          fontSize: 15),
                    )
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.only(bottom: 40),
                  decoration: borderRadius(white, 8),
                  width: 200,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context)
                          .popUntil(ModalRoute.withName('/dashboard'));
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Dashboard()),
                      );
                      // Navigator.pushReplacement(context,
                      //     MaterialPageRoute(builder: (context) => Dashboard()));
                    },
                    child: Text(
                      "Explore",
                      style: TextStyle(
                          color: Colors.indigo,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }
}
