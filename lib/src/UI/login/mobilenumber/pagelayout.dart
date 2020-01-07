import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
import 'package:calender_app/src/UI/login/mobilenumber/button.dart';
import 'package:calender_app/src/UI/login/mobilenumber/disclaimer.dart';
import 'package:calender_app/src/UI/login/mobilenumber/imageandtext.dart';
import 'package:calender_app/src/UI/login/mobilenumber/textfield.dart';
// import 'package:washle1/src/bloc/mobileNumberBloc.dart';

String phoneNo;

String areaCode = "+91";
TextEditingController phoneNoController = TextEditingController();
GlobalKey<FormState> formKey = GlobalKey<FormState>();

class MobileNumberPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    phoneNo = areaCode + phoneNoController.text;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body:
          //ChangeNotifierProvider<PhoneBloc>.value(
          // value: PhoneBloc(),
          //child:
          Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          ImageAndText(),
          // SizedBox(
          //   height: MediaQuery.of(context).size.height * 0.06,
          // ),
          MobileNumberTextfield(),
          // SizedBox(
          //   height: MediaQuery.of(context).size.height * 0.06,
          // ),
          MobileNumberSubmitButton(),
          // SizedBox(
          //   height: MediaQuery.of(context).size.height * 0.06,
          // ),
          Disclaimer(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          // Spacer(
          //   flex: 1,
          // ),
          // SizedBox(
          //   height: 15,
          // ),
        ],
      ),
      // ),
    );
  }
}
