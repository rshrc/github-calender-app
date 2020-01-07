import 'package:calender_app/src/UI/login/mobilenumber/pagelayout.dart';
import 'package:calender_app/src/UI/state/pageLayout.dart';
import 'package:calender_app/src/style/theme.dart';
import 'package:flutter/material.dart';

class GetStartedButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: RaisedButton(
        elevation: 0,
        color: Style.secondaryColor,
        onPressed: () => Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context) => StatePage()),
          (Route<dynamic> route) => false,
        ),
        child: Text(
          "GET STARTED",
          style: TextStyle(color: Colors.white),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
      width: 230,
      height: 60,
    );
  }
}
