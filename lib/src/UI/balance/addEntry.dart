import 'package:calender_app/src/functions/common.dart' as c;
import 'package:calender_app/src/functions/errorHandling.dart';
import 'package:calender_app/src/style/theme.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:calender_app/src/UI/calender/calender1.dart' as calender;

import '../signInDialog.dart';

class AddEntry extends StatefulWidget {
  Function notify;
  BuildContext context2;
  AddEntry({
    @required this.notify,
    @required this.context2,
  });
  @override
  _AddEntryState createState() => _AddEntryState();
}

class _AddEntryState extends State<AddEntry> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  _handleAdd(
    BuildContext context,
    dynamic notify,
  ) async {
    setState(() {
      _isLoading = true;
    });
    var itemRef = FirebaseDatabase.instance
        .reference()
        .child("user/${calender.uid}/balance/");

    List<dynamic> listHere = [
      {"note": ""},
    ];
    Map<dynamic, dynamic> r = {
      _selectedDate1.subtract(Duration(days: 1)).toString().substring(0, 10):
          listHere,
    };

    String formattedDate = _selectedDate1.toString().substring(0, 10) +
        " to " +
        _selectedDate2.toString().substring(0, 10);
    print("formatted date here is $formattedDate");
    print("_selectedDate1 date here is $_selectedDate1");
    print("_selectedDate2 date here is $_selectedDate2");

    await itemRef.update({formattedDate: r}).then((val) async {
      // calender.reminderValue.removeWhere((item){
      //   return item.values.
      // });
      calender.balanceKeysList.add(formattedDate);
      calender.balanceMap[formattedDate] = r;
      notify();
      // await _scheduleNotification();
      Navigator.pop(context);
      print("this value is: ");
      setState(() {
        _isLoading = false;
      });
    }).catchError((e) {
      setState(() {
        _isLoading = false;
      });
      print("this error occured: $e");
      errorDialog(context, "Try Again", "Server not responding.");
    });
  }

  @override
  void initState() {
    super.initState();
    fromController.text = DateFormat.yMMMd().format(_selectedDate1);
    toController.text = DateFormat.yMMMd().format(_selectedDate2);

    // if (widget.index != -1) {
    //   color = Colors.blue;

    //   String formattedDate = DateFormat.yMMMMd().format(widget.dateOfR);
    //   dateController.text = formattedDate;
    //   fromController.text = widget.time;
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: IconButton(
        onPressed: () {
          print("add called");
          return calender.uid == null
              ? signInDialog(
                  context,
                  "LogIn",
                  "\nYou have to log in to save Reminders",
                )
              : showSetReminder(
                  context,
                  // widget.context2,
                  // widget.date,
                  // widget.uKey,
                  widget.notify,
                );
        },
        icon: Icon(
          Icons.add,
          color: c.theme == 1 ? Style.primaryColor : Style.invertPrimaryColor,
        ),
      ),
    );
  }

  bool _isLoading = false;
  showSetReminder(
    BuildContext context,
    // DateTime dataSelected,
    // String key,
    dynamic notify,
  ) {
    Widget content() {
      // return ReminderSelect();
      return Column(
        // mainAxisAlignment: ,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          dobWidget(
            context,
            'From',
            fromController,
          ),
          dobWidget(
            context,
            'To',
            toController,
          ),
        ],
      );
    }

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: Border.all(style: BorderStyle.none),
        title: Text(
          "Add Note",
        ),
        content: content(),
        actions: <Widget>[
          CupertinoButton(
            onPressed: () {
              return _isLoading ? null : Navigator.pop(context);
            },
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
                  : _handleAdd(
                      context,
                      notify,
                    );
            },
            child: Text(
              "Add",
              style: TextStyle(
                color: CupertinoColors.activeGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }

  DateTime _selectedDate1 = DateTime.now();
  DateTime _selectedDate2 = DateTime.now();

  TextEditingController toController = TextEditingController();
  TextEditingController fromController = TextEditingController();

  String displayDate1;
  String displayDate2;

  DateTime currentDate = DateTime.now();

  Future<void> selectDataFromPicker(
    BuildContext context,
    String type,
    TextEditingController controller,
  ) async {
    DateTime firstDate = DateTime(2000);
    // if (type == 'From') {
    //   firstDate = DateTime(2000);
    // }

    DateTime finalDate = DateTime(currentDate.year + 1);

    DateTime selected = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: firstDate,
      lastDate: finalDate,
    );
    print("selected: $selected");
    if (selected != null) {
      type == 'From' ? _selectedDate1 = selected : _selectedDate2 = selected;

      controller.text = DateFormat.yMMMd().format(selected);
    }
    // displayDate = "${DateFormat.d().format(_selectedDate)}" +
    //     " ${DateFormat.yMMM().format(_selectedDate)}";
    //  DateFormat.jm().format(_selectedDate);
  }

  Widget dobWidget(
    BuildContext context,
    String type,
    TextEditingController controller,
  ) {
    // if (widget.index != -1) {
    //   currentDate = widget.dateOfR;
    //   _selectedDate = widget.dateOfR;
    // }
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Text(
              type,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              return
                  //  type == 'From'
                  //     ? null
                  //     :
                  selectDataFromPicker(
                context,
                type,
                controller,
              );
            },
            child: Container(
              // width: cWidth * 0.5,
              child: Stack(
                children: <Widget>[
                  TextFormField(
                    enabled: false,
                    controller: controller,
                    style: TextStyle(
                        // color: type == 'From' ? Colors.grey : Colors.black,
                        ),
                    keyboardType: TextInputType.datetime,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                      onPressed: () {
                        return
                            // type == 'From'
                            //     ? null
                            //     :
                            selectDataFromPicker(
                          context,
                          type,
                          controller,
                        );
                      },
                      icon: Icon(
                        Icons.calendar_today,
                        color:
                            //  type == 'From' ? Colors.grey :
                            Colors.blue,
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
}
