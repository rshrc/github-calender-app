import 'package:calender_app/src/UI/walkthroughs/getstartedbutton.dart';
import 'package:flutter/material.dart';
import 'package:calender_app/src/UI/login/mobilenumber/pagelayout.dart';

class WalkThrough3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          "assets/walk3.png",
        ),
        SizedBox(
          height: 25,
        ),
        Text(
          "Manage Your Official \nTrip Expensis",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: "Roboto-Medium",
            fontSize: 22,
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.07,
        ),
        GetStartedButton()
      ],
    );
  }
}
