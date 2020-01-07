import 'dart:typed_data';

import 'package:calender_app/src/UI/calender/calender1.dart' as calender;
import 'package:calender_app/src/UI/signInDialog.dart';
import 'package:calender_app/src/functions/errorHandling.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// for personal task add reminder to their event and for holiday add it to a reminder list
/// not a problem much now but when need to optimize can use it
///
///

class AddReminder extends StatefulWidget {
  Function notify;
  BuildContext context2;
  String uKey;
  DateTime date;
  int index;
  String value;
  String time;
  DateTime dateOfR;
  AddReminder({
    @required this.context2,
    @required this.uKey,
    @required this.index,
    @required this.date,
    @required this.notify,
    @required this.value,
    @required this.time,
    @required this.dateOfR,
  });

  @override
  _AddReminderState createState() => _AddReminderState();
}

class _AddReminderState extends State<AddReminder> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    dateController.text = DateFormat.yMMMd().format(_selectedDate);
    fromController.text =
        "${fromSelectedTime.hourOfPeriod}:${fromSelectedTime.minute}" +
            " ${fromSelectedTime.period.toString().substring(10, 12).toUpperCase()}";

    if (widget.index != -1) {
      color = Colors.blue;

      String formattedDate = DateFormat.yMMMd().format(widget.dateOfR);
      dateController.text = formattedDate;
      fromController.text = widget.time;
    }
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('notification_icon');
    var initializationSettingsIOS = new IOSInitializationSettings(
        // onDidReceiveLocalNotification: onDidReceiveLocalNotification,
        );
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future<void> _scheduleNotification() async {
    var scheduledNotificationDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      fromSelectedTime.hour,
      fromSelectedTime.minute,
    );
    // DateTime.now().add(Duration(seconds: 5));
    var vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        widget.uKey,
        'your other channel name',
        'your other channel description',
        // icon: 'secondary_icon',
        sound: 'slow_spring_board',
        // largeIcon: 'sample_large_icon',
        // largeIconBitmapSource: BitmapSource.Drawable,
        vibrationPattern: vibrationPattern,
        enableLights: true,
        color: const Color.fromARGB(255, 255, 0, 0),
        ledColor: const Color.fromARGB(255, 255, 0, 0),
        ledOnMs: 1000,
        ledOffMs: 500);
    var iOSPlatformChannelSpecifics =
        IOSNotificationDetails(sound: "slow_spring_board.aiff");
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
      int.parse(widget.uKey),
      'Reminder',
      widget.value,
      scheduledNotificationDateTime,
      platformChannelSpecifics,
    );
  }

  Future<void> onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }

    // await Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => SecondScreen(payload)),
    // );
  }

  Future<void> _cancelNotification() async {
    int key = int.parse(widget.uKey);
    await flutterLocalNotificationsPlugin.cancel(key);
  }

  Color color = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Container(
      child:
          //  _isLoading
          //     ? CircularProgressIndicator()
          //     :
          IconButton(
        onPressed: () {
          return calender.uid == null
              ? signInDialog(
                  context,
                  "LogIn",
                  "\nYou have to log in to save Reminders",
                )
              : showSetReminder(
                  widget.context2,
                  widget.date,
                  widget.uKey,
                  widget.notify,
                );
        },
        icon: Icon(
          Icons.add_alarm,
          color: color,
        ),
      ),
    );
  }

  _handleSubmit(
    BuildContext context,
    String key,
    dynamic notify,
    int index,
  ) async {
    setState(() {
      _isLoading = true;
    });
    var itemRef =
        FirebaseDatabase.instance.reference().child("user/${calender.uid}");
    Map<dynamic, dynamic> data = {
      "uKey": key,
      "date": _selectedDate.toString(),
      "time": fromController.text,
    };
    var r = List<dynamic>.from(calender.reminderValue ?? []);

    // int _len = calender.reminderValue?.length ?? 0;
    // bool exist = false;
    // int index;
    // print("length is $_len");
    // for (int i = 0; i < _len; i++) {
    //   String uKey = calender.reminderValue[i] == null
    //       ? ""
    //       : calender.reminderValue[i]["uKey"];
    //   if (uKey == key) {
    //     exist = true;
    //     index = i;
    //     break;
    //   }
    // }

    print("index is $index");
    if (index != -1) {
      var done = r.removeAt(index);
      print("done is $done");
      // removeWhere((item) {
      //   return item.values.contains(key);
      // });
    }

    r.add(data);

    await itemRef.update({"reminder": r}).then((val) async {
      // calender.reminderValue.removeWhere((item){
      //   return item.values.
      // });
      calender.reminderValue = r;
      notify();
      await _scheduleNotification();
      color = Colors.blue;
      Navigator.pop(context);
      print("this value is: ");
    }).catchError((e) {
      setState(() {
        _isLoading = false;
      });
      print("this error occured: $e");
      errorDialog(context, "Try Again", "Server not responding.");
    });
  }

  _handleDelete(
    BuildContext context,
    String key,
    dynamic notify,
    int index,
  ) async {
    setState(() {
      _isLoading = true;
    });
    var itemRef =
        FirebaseDatabase.instance.reference().child("user/${calender.uid}");

    var r = List<dynamic>.from(calender.reminderValue ?? []);

    // r.removeWhere((item) {
    //   return item.values.contains(key);
    // });
    print("index is $index");
    r.removeAt(index);

    await itemRef.update({"reminder": r}).then((val) async {
      calender.reminderValue = r;
      notify();
      await _cancelNotification();
      color = Colors.grey;
      Navigator.pop(context);
      print("this value is: ");
    }).catchError((e) {
      print("this error occured: $e");
      setState(() {
        _isLoading = false;
      });
      errorDialog(context, "Try Again", "Server not responding.");
    });
  }

  bool _isLoading = false;

  showSetReminder(
    BuildContext context,
    DateTime dataSelected,
    String key,
    dynamic notify,
  ) {
    Widget content() {
      // return ReminderSelect();
      return Column(
        // mainAxisAlignment: ,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          dobWidget(context),
          timeWidget(context),
        ],
      );
    }

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: Border.all(style: BorderStyle.none),
        title: Text(
          "Remind on",
        ),
        content: content(),
        actions: <Widget>[
          widget.index == -1
              ? Container()
              : CupertinoButton(
                  onPressed: () {
                    return _isLoading
                        ? null
                        : _handleDelete(
                            context,
                            key,
                            notify,
                            widget.index,
                          );
                  },
                  child: Text(
                    "Delete",
                    style: TextStyle(
                      color: CupertinoColors.destructiveRed,
                    ),
                  ),
                ),
          widget.index != -1
              ? Container()
              : CupertinoButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: CupertinoColors.activeBlue,
                    ),
                  ),
                ),
          CupertinoButton(
            onPressed: () {
              print("save in on its way");

              return _isLoading
                  ? null
                  : _handleSubmit(
                      context,
                      key,
                      notify,
                      widget.index,
                    );
            },
            child: Text(
              widget.index == -1 ? "Add" : "Update",
              style: TextStyle(
                color: CupertinoColors.activeGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }

  TimeOfDay fromSelectedTime = TimeOfDay.now();
  DateTime _selectedDate = DateTime.now();

  TextEditingController dateController = TextEditingController();
  TextEditingController fromController = TextEditingController();

  String displayDate;

  DateTime currentDate = DateTime.now();

  Future<void> selectDataFromPicker(BuildContext context) async {
    DateTime firstDate = currentDate.subtract(
      Duration(days: 1),
    );

    DateTime finalDate = DateTime(currentDate.year + 1);

    DateTime selected = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: firstDate,
      lastDate: finalDate,
    );
    print("selected: $selected");
    if (selected != null) {
      _selectedDate = selected;
    }
    displayDate = DateFormat.yMMMd().format(_selectedDate);
    // displayDate = "${DateFormat.d().format(_selectedDate)}" +
    //     " ${DateFormat.yMMM().format(_selectedDate)}";
    //  DateFormat.jm().format(_selectedDate);
    dateController.text = displayDate;
    print("date6777773 $displayDate");
  }

  Future<void> _fromSelectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: fromSelectedTime,
    );
    if (picked != null && picked != fromSelectedTime) {
      fromSelectedTime = picked;
    }
    fromController.text =
        "${fromSelectedTime.hourOfPeriod}:${fromSelectedTime.minute}" +
            " ${fromSelectedTime.period.toString().substring(10, 12).toUpperCase()}";
  }

  Widget dobWidget(BuildContext context) {
    if (widget.index != -1) {
      currentDate = widget.dateOfR;
      _selectedDate = widget.dateOfR;
    }
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Text(
              "Date",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ),
          InkWell(
            onTap: () => selectDataFromPicker(context),
            child: Container(
              // width: cWidth * 0.5,
              child: Stack(
                children: <Widget>[
                  TextFormField(
                    enabled: false,
                    controller: dateController,
                    keyboardType: TextInputType.datetime,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                      onPressed: () => selectDataFromPicker(context),
                      icon: Icon(
                        Icons.calendar_today,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget timeWidget(BuildContext context) {
    if (widget.index != -1) {
      print("length: ${widget.time.length}");
      int len = widget.time.length;

      // int h = int.parse(widget.time.substring(widget.time.));
      fromSelectedTime = TimeOfDay.fromDateTime(widget.dateOfR);
    }
    return Container(
      // padding: EdgeInsets.symmetric(
      //   horizontal: cWidth * 0.1,
      //   vertical: cHeight * 0.035,
      // ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Time",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          InkWell(
            onTap: () => _fromSelectTime(context),
            child: Container(
              // width: cWidth * 0.5,
              child: Stack(
                children: <Widget>[
                  TextFormField(
                    enabled: false,
                    controller: fromController,
                    keyboardType: TextInputType.datetime,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                      onPressed: () => _fromSelectTime(context),
                      icon: Icon(
                        Icons.timer,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
// }
}
