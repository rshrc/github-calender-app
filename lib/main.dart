// import 'package:admob_flutter/admob_flutter.dart';
import 'package:calender_app/src/UI/register/register.dart';
import 'package:calender_app/src/UI/state/pageLayout.dart';
import 'package:calender_app/src/UI/walkthroughs/walkthroughmanager.dart';
import 'package:calender_app/src/functions/common.dart' as c;
import 'package:calender_app/src/functions/saveFirstTime.dart';
import 'package:calender_app/src/functions/saveState.dart';
import 'package:calender_app/src/style/theme.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'src/UI/calender/calender1.dart';
import 'src/UI/login/mobilenumber/pagelayout.dart';

// import 'src/UI/calender1.dart';

// import 'package:flutter_google_map_route/map_screen.dart';
// import 'package:map_view/map_view.dart';
String appId =
// "33BE2250B43518CCDA7DE426D04EE231"
    "ca-app-pub-4776830761593608~1085456627";
String state;

void main() {
  // MobileAds.initialize("ca-app-pub-4776830761593608~1085456627");
  FirebaseAdMob.instance.initialize(appId: appId);

  // Admob.initialize(appId);
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // print("theme here is000000000000000000000 ${c.theme}");
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      // darkTheme: c.theme == 1 ? ThemeData.dark() : ThemeData.light(),
      theme: new ThemeData(
        // brightness: c.theme == 0 ? Brightness.light : Brightness.dark,
        // primaryColorBrightness:
        //     c.theme == 0 ? Brightness.light : Brightness.dark,
        // accentColorBrightness:
        //     c.theme == 0 ? Brightness.light : Brightness.dark,
        primaryColor: Style.secondaryColor,
        primaryColorDark: Style.primaryColor2,
        accentColor: Style.secondaryColor,
      ),
      home: StartApp(),
      routes: <String, WidgetBuilder>{
        '/calenderApp': (context) => CalenderMaterialApp(
              state: state,
            ),
        '/regPage': (context) => RegisterPage(),
        '/loginPage': (context) => MobileNumberPage(),
      },

      // StatePage(),
      // RegisterPage(),
    );
  }
}

class StartApp extends StatefulWidget {
  @override
  _StartAppState createState() => _StartAppState();
}

class _StartAppState extends State<StartApp> {
  bool firstTime = true;
  @override
  void initState() {
    super.initState();

    if (c.theme == null) {
      c.theme = 0;
    }

    print("StartApp Page running222222");
  }

  getData() async {
    c.theme = await getColor();
    if (c.theme == null) {
      await saveColor(0);
    }

    // print("theme here is22222222222222222222222 ${c.theme}");

    SharedPreferences preferences = await SharedPreferences.getInstance();
    firstTime = preferences.getBool('firstTime');
    saveFirstTime();
    return await getState();
  }

  @override
  Widget build(BuildContext context) {
    c.cHeight = MediaQuery.of(context).size.height;
    c.cWidth = MediaQuery.of(context).size.width;
    // print("state is888888888888888888888888888888888888ll: $state");
    // print("theme here is11111111111111111111111 ${c.theme}");
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: state != null
          ? CalenderMaterialApp(
              state: state,
            )
          : FutureBuilder(
              future: getData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    print("11111111111111111111111111");
                    return firstTime != null
                        ? StatePage()
                        : WalkThroughManager();
                  }
                  state = snapshot.data;

                  print(
                      "2222222222222222222222222222222222 $firstTime ${snapshot.data}");
                  return snapshot.data == null
                      ? firstTime != null ? StatePage() : WalkThroughManager()
                      : CalenderMaterialApp(
                          state: state,
                        );
                } else
                  return Center(
                    child: CircularProgressIndicator(),
                  );
              }),
    );
  }
}

class CalenderMaterialApp extends StatefulWidget {
  final String state;
  CalenderMaterialApp({@required this.state});
  @override
  _CalenderMaterialAppState createState() => _CalenderMaterialAppState();
}

class _CalenderMaterialAppState extends State<CalenderMaterialApp> {
  @override
  void initState() {
    super.initState();

    print("calendaerMaterial APP running 11111");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      routes: <String, WidgetBuilder>{
        '/calenderApp': (context) => CalenderMaterialApp(
              state: state,
            ),
        '/regPage': (context) => RegisterPage(),
        '/loginPage': (context) => MobileNumberPage(),
      },

      // darkTheme: c.theme == 1 ? ThemeData.dark() : ThemeData.light(),
      theme: new ThemeData(
        // brightness: c.theme == 0 ? Brightness.light : Brightness.dark,
        // primaryColorBrightness:
        //     c.theme == 0 ? Brightness.light : Brightness.dark,
        // accentColorBrightness:
        //     c.theme == 0 ? Brightness.light : Brightness.dark,
        primaryColor: Style.secondaryColor,
        primaryColorDark: Style.primaryColor2,
        accentColor: Style.secondaryColor,
      ),
      home: CalendarPage(
        state: widget.state,
      ),
      // StatePage(),
      // RegisterPage(),
    );
  }
}
