import 'package:flutter/material.dart';
import 'package:calender_app/src/UI/login/otppage/otpVerify.dart' as otpVerify;

class OTPImageAndText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
          children: <Widget>[
            Image.asset(
              "assets/chat.png",
              scale: 4.5,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Enter OTP sent to you at:  ",
              style: TextStyle(fontFamily: "Poppins-Medium", fontSize: 18),
            ),
            Row(
              children: <Widget>[
                Text(
                  "${otpVerify.phoneNo}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Poppins-Medium",
                    fontSize: 23,
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
