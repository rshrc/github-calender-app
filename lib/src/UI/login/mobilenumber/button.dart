import 'package:calender_app/src/style/theme.dart';
import 'package:flutter/material.dart';
import 'package:calender_app/src/UI/login/otppage/otpVerify.dart';
import 'package:calender_app/src/UI/login/otppage/pagelayout.dart';
import 'package:calender_app/src/UI/login/mobilenumber/pagelayout.dart' as pageLayout;

class MobileNumberSubmitButton extends StatefulWidget {
  @override
  _MobileNumberSubmitButtonState createState() =>
      _MobileNumberSubmitButtonState();
}

class _MobileNumberSubmitButtonState extends State<MobileNumberSubmitButton> {
  validAndSubmit() {
    var form = pageLayout.formKey.currentState;
    // print("form ${form}");
    if (form.validate()) {
      form.save();

      verifyPhone(context);
      // // print("phonenumber 3: $phoneNo");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => OTPPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.45,
      height: MediaQuery.of(context).size.height * 0.07,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        color: Style.secondaryColor,
        onPressed: validAndSubmit,
        child: Text(
          "Get OTP",
          style: TextStyle(
            fontSize: 18,
            fontFamily: "Poppins-Medium",
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
