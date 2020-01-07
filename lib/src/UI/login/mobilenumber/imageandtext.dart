import 'package:calender_app/src/style/theme.dart';
import 'package:flutter/material.dart';

class ImageAndText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
          children: <Widget>[
            Image.asset(
              "assets/smartphone_1.png",
              scale: 4.5,
            ),SizedBox(height: 20,),
            Text(
              "Lets get started",
              style: TextStyle(
                fontFamily: "Poppins-Medium",fontSize: 18
              ),
            ),SizedBox(height: 20,),
            Row(
              children: <Widget>[
                Text(
                  "Enter Your ",
                  style: TextStyle(
                    fontFamily: "Roboto-Medium",
                    fontSize: 23,
                  ),
                ),
                Text(
                  "Mobile Number",
                  style: TextStyle(
                    fontFamily: "Poppins-Medium",
                    fontSize: 23,
        color: Style.secondaryColor,
                  ),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }
}
