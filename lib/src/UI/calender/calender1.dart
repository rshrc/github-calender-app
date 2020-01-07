import 'package:calender_app/src/UI/balance/balanceCard.dart';
import 'package:calender_app/src/UI/news/newsPage.dart';
import 'package:calender_app/src/UI/wheather/wheather.dart';
import 'package:calender_app/src/resources/getWheatherApi.dart';
import 'package:calender_app/src/resources/locationFetch.dart';
import 'package:calender_app/src/resources/newsApi.dart';

import 'addEvent.dart';
import 'package:calender_app/src/UI/calenderWidget/eventCard.dart';

import 'package:calender_app/src/UI/setting/setting.dart';
import 'package:calender_app/src/UI/signInDialog.dart';
import 'package:calender_app/src/functions/common.dart' as c;
import 'package:calender_app/src/functions/errorHandling.dart';
import 'package:calender_app/src/functions/saveState.dart';
import 'package:calender_app/src/style/theme.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_database/firebase_database.dart' as database;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';

import 'package:intl/intl.dart' show DateFormat;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

// import '../widgets/helpers/drawer.dart';

class CalendarPage extends StatefulWidget {
  String state;
  CalendarPage({@required this.state});
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

dynamic data;
dynamic balance;
dynamic wheather;
String uid;
bool initLoading = false;
List holidayEventList = List();
List taskEventList = List();
List completedEventList = List();

List holidayKeyList = List();
List taskKeyList = List();
List completedKeyList = List();

List reminderValue = List();
List reminderKey = List();

Map<dynamic, dynamic> holidayDateMap = Map();
Map<dynamic, dynamic> taskDateMap = Map();
Map<dynamic, dynamic> completedDateMap = Map();

List<List<dynamic>> balanceList = List();
List<dynamic> balanceKeysList = List();
Map<dynamic, dynamic> balanceMap = Map();

EventList<Event> markedDateMap = EventList<Event>(
  events: {},
);

markDate(DateTime _currentDate2) {
  holidayEventList?.clear();
  taskEventList?.clear();
  completedEventList?.clear();

  holidayKeyList?.clear();
  taskKeyList?.clear();
  completedKeyList?.clear();
  int len = markedDateMap?.events[_currentDate2]?.length ?? 0;
  for (int i = len - 1; i >= 0; i--) {
    Event event = markedDateMap.events[_currentDate2][i];
    if (event.tag == "holiday") {
      holidayEventList.add(event.title);
      holidayKeyList.add(event.uKey);
    } else if (event.tag == "task") {
      taskEventList.add(event.title);
      taskKeyList.add(event.uKey);
    } else if (event.tag == "completed") {
      completedEventList.add(event.title);
      completedKeyList.add(event.uKey);
    }
  }
}

markHoliday(response, removeHoliday) {
  print("length prev: --------- ${markedDateMap.events.length}");
  if (removeHoliday) {
    print("removeHoliday");
    print("length prev: --------- ${markedDateMap.events}");
    Map<dynamic, dynamic> value = response; //response?.value;
    Iterable<dynamic> keys = value?.keys;
    List<dynamic> keyList = keys?.toList();
    int _len = value?.length ?? 0;

    // markedDateMap?.clear();
    for (int i = 0; i < _len; i++) {
      String key = keyList[i];

      List<dynamic> dataList = value[key];

      DateTime _date = DateTime.parse(key);

      int dataListLen = dataList?.length;
      for (int j = 0; j < dataListLen; j++) {
        // print("response00000000 dataList type is ${dataList[j]} value key is ");
        if (dataList[j] == null) continue;
        // String title = dataList[j]["title"];
        String uKey = dataList[j]['key'];
        // String tag = dataList[j]['tag'];
        // print("title is $title");

        // Event _event = Event(
        //   date: _date,
        //   title: title,
        //   icon: eventIconHoliday(_date.day.toString()),
        //   uKey: uKey,
        //   tag: tag,
        // );
        markedDateMap.getEvents(_date).removeWhere((item) => item.uKey == uKey);
      }
    }
  }

  print("length after: --------- ${markedDateMap.events.length}");
  Map<dynamic, dynamic> value = response; //response?.value;
  Iterable<dynamic> keys = value?.keys;
  List<dynamic> keyList = keys?.toList();
  int _len = value?.length ?? 0;

  // markedDateMap?.clear();
  for (int i = 0; i < _len; i++) {
    String key = keyList[i];

    List<dynamic> dataList = value[key];

    DateTime _date = DateTime.parse(key);

    int dataListLen = dataList?.length;
    for (int j = 0; j < dataListLen; j++) {
      // print("response00000000 dataList type is ${dataList[j]} value key is ");
      if (dataList[j] == null) continue;
      String title = dataList[j]["title"];
      String uKey = dataList[j]['key'];
      String tag = dataList[j]['tag'];
      bool typeGov = dataList[j]['type'] == 'government' ? true : false;
      // print("title is $title");

      Event _event = Event(
        date: _date,
        title: title,
        icon: eventIconHoliday(_date.day.toString(), typeGov),
        uKey: uKey,
        tag: tag,
      );
      markedDateMap.add(_date, _event);
    }
  }
}

Widget eventIconHoliday(
  String day,
  bool gov,
) =>
    CircleAvatar(
      backgroundColor:
          c.theme == 0 ? Style.backgreyColor : Style.backInvertGreyColor,
      child: Center(
        child: Text(
          day,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: gov ? Colors.red : CupertinoColors.activeBlue,
            fontSize: 18,
            // fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );

Widget eventIconTask = Container(
  // decoration:  BoxDecoration(
  //   color: Colors.transparent,
  //   borderRadius: BorderRadius.all(Radius.circular(1000)),
  //   border: Border.all(color: Colors.blue, width: 2.0),
  // ),
  child: Column(
    mainAxisAlignment: MainAxisAlignment.end,
    children: <Widget>[
      CircleAvatar(
        radius: 2,
        backgroundColor: Colors.blue,
      ),
    ],
  ),
  //  Icon(
  //   Icons.person,
  //   color: Colors.amber,
  // ),
);

Widget eventIconComplete = Container(
  // decoration:  BoxDecoration(
  //   color: Colors.transparent,
  //   borderRadius: BorderRadius.all(Radius.circular(1000)),
  //   border: Border.all(color: Colors.blue, width: 2.0),
  // ),
  child: Column(
    mainAxisAlignment: MainAxisAlignment.end,
    children: <Widget>[
      CircleAvatar(
        radius: 2,
        backgroundColor: Colors.green,
      ),
    ],
  ),
  //  Icon(
  //   Icons.person,
  //   color: Colors.amber,
  // ),
);

updateMap(
  String path,
  dynamic data,
) {
  // here to update the markedDateMap add and delete operation
  database.FirebaseDatabase.instance
      .reference()
      .child(path)
      .update(data)
      .then((val) {
    // print("value here is $data");
  });
}

class _CalendarPageState extends State<CalendarPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  DateTime curr = DateTime.now();
  DateTime _currentDate2;
  String _currentMonth = '';
  int ads = 0;

  CalendarCarousel _calendarCarouselNoHeader;
  refresh() {
    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future<void> _getData() async {
    print("uid here is $uid");
    if (widget.state == null) {
      widget.state = await getState();
    }
    _currentMonth = DateFormat.yMMM().format(_currentDate2);
    print("get data working");
    c.theme = await getColor();
    balanceMap?.clear();
    balanceKeysList?.clear();
    balanceList?.clear();

    // await getWheatherHere(); // remove position
    await _getReminder();
    await _getDates('holiday');

    await _getDates('task');
    await _getDates('completed');
    await markDate(_currentDate2);
    await _getBalance();
    await getNewsHere();

    ads = await getCount();

    await getWheatherHere(); // default position
  }

  Future<void> getNewsHere() async {
    data = await getNews();
    setState(() {});
  }

  getWheatherHere() async {
    String city = await getCurrentLocationUser();
    print('city here is $city');
    await getWheather(context, city).then((val) {
      setState(() {
        wheather = val;
      });
    });
  }

  // BannerAd myBanner;
  bool _adLoaded = false;
  InterstitialAd myInterstitial;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("calendaer Page running222222");

    _currentDate2 = DateTime(curr.year, curr.month, curr.day);
    _currentMonth = DateFormat.yMMM().format(_currentDate2);
    initLoading = false;

    print("getData called init");
    _getData();

    checkAd();
  }

// firebase admob
  checkAd() {
    MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
      keywords: <String>['flutterio', 'beautiful apps'],
      contentUrl: 'https://flutter.io',
      birthday: DateTime.now(),
      childDirected: false,
      designedForFamilies: false,
      gender: MobileAdGender
          .male, // or MobileAdGender.female, MobileAdGender.unknown
      testDevices: <String>[], // Android emulators are considered test devices
    );

    // myBanner = BannerAd(
    //   // Replace the testAdUnitId with an ad unit id from the AdMob dash.
    //   // https://developers.google.com/admob/android/test-ads
    //   // https://developers.google.com/admob/ios/test-ads
    //   adUnitId: BannerAd.testAdUnitId,
    //   size: AdSize.smartBanner,
    //   targetingInfo: targetingInfo,
    //   listener: (MobileAdEvent event) {
    //     print("BannerAd event is ${event.index}");
    //     if (event == MobileAdEvent.loaded) {
    //       setState(() {
    //         _adLoaded = true;
    //       });
    //     } else if (event == MobileAdEvent.failedToLoad) {
    //       setState(() {
    //         _adLoaded = false;
    //       });
    //     }
    //   },
    // );
    myInterstitial = InterstitialAd(
      // Replace the testAdUnitId with an ad unit id from the AdMob dash.
      // https://developers.google.com/admob/android/test-ads
      // https://developers.google.com/admob/ios/test-ads
      adUnitId: 'ca-app-pub-4776830761593608/1793585365',
      //  "ca-app-pub-4776830761593608/6218852473",
      // InterstitialAd.testAdUnitId,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("InterstitialAd event is $event");

        if (event == MobileAdEvent.loaded) {
          setState(() {
            _adLoaded = true;
          });
        } else if (event == MobileAdEvent.failedToLoad) {
          setState(() {
            _adLoaded = false;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // myInterstitial?.dispose();

    super.dispose();
  }

  void loadAd() {
    myInterstitial
      ..load()
      ..show(
        anchorType: AnchorType.bottom,
        anchorOffset: 0.0,
      );
    // myBanner
    //   // typically this happens well before the ad is shown
    //   ..load()
    //   ..show(
    //     // Positions the banner ad 60 pixels from the bottom of the screen
    //     anchorOffset: 80,
    //     // Banner Position
    //     anchorType: AnchorType.bottom,
    //   );
  }

  Future _getDates(
    String type,
  ) async {
    String path;
    if (type == 'holiday') {
      path = 'calender/${widget.state}/date';
    } else if (type == 'task') {
      path = 'user/$uid/taskDate';
    } else {
      path = 'user/$uid/completedDate';
    }
    print("uid here is ------------------------------: $uid");

    if ((uid != null) || (type == "holiday")) {
      setState(() {
        initLoading = true;
        print("1t $type times $initLoading");
      });
      try {
        database.DataSnapshot response =
            await database.FirebaseDatabase.instance
                .reference()
                // .child('user/$uid')
                .child(path)
                .once();

        print("response $type here is ${response.runtimeType}");
        print("response here is ${response?.value.runtimeType}");

        if (type == 'holiday') {
          holidayDateMap?.clear();
          holidayDateMap = response?.value ?? Map();
        } else if (type == 'task') {
          taskDateMap?.clear();
          taskDateMap = response?.value ?? Map();
        } else {
          completedDateMap?.clear();
          // completedEventList?.clear();
          // completedEventList?.clear();
          completedDateMap = response?.value ?? Map();
        }
        if (type == 'holiday') {
          markHoliday(holidayDateMap, false);
        } else {
          Map<dynamic, dynamic> value = response?.value;
          Iterable<dynamic> keys = value?.keys;
          List<dynamic> keyList = keys?.toList();
          int _len = value?.length ?? 0;

          // markedDateMap?.clear();
          for (int i = 0; i < _len; i++) {
            String key = keyList[i];

            List<dynamic> dataList = value[key];

            DateTime _date = DateTime.parse(key);

            int dataListLen = dataList?.length;
            for (int j = 0; j < dataListLen; j++) {
              print(
                  "response00000000 dataList type is ${dataList[j]} value key is ");
              if (dataList[j] == null) continue;
              String title = dataList[j]["title"];
              String uKey = dataList[j]['key'];
              String tag = dataList[j]['tag'];
              // print("title is $title");

              Event _event = Event(
                date: _date,
                title: title,
                icon: type == 'task' ? eventIconTask : eventIconComplete,
                uKey: uKey,
                tag: tag,
              );
              markedDateMap.add(_date, _event);
            }
          }
        }
        setState(() {
          initLoading = false;
          print("2t $type times $initLoading");
        });

        print("markedDateMap here is ${markedDateMap.events}");
      } catch (e) {
        setState(() {
          initLoading = false;
          print("3t $type times $initLoading");
        });
        errorDialog(
          context,
          "Try Again",
          "Are you connected to internetil $e",
        );
      }
    } else {
      if (initLoading)
        setState(() {
          initLoading = false;
          print("4t $type times $initLoading");
        });
    }
    refresh();
  }

  Future _getBalance() async {
    String path = 'user/$uid/balance';

    // print("uid here is ------------------------------: $uid");

    if (uid != null) {
      setState(() {
        initLoading = true;
      });
      try {
        database.DataSnapshot response =
            await database.FirebaseDatabase.instance
                .reference()
                // .child('user/$uid')
                .child(path)
                .once();

        print("response balance here is ${response.runtimeType}");
        print("response here is ${response?.value.runtimeType}");
        balance = response;
        Map<dynamic, dynamic> value = response?.value;
        Iterable<dynamic> keys = value?.keys;
        List<dynamic> keyList = keys?.toList();
        int _len = value?.length ?? 0;
        print("keyList here is $keyList");
        // print("keyListruntime here is ${value[keys[keyList[0]]]}");
        print("_len here is $_len");
        // balanceList?.clear();
        balanceKeysList?.clear();
        balanceMap?.clear();

        balanceMap = value;
        balanceKeysList = keyList;
        // print("balanceMap: ${balanceMap[keyList[0]]}");
        // for (int i = 0; i < _len; i++) {
        //   String key = keyList[i];
        //   print("value[key] is ${value[key].runtimeType}");
        //   balanceMap.addAll(value[key]);
        //   // List<dynamic> dataList = value[key];
        //   // balanceList.add(dataList);
        //   // balanceKeysList.add(key);
        //   // print("key: $key list: $dataList");
        // }
        setState(() {
          initLoading = false;
        });
      } catch (e) {
        setState(() {
          initLoading = false;
        });
        errorDialog(
          context,
          "Try Again",
          "Are you connected to internetil2 $e",
        );
      }
    } else {
      if (initLoading)
        setState(() {
          initLoading = false;
        });
    }
    refresh();
  }

  _getReminder() async {
    markedDateMap?.clear();
    database.DatabaseReference _database;

    // check if user exists
    await FirebaseAuth.instance.currentUser().then((user) {
      /// comment this line when login is embedded in project
      ///
      // uid = 'unique_id_here';

      ///
      ///
      if (user != null) {
        uid = user.uid;

        _database =
            database.FirebaseDatabase.instance.reference().child('user');
        _database.child(uid).once().then((val) {
          print(
              "vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvallllllllllllllllllllllllllllll is: ${val.value}");
          uid = val.value == null ? null : user.uid;
        }).catchError((e) {
          uid = null;
          return errorDialog(
            context,
            "Try Again",
            "Please hit the refresh button on Top Right position",
          );
        });
      } else {
        uid = null;
      }
    }).catchError((e) {
      print("errror 0000000000000000000is $e");
      errorDialog(
        context,
        "Looged out",
        "Please Log In again to enjoy services",
      );
    });
    if (uid != null) {
      database.DataSnapshot response = await database.FirebaseDatabase.instance
          .reference()
          .child('user/$uid/reminder')
          .once();
      reminderValue = response.value;
      print("reminder key is $reminderValue");
      print("reminder Value is ${reminderValue.runtimeType}");
    }
  }

  // Widget wheatherWidget() {
  //   return Container();
  // }

  @override
  Widget build(BuildContext context) {
    // checkAd();

    /// Example Calendar Carousel without header and custom prev & next button
    _calendarCarouselNoHeader = CalendarCarousel<Event>(
      onDayPressed: (DateTime date, List<Event> events) {
        holidayEventList?.clear();
        taskEventList?.clear();
        completedEventList?.clear();

        holidayKeyList?.clear();
        taskKeyList?.clear();
        completedKeyList?.clear();
        this.setState(
          () => _currentDate2 = DateTime(date.year, date.month, date.day),
        );
        markDate(_currentDate2);
      },
      locale: "en_in",
      childAspectRatio: 0.85,

      daysTextStyle: TextStyle(
        fontSize: 20,
        color: c.theme == 1 ? Style.primaryColor : Style.invertPrimaryColor,
      ),
      staticSixWeekFormat: true,
      weekendTextStyle: TextStyle(
        fontSize: 20,
        color: Colors.red,
      ),
      weekdayTextStyle: TextStyle(
        color: Style.secondaryColor,
        fontSize: 16,
      ),
      dayPadding: 1,
      // showOnlyCurrentMonthDate: true,

      // daysHaveCircularBorder: true,
      nextMonthDayBorderColor: Colors.transparent,
      prevMonthDayBorderColor: Colors.transparent,
      thisMonthDayBorderColor: Colors.transparent,
      // dayButtonColor: Colors.pink,

      todayButtonColor: Style.secondaryColor,
      todayBorderColor: Colors.transparent,
      todayTextStyle: TextStyle(
        fontSize: 18,
      ),
      selectedDayBorderColor: Colors.black,
      selectedDayButtonColor:
          c.theme == 0 ? Style.invertPrimaryColor : Style.primaryColor,
      selectedDayTextStyle: TextStyle(
        color: Style.secondaryColor, //CupertinoColors.activeBlue,
        fontSize: 20,
      ),
      weekFormat: false,
      markedDatesMap: markedDateMap,
      height: 410,
      selectedDateTime: _currentDate2,
      customGridViewPhysics:
          //  ScrollPhysics(),
          NeverScrollableScrollPhysics(),
      markedDateShowIcon: true,
      markedDateIconMaxShown: 1,
      markedDateMoreShowTotal:
          false, // null for not showing hidden events indicator
      showHeader: false,
      // iconColor: Colors.green,

      markedDateIconBuilder: (event) {
        return event.icon;
      },
      //      inactiveDateColor: Colors.black12,
      onCalendarChanged: (DateTime date) {
        this.setState(() => _currentMonth = DateFormat.yMMM().format(date));
      },
    );
    print("buiilding $initLoading");
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor:
          c.theme == 0 ? Style.backgreyColor : Style.backInvertGreyColor,
      // resizeToAvoidBottomInset: true,
      key: scaffoldKey,
      // appBar: AppBar(
      //   title: Text("data"),
      // ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add personal task",
        onPressed: () async {
          // return
          // checkAd();
          // loadAd();

          if (ads == null) ads = 0;
          if (ads == 3) {
            // change the ads counter from here and incCount ads
            checkAd();
            loadAd();
          }

          if (uid != null) {
            print("uid is not null $uid");
            addEventBottomSheet(
              context,
              _currentDate2,
              refresh,
              "task",
              false, // it is adding so false
              "", // key if editing
            );
          } else
            signInDialog(
              context,
              "Sign In",
              "\nYou need to login to save your Personal Task, Expenses.",
            );
          ads++;
          ads %= 4;
          incCount(ads);
          print("ads count is $ads");
        },
        child: Icon(
          Icons.add,
          size: 30,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                child: ListTile(
                  title: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 28,
                        color: c.theme == 1
                            ? Style.primaryColor
                            : Style.invertPrimaryColor,
                      ),
                      text: _currentMonth.substring(0, 4),
                      children: <TextSpan>[
                        TextSpan(
                          text: _currentMonth.substring(4, 8),
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 16,
                          ),
                        )
                      ],
                    ),
                  ),
                  trailing: Container(
                    width: c.cWidth * 0.4,
                    // color: Colors.red,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        IconButton(
                          onPressed: () {
                            setState(() {
                              initLoading = true;
                            });

                            print("getData called refresh");
                            return _getData();
                          },
                          // color: Colors.black54,
                          icon: initLoading
                              ? CircularProgressIndicator()
                              : Icon(
                                  Icons.refresh,
                                  color: Colors.blueAccent,
                                ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => SettingPage(),
                            ),
                          ),
                          // color: Colors.black54,
                          icon: Icon(
                            Icons.settings,
                            color: c.theme == 1
                                ? Style.backgreyColor
                                : Style.backInvertGreyColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                // color: Colors.grey,
                margin: EdgeInsets.only(
                  top: 25,
                  // bottom: 16.0,
                  left: 16.0,
                  right: 16.0,
                ),
                child: _calendarCarouselNoHeader,
              ),
              holidayEventList == null || holidayEventList.isEmpty
                  ? Container()
                  : EventCard(
                      currentDate2: _currentDate2,
                      notify: refresh,
                      type: 'holiday',
                      scaffoldKey: scaffoldKey,
                    ),
              //  showBottom(
              //     context,
              //     'HOLIDAY',
              //     'holiday',
              //     _currentDate2,
              //     refresh,
              //   ),
              // AdmobBanner(
              //   adUnitId: appId,
              //   adSize: AdmobBannerSize.SMART_BANNER,
              // ),
              taskEventList == null || taskEventList.isEmpty
                  ? Container()
                  : EventCard(
                      currentDate2: _currentDate2,
                      notify: refresh,
                      type: 'task',
                      scaffoldKey: scaffoldKey,
                    ),

              completedEventList == null || completedEventList.isEmpty
                  ? Container()
                  : EventCard(
                      currentDate2: _currentDate2,
                      notify: refresh,
                      type: 'completed',
                      scaffoldKey: scaffoldKey,
                    ),

              BalanceCard(
                notify: refresh,
                data: balance,
              ),
              data == null || data == false
                  ? Container()
                  : NewsPage(
                      data: data,
                    ),

              wheather == null || wheather == false
                  ? Container()
                  : WheatherPage(
                      wheatherModel: wheather,
                    ),

              // _adLoaded
              //     ? Container(
              //         height: c.cHeight * 0.17,
              //         // color: Colors.red,
              //       )
              //     : Container(),
              Container(height: 72),
            ],
          ),
        ),
      ),

      //  MyDrawer(),
    );
  }
}
