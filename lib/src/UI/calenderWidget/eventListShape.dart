import 'dart:math';

import 'package:calender_app/src/UI/calender/addEvent.dart' as addEvent;

import '../calender/addReminder.dart';
import 'package:calender_app/src/functions/common.dart' as c;
import 'package:calender_app/src/functions/errorHandling.dart';
import 'package:calender_app/src/style/theme.dart';
import 'package:firebase_database/firebase_database.dart' as database;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import '../calender/calender1.dart' as calender;

Widget showBottom(
  BuildContext context,
  String show,
  String type,
  DateTime _currentDate2,
  dynamic notify,
  dynamic scaffoldKey,
) {
  // get this key from dates;
  return Column(
    children: <Widget>[
      Container(
        width: c.cWidth,
        color: Style.secondaryColor,
        padding: EdgeInsets.only(
          top: 2,
          bottom: 2,
          left: 16.0,
          right: 16.0,
        ),
        child: Text(
          show,
          style: TextStyle(
            fontSize: 15,
          ),
        ),
      ),
      mapData(
        context,
        type,
        _currentDate2,
        notify,
        'full',
        scaffoldKey,
      ),
    ],
  );
}

Widget mapData(
  BuildContext context,
  String type,
  DateTime _currentDate2,
  dynamic notify,
  String count,
  dynamic scaffoldKey,
) {
  int index = -1;
  String key;
  if (type == 'holiday') {
    return Container(
      child: Column(
        children: calender.holidayEventList.map((value) {
          index++;
          key = calender.holidayKeyList[index];
          if (count == '5' && index >= 5) return Container();
          return feildShape(
            context,
            value,
            index,
            type,
            key,
            _currentDate2,
            notify,
            scaffoldKey,
          );
        }).toList(),
      ),
    );
  } else if (type == 'task') {
    return Container(
      child: Column(
        children: calender.taskEventList.map((value) {
          index++;
          key = calender.taskKeyList[index];

          if (count == '5' && index >= 5) return Container();
          return feildShape(
            context,
            value,
            index,
            type,
            key,
            _currentDate2,
            notify,
            scaffoldKey,
          );
        }).toList(),
      ),
    );
  } else if (type == 'completed') {
    return Container(
      child: Column(
        children: calender.completedEventList.map((value) {
          index++;
          key = calender.completedKeyList[index];

          if (count == '5' && index >= 5) return Container();
          return feildShape(
            context,
            value,
            index,
            type,
            key,
            _currentDate2,
            notify,
            scaffoldKey,
          );
        }).toList(),
      ),
    );
  }
  return Container();
}

Widget feildShape(
  BuildContext context,
  String value,
  int index,
  String type,
  String key,
  DateTime _currentDate2,
  dynamic notify,
  dynamic scaffoldKey,
) {
  int _len = calender.reminderValue?.length ?? 0;
  bool exist = false;
  String date = "";
  String time = "";
  DateTime cDate;
  String formattedDate;
  int rIndex = -1;
  // print("length is $_len");
  for (int i = 0; i < _len; i++) {
    String uKey = (calender.reminderValue == null)
        ? ""
        : (calender.reminderValue[i] == null)
            ? ""
            : calender.reminderValue[i]["uKey"];
    if (uKey == key) {
      date = calender.reminderValue[i]["date"];
      time = calender.reminderValue[i]["time"];
      cDate = DateTime.parse(date);
      exist = true;
      rIndex = i;
      break;
    }
    // print("ukey: $uKey and key: $key");
  }
  if (type == 'holiday') {
    return shape(
      context,
      key,
      type,
      value,
      exist,
      time,
      cDate,
      rIndex,
      _currentDate2,
      notify,
    );
  } else {
    return Dismissible(
      secondaryBackground: Container(
        color: Colors.green,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.check,
              color: Colors.white,
            ),
            SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
      direction: type == 'completed'
          ? DismissDirection.startToEnd
          : DismissDirection.horizontal,
      background: Container(
        color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 10,
            ),
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ],
        ),
      ),
      key: ObjectKey(value +
          (index + index * pow(10, index.toString().length)).toString()),
      child: shape(
        context,
        key,
        type,
        value,
        exist,
        time,
        cDate,
        rIndex,
        _currentDate2,
        notify,
      ),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          if (type == 'task') {
            calender.taskEventList?.removeAt(index);
            calender.taskKeyList?.removeAt(index);
            // check if reminder exist then remove
          } else {
            calender.completedEventList?.removeAt(index);
            calender.completedKeyList?.removeAt(index);
            // check if reminder exist then remove
          }

          try {
            calender.markedDateMap
                .getEvents(_currentDate2)
                .removeWhere((item) => item.uKey == key);
            String path;
            String formattedDate = _currentDate2.toString().substring(0, 10);
            if (type == 'task') {
              path = 'user/${calender.uid}/taskDate';

              var r = List<Map<dynamic, dynamic>>.from(
                  calender.taskDateMap[formattedDate]);
              r.removeWhere((item) {
                // item.keys == key;
                print(
                    "item $item keys here is ${item?.values} type: ${item?.keys.runtimeType} key: $key");
                return item?.values?.contains(key);
              });

              calender.taskDateMap[formattedDate] = r;
              Map<String, dynamic> update = {
                '$formattedDate': calender.taskDateMap[formattedDate],
              };
              // calender.taskDateMap.map((k, v) => MapEntry(k, v));
              // updateKey();

              calender.updateMap(path, update);
            } else {
              path = 'user/${calender.uid}/completedDate';

              var r = List<Map<dynamic, dynamic>>.from(
                  calender.completedDateMap[formattedDate]);
              r.removeWhere((item) {
                // item.keys == key;
                print(
                    "item keys here is ${item?.values} type: ${item?.keys.runtimeType} key: $key");
                return item?.values?.contains(key);
              });

              calender.completedDateMap[formattedDate] = r;
              Map<String, dynamic> update = {
                '$formattedDate': calender.completedDateMap[formattedDate],
              };
              // calender.completedDateMap.map((k, v) => MapEntry(k, v));
              // updateKey();

              calender.updateMap(path, update);
            }
          } catch (e) {
            errorDialog(
              context,
              "Sorry!!",
              "Internet not connected $e",
            );
            print(
                "data not deleted from markedData map------------------------$e");
          } finally {
            print("it is deleted");
          }
          notify();
          scaffoldKey.currentState.showSnackBar(
            SnackBar(
              content: Text(
                "Task removed",
              ),
            ),
          );
        } else if (direction == DismissDirection.endToStart) {
          String path;
          String formattedDate = _currentDate2.toString().substring(0, 10);
          path = 'user/${calender.uid}/taskDate';
          print(
              "taskDatamap type ${calender.taskDateMap[formattedDate].runtimeType}");
          var r = List<Map<dynamic, dynamic>>.from(
              calender.taskDateMap[formattedDate]);
          r.removeWhere((item) {
            // item.keys == key;
            print(
                "item keys here is ${item?.values} type: ${item?.keys.runtimeType} key: $key");
            return item?.values?.contains(key);
          });
          calender.taskDateMap[formattedDate] = r;

          Map<String, dynamic> update = {
            '$formattedDate': calender.taskDateMap[formattedDate],
          };
          // calender.taskDateMap.map((k, v) => MapEntry(k, v));

          calender.updateMap(path, update);
          var title = calender.taskEventList[index];
          var keyHere = calender.taskKeyList[index];
          path = 'user/${calender.uid}/completedDate';

          calender.markedDateMap
              .getEvents(_currentDate2)
              .removeWhere((item) => item.uKey == keyHere);

          calender.taskEventList?.removeAt(index);
          calender.taskKeyList?.removeAt(index);
          notify();
          Map<String, dynamic> data = {
            "title": title,
            "key": keyHere,
            "tag": "completed",
            "icon": "icons",
          };

          bool exist = false;
          if (calender.completedDateMap == null) {
            exist = false;
          } else
            exist =
                calender.completedDateMap?.containsKey(formattedDate) ?? false;
          if (exist) {
            // update.update(formattedDate, data);
            print(
                'completed data Map type ${calender.completedDateMap.runtimeType}');

            var r = List<Map<dynamic, dynamic>>.from(
                calender.completedDateMap[formattedDate]);
            r.add(data);

            calender.completedDateMap[formattedDate] = r;
            print("r ggere is $r");
            print("r ggere is ${r.runtimeType}");
          } else {
            calender.completedDateMap[formattedDate] = [
              data,
            ];
          }

          update = {
            '$formattedDate': calender.completedDateMap[formattedDate],
          };
          // calender.completedDateMap.map((k, v) => MapEntry(k, v));

          calender.updateMap(path, update);

          calender.completedEventList.add(value);
          calender.completedKeyList.add(key);
          notify();
          // if have any reminder then remove
          Event event = Event(
            date: _currentDate2,
            title: title,
            icon: calender.eventIconComplete,
            uKey: keyHere,
            tag: "completed",
          );
          calender.markedDateMap.getEvents(_currentDate2).add(event);

          scaffoldKey.currentState.showSnackBar(
            SnackBar(
              content: Text(
                "Task marked completed",
              ),
            ),
          );
          print("edit now");
        }
        if (rIndex != -1) {
          print("deleting the reminder");
          _deleteReminder(
            context,
            key,
            rIndex,
            notify,
          );
        }
      },
    );
  }
}

Widget shape(
  BuildContext context,
  String key,
  String type,
  String value,
  bool exist,
  String time,
  DateTime cDate,
  int rIndex,
  DateTime _currentDate2,
  dynamic refresh,
) {
  String formattedDate;
  if (exist) formattedDate = DateFormat.yMMMd().format(cDate);
  return Container(
    // color: Colors.red,
    // height: ,

    child: Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          // color: Colors.red,
          padding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              IconButton(
                onPressed: () => type == 'task'
                    ? {
                        addEvent.eventController.text = value,
                        addEvent.addEventBottomSheet(
                          context,
                          _currentDate2,
                          refresh,
                          "task",
                          true, // it is adding so false
                          key,
                        )
                      }
                    : null,
                icon: Icon(
                  Icons.event_note,
                  color: CupertinoColors.activeOrange,
                ),
              ),
              // Spacer(
              //   flex: 1,
              // ),

              Flexible(
                child: Container(
                  // color: Colors.red,
                  padding: EdgeInsets.only(left: 8),
                  width: c.cWidth * 0.68,
                  // height: 35,
                  child: GestureDetector(
                    onTap: () {
                      print("do editing from here");

                      addEvent.eventController.text = value;
                      return type == 'task'
                          ? addEvent.addEventBottomSheet(
                              context,
                              _currentDate2,
                              refresh,
                              "task",
                              true, // it is adding so false
                              key,
                            )
                          : null;
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      // mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          value,
                          style: TextStyle(
                            fontSize: 16,
                            color: c.theme == 1
                                ? Style.primaryColor
                                : Style.invertPrimaryColor,
                          ),
                        ),
                        exist
                            ? Text(
                                time + " " + formattedDate,
                                style: TextStyle(
                                  // color: Colors.grey,
                                  color: c.theme == 1
                                      ? Style.subtitleColor
                                      : Style.invertSubtitleColor,
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
              ),
              // Spacer(
              //   flex: 8,
              // ),
              Container(
                // color: Colors.green,

                // width: c.cWidth * 0.14,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    type == "completed"
                        ? Container(
                            child: IconButton(
                              onPressed: null,
                              icon: Icon(
                                Icons.event_note,
                                color: Colors.transparent,
                              ),
                            ),
                          )
                        : AddReminder(
                            context2: context,
                            date: _currentDate2,
                            notify: refresh,
                            uKey: key,
                            index: rIndex,
                            value: value,
                            time: time,
                            dateOfR: cDate,
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Divider(
          height: 0,
          color: c.theme == 1 ? Style.greyColor : Style.invertGreyColor,
        ),
      ],
    ),
  );
}

_deleteReminder(
  BuildContext context,
  String key,
  int index,
  dynamic notify,
) async {
  // print("going 0");
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // print("going 1");
  Future<void> _cancelNotification(uKey) async {
    // print("going 6");
    int key = int.parse(uKey);
    await flutterLocalNotificationsPlugin.cancel(key);
  }

  // print("going 2");
  var itemRef = database.FirebaseDatabase.instance
      .reference()
      .child("user/${calender.uid}");

  // print("going 3");
  var r = List<dynamic>.from(calender.reminderValue ?? []);

  // print("going 4");
  // r.removeWhere((item) {
  //   return item.values.contains(key);
  // });
  // print("index is $index");

  r?.removeAt(index);

  await itemRef.update({"reminder": r}).then((val) async {
    // print("going 5");
    await _cancelNotification(key);

    calender.reminderValue = r;
    notify();
  }).catchError((e) {
    print("this error occured: $e");
    // setState(() {
    //   _isLoading = false;
    // });
    errorDialog(context, "Try Again", "Server not responding.");
  });
}
