import 'package:calender_app/main.dart';
import 'package:calender_app/src/UI/login/mobilenumber/disclaimer.dart';
import 'package:calender_app/src/functions/common.dart';
import 'package:calender_app/src/functions/errorHandling.dart';
import 'package:calender_app/src/functions/validator.dart';
import 'package:calender_app/src/style/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  DatabaseReference _database;
  String uid;
  bool submit = false;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _nameFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _emailFormKey = GlobalKey<FormState>();
  void _handleSubmit(BuildContext context) {
    final FormState form1 = _nameFormKey.currentState;
    final FormState form2 = _emailFormKey.currentState;
    // print("checkiiin here");

    // // print("item Email: ${item.profile.email}");
    if (form1.validate() && form2.validate()) {
      form1.save();
      form2.save();
      setState(() {
        submit = true;
      });

      FirebaseAuth.instance.currentUser().then((user) {
        // // print("user $user");
        // // print("uid ${user.uid}");
        uid = user.uid;
        String phoneNo = user.phoneNumber;
        // print("carType here is : $carType");

        Map<String, dynamic> data = {
          "phoneNo": phoneNo,
          "uid": uid,
          "fName": _nameController.text,
          "email": _emailController.text,
        };
        _database = FirebaseDatabase.instance.reference().child('user');
        _database.child(uid).set(data).then((value) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/calenderApp',
            (Route<dynamic> route) => false,
          );
        }).catchError((e) {
          setState(() {
            submit = false;
          });
          return errorDialog(
            context,
            "Error",
            "Invalid data",
          );
        });
      }).catchError((e) {
        setState(() {
          submit = true;
        });
        return errorDialog(
          context,
          "Error",
          "Invalid data",
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
          height: cHeight,
          padding: EdgeInsets.symmetric(
            vertical: 40,
            horizontal: 50,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // Spacer(
              //   flex: 1,
              // ),
              Padding(
                padding: EdgeInsets.only(top: 10),
              ),
              Column(
                children: <Widget>[
                  topWidget(),
                  Padding(
                    padding: EdgeInsets.only(bottom: 30),
                  ),
                  imageWidget(),
                  Padding(
                    padding: EdgeInsets.only(bottom: 50),
                  ),
                  Form(
                    key: _nameFormKey,
                    child: TextFormField(
                      style: TextStyle(color: Style.secondaryColor),
                      validator: (val) => val == "" ? val : null,
                      controller: _nameController,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                        hintText: 'Full Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        labelText: 'Full Name*',
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 30),
                  ),
                  // Spacer(
                  //   flex: 1,
                  // ),
                  Form(
                    key: _emailFormKey,
                    child: TextFormField(
                      style: TextStyle(color: Style.secondaryColor),
                      controller: _emailController,
                      validator: (email) {
                        return validateEmail(email);
                      },
                      // autovalidate: true,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                        hintText: 'Email-Id',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        labelText: 'Email-Id',
                      ),
                    ),
                  ),
                ],
              ),
              // Spacer(
              //   flex: 1,
              // ),
              // Padding(
              //   padding: EdgeInsets.only(bottom: 10),
              // ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.45,
                height: 60,
                child: submit
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        // color: Color(0xff0077b5),
                        color: Style.secondaryColor,
                        onPressed: () {
                          return _handleSubmit(context);
                        },
                        child: Text(
                          "Register",
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: "Poppins-Medium",
                            color: Colors.white,
                          ),
                        ),
                      ),
              ),
              Disclaimer(),

              Padding(
                padding: EdgeInsets.only(bottom: 10),
              ),
              // Spacer(
              //   flex: 5,
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget imageWidget() {
    return Image.asset(
      "assets/detail.png",
      // scale: 1.2,
    );
  }

  Widget topWidget() {
    return Container(
      child: RichText(
          text: TextSpan(
              text: 'Please Enter Your ',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 20,
              ),
              children: <TextSpan>[
            TextSpan(
              text: 'Details',
              style: TextStyle(
                color: Style.secondaryColor,
                fontSize: 20,
              ),
            ),
          ])),
    );
  }
}
