import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:calender_app/src/UI/login/mobilenumber/pagelayout.dart'
    as phonePage;

import 'pagelayout.dart';

String phoneNo = phonePage.areaCode + phonePage.phoneNoController.text;
String smsCode;
String verificationId;
int resendCode;
final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
  verificationId = verId;
  print("auto000000000 retreive working");
};

final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
  verificationId = verId;
  resendCode = forceCodeResend;

  OTPPage();
  // smsCodeDialog(context).then((value) {
  //   // print("Signed In");
  // });
};

final PhoneVerificationCompleted verifiedSuccess = (AuthCredential credential) {
  print('Verified');
};

final PhoneVerificationFailed veriFailed = (AuthException exception) {
  print("verified failed");
  // print(exception.message.toString());
};

Future<void> verifyPhone(BuildContext context) async {
  phoneNo = phonePage.areaCode + phonePage.phoneNoController.text;
  // print(phoneNo);

  print("Verify otp working $phoneNo");

  await FirebaseAuth.instance.verifyPhoneNumber(
    phoneNumber: phoneNo,
    codeAutoRetrievalTimeout: autoRetrieve,
    codeSent: smsCodeSent,
    timeout: const Duration(seconds: 5),
    verificationCompleted: verifiedSuccess,
    verificationFailed: veriFailed,
  );
}

Future<void> resendOtp() async {
  phoneNo = phonePage.areaCode + phonePage.phoneNoController.text;

  print("resend otp working $phoneNo");
  print("resend otp working $resendCode");

  await FirebaseAuth.instance.verifyPhoneNumber(
    phoneNumber: phoneNo,
    timeout: const Duration(seconds: 5),
    verificationCompleted: verifiedSuccess,
    verificationFailed: veriFailed,
    codeSent: smsCodeSent,
    forceResendingToken: resendCode,
    codeAutoRetrievalTimeout: autoRetrieve,
  );
}
