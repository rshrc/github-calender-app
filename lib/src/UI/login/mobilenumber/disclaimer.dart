import 'package:calender_app/src/functions/url.dart';
import 'package:calender_app/src/style/theme.dart';
import 'package:flutter/material.dart';


class Disclaimer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "By continuing you agree to the ",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
             GestureDetector(
              onTap: () => privacyPolicy(),
              child: Text(
                "Privacy Policy",
                style: TextStyle(
                  fontSize: 12,
                  color: Style.secondaryColor,
                ),
              ),
            ),
            // GestureDetector(
            //   child: Text(
            //     "End User Agreement",
            //     style: TextStyle(
            //       color: Style.secondaryColor,
            //       fontSize: 12,
            //     ),
            //   ),
            //   onTap: () => Navigator.of(context).push(
            //     MaterialPageRoute(
            //       builder: (context) => PrivacyPolicy(),
            //     ),
            //   ),
            // ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            
           
            Text(
              " of ",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            Text(
              "Calendar 365",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        )
      ],
    );
  }
}
