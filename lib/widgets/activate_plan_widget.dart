import 'package:flutter/material.dart';
import 'package:himrishtey/controllers/user_controller.dart';
import 'package:himrishtey/screens/membership/membership_plans.dart';
import 'package:himrishtey/utils/common.dart';
import 'package:himrishtey/widgets/loader.dart';

class ActivatePlanWidget extends StatefulWidget {
  const ActivatePlanWidget({super.key});

  @override
  State<ActivatePlanWidget> createState() => _ActivatePlanWidgetState();
}

class _ActivatePlanWidgetState extends State<ActivatePlanWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: isLoading
            ? Loader()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  heading("Plans"),
                  SizedBox(
                    height: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: planWidgets(),
                  )
                ],
              ),
      ),
    );
  }

  List<Widget> planWidgets() {
    List<Widget> widgets = [];
    for (int i = 0; i < data.length; i++) {
      widgets.add(
        GestureDetector(
          onTap: () {
            // showToast("message");
            //  planDetailDialog(data[i]);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MembershipPlans(data[i])),
            );
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(15),
            margin: EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
              gradient: LinearGradient(
                  colors: [
                    const Color(0xFFf3f3f3),
                    Color.fromARGB(255, 251, 245, 225),
                  ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data[i]['membership_name'],
                  style: TextStyle(
                      color: textDark(),
                      fontWeight: FontWeight.bold,
                      fontSize: 22),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  data[i]['plan_description'],
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: textLightest(),
                      fontWeight: FontWeight.normal,
                      fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return widgets;
  }

  UserController userController = new UserController();
  bool isLoading = true;
  List data = [];
  getPlans() async {
    loadingState(true);
    dynamic responseData = await userController.getMembership();
    if (responseData['success']) {
      data = responseData['memberships'];
      loadingState(false);
    } else {
      loadingState(false);
      showToast("Something went wrong");
    }
  }

  loadingState(bool state) {
    setState(() {
      isLoading = state;
    });
  }
}
