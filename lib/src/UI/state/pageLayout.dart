// import 'package:calender_app/src/UI/calender/calender1.dart';
import 'package:calender_app/src/functions/common.dart' as c;
import 'package:calender_app/src/functions/errorHandling.dart';
import 'package:calender_app/src/functions/saveState.dart';
import 'package:calender_app/src/style/theme.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';

// import 'package:cloud_firestore/cloud_firestore.dart';

class StatePage extends StatefulWidget {
  @override
  _StatePageState createState() => _StatePageState();
}

List<DropdownMenuItem<String>> items = List();
List<dynamic> timeSlot = List();
String timeValue;
int slot;
bool submit = false;

_handleSubmit(
  BuildContext context,
  dynamic notify,
  GlobalKey<ScaffoldState> _scaffoldKeyH,
) async {
  if (timeValue == null) {
    _scaffoldKeyH.currentState.showSnackBar(
      SnackBar(
        content: Text('Please select any one state'),
      ),
    );
    return;
  }
  submit = true;
  notify();
  try {
    await saveState(timeValue);
  } catch (e) {
    errorDialog(
      context,
      "Try Again",
      "$e error occured",
    );
  }

  submit = false;

  notify();
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(
      builder: (context) => CalenderMaterialApp(
        state: timeValue,
      ),
    ),
    (Route<dynamic> route) => false,
  );
}

Widget dataContainer(
  BuildContext context,
  dynamic notify,
) {
  return Container(
    child: StreamBuilder(
        stream: FirebaseDatabase.instance
            .reference()
            .child('state')
            .once()
            .asStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Container(
              child: Center(
                child: Text("Loading..."),
              ),
            );
          timeSlot = snapshot.data.value;
          items = timeSlot.map((value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
              ),
            );
          }).toList();

          return DropdownButton<String>(
            // icon: Icon(Icons.dehaze),

            isExpanded: true,
            // iconSize: 35,
            hint: Text(
              timeValue ?? "Choose state here",
              style: TextStyle(
                color: Style.secondaryColor,
                fontSize: 20,
              ),
            ),
            value: slot == null ? null : timeSlot[slot],
            style: TextStyle(
              color: Style.secondaryColor,
              // c.theme == 0 ? Style.primaryColor : Style.invertPrimaryColor,
              // backgroundColor: c.theme == 0
              //     ? Style.backgreyColor
              //     : Style.backInvertGreyColor,
              fontSize: 20,
            ),
            onChanged: (String newValue) {
              // setState(
              //   () {
              slot = timeSlot.indexOf(newValue);
              timeValue = newValue;
              notify();
              //   },
              // );
            },
            items: items,
          );
        }),
  );
}

class _StatePageState extends State<StatePage> {
  final GlobalKey<ScaffoldState> _scaffoldKeyH = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (c.theme == null) c.theme = 0;
    print("ctheme here is: ${c.theme}");
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          c.theme == 0 ? Style.backgreyColor : Style.backInvertGreyColor,
      key: _scaffoldKeyH,
      body:
          //dataContainer(),
          dataWidget(),
    );
  }

  refresh() {
    setState(() {});
  }

  Widget dataWidget() {
    c.cHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor:
          c.theme == 0 ? Style.backgreyColor : Style.backInvertGreyColor,
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: c.cWidth * 0.15,
        ),
        child: Column(
          children: <Widget>[
            Container(
              // height: c.cHeight * 0. ,
              padding: EdgeInsets.only(
                top: c.cHeight * 0.2,
                bottom: 15,
              ),
              // color: Colors.red,
              child: Image.asset(
                "assets/location.png",
                scale: 4.5,
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                top: 25,
                bottom: 45,
              ),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 20,
                    color: c.theme == 1
                        ? Style.primaryColor
                        : Style.invertPrimaryColor,
                  ),
                  text: 'Please select your ',
                  children: <TextSpan>[
                    TextSpan(
                      text: 'State',
                      style: TextStyle(
                        color: Style.secondaryColor,
                        fontSize: 20,
                      ),
                    )
                  ],
                ),
              ),
            ),
            dataContainer(
              context,
              refresh,
            ),
            SizedBox(
              height: 50,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.07,
              width: MediaQuery.of(context).size.width * 0.5,
              child: submit
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      color: Style.secondaryColor,
                      onPressed: () => _handleSubmit(
                        context,
                        refresh,
                        _scaffoldKeyH,
                      ),
                      child: Text(
                        "Save",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontFamily: "Poppins-Medium",
                        ),
                      ),
                    ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
