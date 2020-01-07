import 'package:flutter/material.dart';
import 'package:calender_app/src/UI/login/otppage/otpVerify.dart' as otpVerify;

class OTPTextfield extends StatefulWidget {
  @override
  _OTPTextfieldState createState() => _OTPTextfieldState();
}

class _OTPTextfieldState extends State<OTPTextfield> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      height: MediaQuery.of(context).size.height * 0.075,
      child: Row(
        children: <Widget>[
          Flexible(
            child: TextField(
              onChanged: (value) {
                otpVerify.smsCode = value;
                // print(otpVerify.smsCode);
              },
              style: TextStyle(
                color: Color(0xff9a9a9a),
                fontFamily: "Poppins-Medium",
              ),
              decoration: 
              InputDecoration(
                prefixIcon: Image.asset(
                  "assets/pencil_edit_button_2.png",
                  scale: 2,
                ),
                counterText: "",
                fillColor: Color(0xffefefef),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              keyboardType: TextInputType.numberWithOptions(),
            ),
          ),
        ],
      ),
    );
  }
}
