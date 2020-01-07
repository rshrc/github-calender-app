import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'login/mobilenumber/pagelayout.dart';

signInDialog(
  BuildContext context,
  String title,
  String message,
) {
  return showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            CupertinoButton(
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: CupertinoColors.destructiveRed,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            CupertinoButton(
              child: Text(
                "Sign-In",
                style: TextStyle(
                  color: CupertinoColors.activeBlue,
                ),
              ),
              // color: CupertinoColors.activeBlue,
              onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => MobileNumberPage(),
                ),
                (Route<dynamic> route) => false,
              ),
            ),
          ],
        );
      });
}
