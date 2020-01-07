import 'dart:math';
import 'package:calender_app/src/functions/common.dart' as c;
import 'package:calender_app/src/style/theme.dart';
import 'package:firebase_database/firebase_database.dart' as database;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../calender/calender1.dart' as calender;
import 'balanceDetail.dart';

Widget showData(
  BuildContext context,
  // DateTime _currentDate2,
  dynamic notify,
  String count,
  // dynamic scaffoldKey,
) {
  int _len = calender.balanceKeysList?.length;

  int index = _len;
  Iterable inreverse = calender.balanceKeysList?.reversed;
  var reverseBalanceKeysList = inreverse?.toList();
  return Container(
    child: Column(
      children: reverseBalanceKeysList?.map((value) {
            index--;

            if (count == '5' && index >= 5) return Container();
            return feildShape(
              context,
              value,
              index,
              notify,
            );
          })?.toList() ??
          [Container()],
    ),
  );
}

Widget feildShape(
  BuildContext context,
  String value,
  int index,
  dynamic notify,
) {
  return Dismissible(
    direction:
        //  type == 'completed'
        //     ?
        DismissDirection.startToEnd,
    // : DismissDirection.horizontal,
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
    key: ObjectKey(
        value + (index + index * pow(10, index.toString().length)).toString()),
    child: shape(
      context,
      value,
      index,
      notify,
    ),
    onDismissed: (direction) {
      if (calender.uid != null) {
        var itemRef = database.FirebaseDatabase.instance
            .reference()
            .child('user/${calender.uid}/balance');

        itemRef.update({value: null});
        calender.balanceKeysList.removeAt(index);
        calender.balanceMap.remove(value);
        notify();
      }
    },
  );
  // }
}

Widget shape(
  BuildContext context,
  String value,
  int index,
  dynamic refresh,
) {
  String title = value;
  DateTime startDate = DateTime.parse(title.substring(0, 10));
  DateTime endDate = DateTime.parse(title.substring(14));

  String title1 = DateFormat.yMMMd().format(startDate);
  String title2 = DateFormat.yMMMd().format(endDate);

  String titleContent = title1 + '  to  ' + title2;
  return Container(
    // color: Colors.blue,
    child: InkWell(
      onTap: () {
        print("balance 1 tapped");
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => BalanceDetail(
              i: index,
            ),
          ),
        );
      },
      child: Container(
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
                  Flexible(
                    child: Container(
                      // color: Colors.red,
                      padding: EdgeInsets.only(left: 8),
                      width: c.cWidth * 0.68,
                      // height: 35,
                      child: GestureDetector(
                        onTap: () {
                          print("do editing from here");
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => BalanceDetail(
                                i: index,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          // value,
                          titleContent,
                          style: TextStyle(
                            fontSize: 16,
                            color: c.theme == 1
                                ? Style.primaryColor
                                : Style.invertPrimaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Spacer(
                  //   flex: 8,
                  // ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          child: IconButton(
                            onPressed: null,
                            icon: Icon(
                              Icons.event_note,
                              color: Colors.transparent,
                            ),
                          ),
                        )
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
      ),
    ),
  );
}
