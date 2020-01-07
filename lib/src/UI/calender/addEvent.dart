import 'package:calender_app/src/functions/common.dart' as c;
import 'package:calender_app/src/functions/errorHandling.dart';
import 'package:calender_app/src/resources/getKeyApi.dart';
import 'package:calender_app/src/style/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';

import 'calender1.dart' as calender;

// we have changed the event class of calender carousal and added two more feild 'tag' and 'uKey'
bool _isLoading = false;
TextEditingController eventController = TextEditingController();

_handleSubmit(
  BuildContext context,
  DateTime date,
  dynamic notifySend,
  dynamic notifyP,
  String type,
) async {
  // var form = _eventFormKey.currentState;
  // if (form.validate()) {
  // print("form validated");
  // add on success
  _isLoading = true;
  notifySend();
  if (eventController.text == "") {
    _sendAvailable = true;
    _isLoading = false;
    notifySend();

    return;
  }
  await getKey().then((val) async {
    // if (val == false) return;
    String _uKey = val;

    Event event = Event(
      date: date,
      title: eventController.text,
      icon: calender.eventIconTask,
      uKey: _uKey,
      tag: type,
    );

    String formattedDate = date.toString().substring(0, 10);
    String path = 'user/${calender.uid}/taskDate';
    Map<String, dynamic> data = {
      "title": eventController.text,
      "key": _uKey,
      "tag": type,
      "icon": "icons",
    };

    bool exist = false;
    if (calender.taskDateMap == null) {
      exist = false;
    } else
      exist = calender.taskDateMap?.containsKey(formattedDate) ?? false;
    if (exist) {
      // update.update(formattedDate, data);
      print(
          "type check9999999999 ${calender.taskDateMap[formattedDate].runtimeType}");
      // calender.taskDateMap[formattedDate].add(data);
      var r =
          List<Map<dynamic, dynamic>>.from(calender.taskDateMap[formattedDate]);
      r.add(data);

      calender.taskDateMap[formattedDate] = r;
      // print("r ggere is $r");
      // print("r ggere is ${r.runtimeType}");
    } else {
      calender.taskDateMap[formattedDate] = [
        data,
      ];
    }

    Map<String, dynamic> update = {
      '$formattedDate': calender.taskDateMap[formattedDate],
    };
    // calender.taskDateMap[formattedDate]; //.map((k, v) => MapEntry(k, v));
    try {
      await calender.updateMap(path, update);
      _isLoading = false;
      // var l = calender.taskEventList;
      // var k = calender.taskKeyList;
      // calender.taskEventList[0] = (eventController.text);
      // calender.taskKeyList[0] = (_uKey);
      // calender.taskEventList.addAll(l);
      // calender.taskEventList.addAll(k);
      calender.markedDateMap.add(date, event);
      calender.markDate(date);
      // do firebse logic here
      notifyP();
      // do when success
      Navigator.pop(context);
      eventController.clear();
    } catch (e) {
      print("error in here is $e");
      _isLoading = false;
      _sendAvailable = true;
      notifySend();
      notifyP();
    }
    // eventController?.dispose();
  }).catchError((e) {
    print("error is $e");

    _isLoading = true;
    _sendAvailable = true;
    notifySend();
    notifyP();
    errorDialog(
      context,
      "Try Again",
      "Check your internet connection",
    );
  }); // check what happen in case of failure
  // }
}

_handleEdit(
  BuildContext context,
  DateTime date,
  dynamic notifySend,
  dynamic notifyP,
  String type,
  String key,
) async {
  _isLoading = true;
  notifySend();
  if (eventController.text == "") {
    _sendAvailable = true;
    _isLoading = false;
    notifySend();

    return;
  }
  // await getKey().then((val) async {
  // if (val == false) return;
  String _uKey = key;

  Event event = Event(
    date: date,
    title: eventController.text,
    icon: calender.eventIconTask,
    uKey: _uKey,
    tag: type,
  );

  String formattedDate = date.toString().substring(0, 10);
  String path = 'user/${calender.uid}/taskDate';
  Map<String, dynamic> data = {
    "title": eventController.text,
    "key": _uKey,
    "tag": type,
    "icon": "icons",
  };

  bool exist = false;
  if (calender.taskDateMap == null) {
    exist = false;
  } else
    exist = calender.taskDateMap?.containsKey(formattedDate) ?? false;
  if (exist) {
    // update.update(formattedDate, data);
    // print(
    //     "type check9999999999 ${calender.taskDateMap[formattedDate].runtimeType}");
    // calender.taskDateMap[formattedDate].add(data);
    var r =
        List<Map<dynamic, dynamic>>.from(calender.taskDateMap[formattedDate]);
    print("r  $key is $r");
    r.removeWhere((item) {
      // print("item here is 0000000000000000000000000000 $item");
      // print(
      //     "here itemKey: ${item['key']} and key: $_uKey same: ${item['key'] == _uKey}");
      return item?.values?.contains(_uKey);
    });

    calender.markedDateMap
        .getEvents(date)
        .removeWhere((item) => item.uKey == key);

    // print("r after $r");
    r.add(data);

    calender.taskDateMap[formattedDate] = r;
  } else {
    calender.taskDateMap[formattedDate] = [
      data,
    ];
  }

  Map<String, dynamic> update = {
    '$formattedDate': calender.taskDateMap[formattedDate],
  };
  // calender.taskDateMap[formattedDate]; //.map((k, v) => MapEntry(k, v));
  try {
    await calender.updateMap(path, update);
    _isLoading = false;

    calender.markedDateMap.add(date, event);
    calender.markDate(date);
    // do firebse logic here
    notifyP();
    // do when success
    Navigator.pop(context);
    eventController.clear();
  } catch (e) {
    print("error in here is $e");
    _isLoading = false;
    _sendAvailable = true;
    notifySend();
    notifyP();
  }
}

// RenderFlex overflowed by 1.00 pixels on the bottom due to next list tile
List<String> name = [
  "Mark PL",
  "Mark CL",
];
void addEventBottomSheet(
  BuildContext context,
  DateTime dateSelected,
  dynamic notify,
  String type,
  bool edit,
  String uKey,
) {
  Widget chipSelect(String name, int index) {
    return Padding(
      padding: EdgeInsets.only(left: 5),
      child: GestureDetector(
        onTap: () {
          print("Is Loading is $_isLoading");
          if (!_isLoading) {
            eventController.text = name;
            print("is Loading is ${eventController.text}");
          } else {
            print("check clicked send");
            return null;
          }
        },
        child: Chip(
          backgroundColor: Style.secondaryColor,
          // avatar: CircleAvatar(
          //   child: Icon(
          //     Icons.adb,
          //   ),
          // ),
          deleteIcon: Icon(
            Icons.check,
          ),
          // onDeleted: () {
          //   print("item deleted");
          // },
          label: Text(
            name,
            style: TextStyle(
                // color: Style,
                ),
          ),
        ),
      ),
    );
  }

  Widget chipsHere() {
    int index = -1;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: name.map((val) {
          index++;
          return chipSelect(name[index], index);
        }).toList(),
      ),
    );
  }

  showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          // color: Colors.red,
          // height: 120,
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                // leading: Icon(
                //   Icons.image,
                // ),
                title: TextField(
                  autofocus: true,
                  controller: eventController,
                  decoration: InputDecoration(
                    hintText: "What would you like to do?",
                    // hintStyle: TextStyle(color: Colors.grey)
                  ),
                  textCapitalization: TextCapitalization.sentences,
                ),
                trailing: SendPageButton(
                  dateSelected: dateSelected,
                  notify: notify,
                  type: type,
                  edit: edit,
                  uKey: uKey,
                ),

                // onTap: () => getImageGallery(context),
              ),
              chipsHere(),
              // ListTile(
              //   // leading: Icon(Icons.hi/),
              //   title: chipsHere(),
              //   // onTap: () => getImage(context),
              // ),
            ],
          ),
        );
      });
}

class SendPageButton extends StatefulWidget {
  DateTime dateSelected;
  dynamic notify;
  String type;
  bool edit;
  String uKey;
  SendPageButton({
    @required this.dateSelected,
    @required this.notify,
    @required this.type,
    @required this.edit,
    this.uKey,
  });
  @override
  _SendPageButtonState createState() => _SendPageButtonState();
}

bool _sendAvailable = false;

class _SendPageButtonState extends State<SendPageButton>
    with SingleTickerProviderStateMixin {
  checkSend() {
    eventController.addListener(() {
      setState(() {
        _sendAvailable = eventController.text.length > 0;
      });
    });
  }

  refresh() {
    setState(() {});
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
    checkSend();
  }

  @override
  Widget build(BuildContext context) {
    // checkSend();
    return Container(
      child: IconButton(
        onPressed: !_sendAvailable
            ? null
            : () {
                print("item added in user profile");
                setState(() {
                  _sendAvailable = false;
                });
                widget.edit
                    ? _handleEdit(
                        context,
                        widget.dateSelected,
                        refresh,
                        widget.notify,
                        widget.type,
                        widget.uKey,
                      )
                    : _handleSubmit(
                        context,
                        widget.dateSelected,
                        refresh,
                        widget.notify,
                        widget.type,
                      );
              },
        icon: Icon(
          Icons.send,
          color: !_sendAvailable ? Colors.grey : Style.sendColor,
        ),
      ),
    );
  }
}
