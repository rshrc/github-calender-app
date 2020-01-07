import 'package:calender_app/src/functions/errorHandling.dart';
import 'package:calender_app/src/style/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import 'otpVerify.dart' as otpVerify;

import 'package:calender_app/src/UI/login/mobilenumber/pagelayout.dart'
    as phonePage;

class OTPSubmitButton extends StatefulWidget {
  @override
  _OTPSubmitButtonState createState() => _OTPSubmitButtonState();
}

class _OTPSubmitButtonState extends State<OTPSubmitButton> {
   @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
  bool _isLoading = false;
  submitPressed() {
    DatabaseReference _database;
    var uid;
    FirebaseAuth.instance.currentUser().then(
      (user) {
        // print("userOtpbutton $user");

        final AuthCredential credential = PhoneAuthProvider.getCredential(
          verificationId: otpVerify.verificationId,
          smsCode: otpVerify.smsCode,
        );

        FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((user) async {
          phonePage.phoneNoController.text = "";
          var path = "/regPage";
          if (user != null) {
            // print("$user");
            uid = user.uid;
            // FirebaseMessaging _messaging = FirebaseMessaging();
            // // var _fcmToken;
            // _messaging.subscribeToTopic(uid).catchError((e) {
            //   // // print("errrrrrrrrrrrrrrr $e");
            // });
            _database = FirebaseDatabase.instance.reference().child('user');
            await _database.child(uid).once().then((DataSnapshot data) {
              // print("000000 ${data.key}");
              // print("0000001 ${data.value}");
              if (data.value != null) {
                path = "/calenderApp";
              }
            });
            // print("path here is-----: $path");
          }
          otpVerify.smsCode = "";
          Navigator.of(context).pushNamedAndRemoveUntil(
            path,
            (Route<dynamic> route) => false,
          );
        }).catchError((e) {
          setState(() {
            _isLoading = false;
          });
          // print(e);
          return errorDialog(
            context,
            "Error",
            "OTP not valid",
          );
        });
        // // print("signInNow");
        // }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.45,
      height: MediaQuery.of(context).size.height * 0.07,
      child: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
              ),
            )
          : RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
        color: Style.secondaryColor,
              onPressed: () {
                // print("submit button pressed");
                setState(() {
                  _isLoading = true;
                });
                // print(_isLoading);
                return submitPressed();
              },
              child: Text(
                "Submit",
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
