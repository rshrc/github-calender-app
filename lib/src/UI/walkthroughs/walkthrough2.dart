import 'package:calender_app/src/UI/login/mobilenumber/pagelayout.dart';
import 'package:calender_app/src/UI/state/pageLayout.dart';
import 'package:calender_app/src/style/theme.dart';
import 'package:flutter/material.dart';

class WalkThrough2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.075, right: 15),
          height: MediaQuery.of(context).size.height * 0.045,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FlatButton(
                textColor:  Style.secondaryColor,
                child: Text(
                  "SKIP",
                  style: TextStyle(fontSize: 22),
                ),
                onPressed: () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              StatePage(),),
                      (Route<dynamic> route) => false,
                    ),
              )
            ],
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                "assets/walk2.png",
              ),
              SizedBox(
                height: 25,
              ),
              Text(
                "Mark Your Personal \nTask and Set Reminder",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Roboto-Medium",
                  fontSize: 22,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
