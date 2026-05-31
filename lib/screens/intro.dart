import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:himrishtey/controllers/get_values.dart';
import 'package:himrishtey/screens/auth/login.dart';
import 'package:himrishtey/screens/auth/profile_for.dart';
import 'package:himrishtey/screens/auth/signup/signup.dart';
import 'package:himrishtey/utils/common.dart';
import 'package:himrishtey/utils/default_gradient.dart';
import 'package:himrishtey/widgets/intro_cell.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  List<Widget> crslList = [
    IntroCell('assets/images/mrg-1.jpg', 'Choose from verified profiles',
        'No more worrying about getting catfished!'),
    IntroCell('assets/images/mrg-2.jpg', 'Match with the person you want',
        'No more worrying about not being compatible!'),
    IntroCell('assets/images/mrg-3.jpg', 'Find the one who will make you happy',
        'No more worrying about finding the partner you deserve!'),
  ];

  GetValues getValues = new GetValues();

  @override
  void initState() {
    getValues.getallValues();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor(),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                //height: MediaQuery.of(context).size.height * .6,
                child: CarouselSlider(
                    items: crslList,
                    options: CarouselOptions(
                      height: MediaQuery.of(context).size.height * .8,
                      //aspectRatio: 16 / 9,
                      viewportFraction: 1,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 5),
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      //enlargeCenterPage: true,
                      //enlargeFactor: 0.3,
                      onPageChanged: (index, reason) {
                        setState(() {});
                      },
                      scrollDirection: Axis.horizontal,
                    )),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width: 130,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: backgroundColor()),
                      child: TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfileFor()),
                            );
                          },
                          child: Text(
                            "Signup",
                            style: TextStyle(
                                color: textDark(),
                                fontSize: 16,
                                fontFamily: 'medium'),
                          ))),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                      width: 130,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [primaryColor, secondryColor],
                          )),
                      child: TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => Login()),
                            );
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(
                                color: white,
                                fontSize: 16,
                                fontFamily: 'medium'),
                          )))
                ],
              )
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                margin: EdgeInsets.only(bottom: 20),
                height: 30,
                child: Image.asset(
                  icon,
                  color: primaryColorPlaceholder,
                )),
          )
        ],
      ),
    );
  }
}
