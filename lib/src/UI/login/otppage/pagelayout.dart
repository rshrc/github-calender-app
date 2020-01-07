import 'package:flutter/material.dart';
import 'package:calender_app/src/UI/login/otppage/button.dart';
import 'package:calender_app/src/UI/login/mobilenumber/disclaimer.dart';
import 'package:calender_app/src/UI/login/otppage/imageandtext.dart';
import 'package:calender_app/src/UI/login/otppage/otpVerify.dart';
import 'package:calender_app/src/UI/login/otppage/textfield.dart';
import 'package:calender_app/src/UI/login/mobilenumber/pagelayout.dart'
    as phonePage;

class OTPPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.08,
          ),
          OTPImageAndText(),
          OTPTextfield(),
          OTPSubmitButton(),
          resend(
            context,
          ),
          Disclaimer(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ),
    );
  }

  Widget resend(BuildContext context) {
    return Container(
      // height: MediaQuery.of(context).size.height * 0.1,
      // color: Color(0xff0077b5),
      child: Column(
        children: <Widget>[
          // SizedBox(
          //   height: 40,
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Did you not get your OTP?",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Poppins-Regular",
                  fontSize: 17,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                padding: EdgeInsets.all(0),
                onPressed: () => resendOtp(),
                child: Text(
                  "Resend OTP   ",
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Poppins-Regular",
                    fontSize: 17,
                  ),
                ),
              ),
              Text(
                "|",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Poppins-Regular",
                  fontSize: 20,
                ),
              ),
              FlatButton(
                padding: EdgeInsets.all(0),
                onPressed: () {
                  phonePage.phoneNoController.text = "";
                  return Navigator.of(context).pop();
                },
                child: Text(
                  "   Change Number",
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Poppins-Regular",
                    fontSize: 17,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
