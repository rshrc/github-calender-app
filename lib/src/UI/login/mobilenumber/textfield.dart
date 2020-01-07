import 'package:calender_app/src/functions/validator.dart';
import 'package:flutter/material.dart';

import 'package:calender_app/src/UI/login/mobilenumber/pagelayout.dart' as pageLayout;

class MobileNumberTextfield extends StatefulWidget {
  @override
  _MobileNumberTextfieldState createState() => _MobileNumberTextfieldState();
}

class _MobileNumberTextfieldState extends State<MobileNumberTextfield> {
  @override
  Widget build(BuildContext context) {
    // final PhoneBloc phoneBloc = Provider.of<PhoneBloc>(context);

    return Container(
      // color: Colors.red,
      width: MediaQuery.of(context).size.width * 0.85,
      // height: MediaQuery.of(context).size.height * 0.075,
      child: Row(
        children: <Widget>[
          Flexible(
            child: Form(
              key: pageLayout.formKey,
              child: TextFormField(
                // controller: phoneBloc.phone,

                controller: pageLayout.phoneNoController,

                onSaved: (value) {
                  pageLayout.phoneNo = pageLayout.areaCode + value;
                },
                validator: (value) => validatePhone(
                      value,
                    ),
                // onEditingComplete: (value)=>phoneBloc.phone.text = value,
                style: TextStyle(
                  color: Color(0xff9a9a9a),
                  fontFamily: "Poppins-Medium",
                ),
                decoration: InputDecoration(
                  prefixIcon: Image.asset(
                    "assets/phone_receiver.png",
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
                maxLength: 10,
              ),
            ),
          ),
          // Text(
          //   phoneBloc.phone?.text??"nm",
          // ),
        ],
      ),
    );
  }
}
