import 'package:calender_app/src/UI/profile/profile.dart';
import 'package:calender_app/src/UI/state/pageLayout.dart';
import 'package:calender_app/src/functions/common.dart' as c;
import 'package:calender_app/src/functions/saveState.dart';

import 'package:calender_app/src/style/theme.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

import '../calender/calender1.dart' as calender;

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

String appName;
String packageName;
String version;
String buildNumber;
String state;

class _SettingPageState extends State<SettingPage> {
  bool val = c.theme == 0 ? false : true;
  platformInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    appName = packageInfo.appName;
    packageName = packageInfo.packageName;
    version = packageInfo.version;
    buildNumber = packageInfo.buildNumber;
    c.theme = await getColor();
    val = c.theme == 0 ? false : true;
  }

  getStateHere() async {
    try {
      state = await getState();
    } catch (e) {} finally {
      setState(() {
        state = state;
      });
    }
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    platformInfo();
    getStateHere();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          c.theme == 0 ? Style.backgreyColor : Style.backInvertGreyColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Calendar",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Style.primaryColor,
            // color:
            //     c.theme == 1 ? Style.primaryColor : Style.invertPrimaryColor,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            return Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Style.primaryColor,
          ),
        ),
      ),
      body: Container(
        // color: CupertinoColors.activeBlue,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              firstContainer(),
              Container(
                height: 10,
              ),
              secondContainer(),
              // Container(
              //   height: 10,
              // ),
              // thirdContainer(),
              Container(
                height: 10,
              ),
              fourthContainer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget fourthContainer() {
    return Container(
      color: c.theme == 0 ? Style.primaryColor : Style.invertPrimaryColor,
      padding: EdgeInsets.only(
        left: c.cWidth * 0.02,
      ),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              "ADDITIONAL",
              style: TextStyle(
                color: c.theme == 1
                    ? Style.primaryColor
                    : Style.invertPrimaryColor,
              ),
            ),
          ),
          Divider(
            height: 5,
            color: c.theme == 1 ? Style.greyColor : Style.invertGreyColor,
            indent: c.cWidth * 0.04,
          ),
          ListTile(
            title: Text(
              "About",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: c.theme == 1
                    ? Style.primaryColor
                    : Style.invertPrimaryColor,
              ),
            ),
            trailing: Text(
              "Version: $version",
              style: TextStyle(
                color: c.theme == 1
                    ? Style.primaryColor
                    : Style.invertPrimaryColor,
              ),
            ),
          ),
          // Divider(
          //   height: 5,
          //   color: c.theme == 1 ? Style.greyColor : Style.invertGreyColor,
          //   indent: c.cWidth * 0.04,
          // ),
          // ListTile(
          //   onTap: () {
          //     bool login = calender.uid == null ? true : false;

          //     calender.uid = null;
          //     return login
          //         ? Navigator.of(context).pushNamedAndRemoveUntil(
          //             '/loginPage',
          //             (Route<dynamic> route) => false,
          //           )
          //         : FirebaseAuth.instance.signOut().then((action) {
          //             print("action here si ");
          //             Navigator.of(context)
          //                 .pushReplacementNamed('/calenderApp');
          //           }).catchError((e) {
          //             // print(e);
          //           });
          //   },
          //   title: Text(
          //     calender.uid == null ? "LogIn / SignUp" : "LogOut",
          //     style: TextStyle(
          //       fontSize: 17,
          //       fontWeight: FontWeight.w500,
          //       color: c.theme == 1
          //           ? Style.primaryColor
          //           : Style.invertPrimaryColor,
          //     ),
          //   ),
          //   // trailing: Text(
          //   //   "Version: $version",
          //   //   style: TextStyle(
          //   //     color: c.theme == 1
          //   //         ? Style.primaryColor
          //   //         : Style.invertPrimaryColor,
          //   //   ),
          //   // ),
          // ),
        ],
      ),
    );
  }

  Widget thirdContainer() {
    return Container(
      color: c.theme == 0 ? Style.primaryColor : Style.invertPrimaryColor,
      padding: EdgeInsets.only(
        left: c.cWidth * 0.02,
      ),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              "REMINDERS",
              style: TextStyle(
                color: c.theme == 1
                    ? Style.primaryColor
                    : Style.invertPrimaryColor,
              ),
            ),
          ),
          Divider(
            height: 5,
            color: c.theme == 1 ? Style.greyColor : Style.invertGreyColor,
            indent: c.cWidth * 0.04,
          ),
          ListTile(
            title: Text(
              "Reminders",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: c.theme == 1
                    ? Style.primaryColor
                    : Style.invertPrimaryColor,
              ),
            ),
            trailing: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.navigate_next,
                color: c.theme == 1
                    ? Style.primaryColor
                    : Style.invertPrimaryColor,
              ),
            ),
          ),
          Divider(
            height: 5,
            color: c.theme == 1 ? Style.greyColor : Style.invertGreyColor,
            indent: c.cWidth * 0.04,
          ),
          ListTile(
            title: Text(
              "Default Reminder Time",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: c.theme == 1
                    ? Style.primaryColor
                    : Style.invertPrimaryColor,
              ),
            ),
            trailing: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.navigate_next,
                color: c.theme == 1
                    ? Style.primaryColor
                    : Style.invertPrimaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget secondContainer() {
    return Container(
      color: c.theme == 0 ? Style.primaryColor : Style.invertPrimaryColor,
      padding: EdgeInsets.only(
        left: c.cWidth * 0.02,
      ),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              "GENERAL",
              style: TextStyle(
                color: c.theme == 1
                    ? Style.primaryColor
                    : Style.invertPrimaryColor,
              ),
            ),
          ),
          Divider(
            height: 5,
            color: c.theme == 1 ? Style.greyColor : Style.invertGreyColor,
            indent: c.cWidth * 0.04,
          ),
          ListTile(
            title: Text(
              "Dark Mode",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: c.theme == 1
                    ? Style.primaryColor
                    : Style.invertPrimaryColor,
              ),
            ),
            trailing: Switch.adaptive(
              value: val,
              onChanged: (bool newValue) async {
                print("newValue here is $newValue");
                setState(() {
                  val = newValue;
                });
                c.theme = val ? 1 : 0;
                await saveColor(c.theme);
                await calender.markHoliday(calender.holidayDateMap, true);
              },
            ),
          ),
          Divider(
            height: 5,
            color: c.theme == 1 ? Style.greyColor : Style.invertGreyColor,
            indent: c.cWidth * 0.04,
          ),
          ListTile(
            onTap: () {
              return Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => StatePage(),
                ),
              );
            },
            title: Text(
              "Change State",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: c.theme == 1
                    ? Style.primaryColor
                    : Style.invertPrimaryColor,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  state ?? "",
                  style: TextStyle(
                    fontSize: 17,
                    color: c.theme == 1
                        ? Style.primaryColor
                        : Style.invertPrimaryColor,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    return Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => StatePage(),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.navigate_next,
                    color: c.theme == 1
                        ? Style.primaryColor
                        : Style.invertPrimaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget firstContainer() {
    return Container(
      color: c.theme == 0 ? Style.primaryColor : Style.invertPrimaryColor,
      padding: EdgeInsets.only(
        left: c.cWidth * 0.02,
      ),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              "ACCOUNTS",
              style: TextStyle(
                color: c.theme == 1
                    ? Style.primaryColor
                    : Style.invertPrimaryColor,
              ),
            ),
          ),
          Divider(
            height: 5,
            // color: ThemeData.,

            color: c.theme == 1 ? Style.greyColor : Style.invertGreyColor,
            indent: c.cWidth * 0.04,
          ),
          ListTile(
            onTap: () {
              return Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EditProfile(),
                ),
              );
            },
            title: Text(
              "Calendar Account",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: c.theme == 1
                    ? Style.primaryColor
                    : Style.invertPrimaryColor,
              ),
            ),
            trailing: IconButton(
              onPressed: () {
                return Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EditProfile(),
                  ),
                );
              },
              icon: Icon(
                Icons.navigate_next,
                color: c.theme == 1
                    ? Style.primaryColor
                    : Style.invertPrimaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
