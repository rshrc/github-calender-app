import 'package:calender_app/src/UI/calenderWidget/eventDetail.dart';
import 'package:calender_app/src/UI/calenderWidget/eventListShape.dart';
import 'package:calender_app/src/functions/common.dart' as c;
import 'package:calender_app/src/style/theme.dart';
import 'package:flutter/material.dart';
import '../calender/calender1.dart' as calender;

class EventCard extends StatelessWidget {
  final String type;
  final DateTime currentDate2;
  Function notify;
  dynamic scaffoldKey;
  EventCard({
    @required this.type,
    @required this.currentDate2,
    @required this.notify,
    @required this.scaffoldKey,
  });

  @override
  Widget build(BuildContext context) {
    int _len = 0;
    if (type == 'task') {
      _len = calender.taskEventList.length;
    } else if (type == 'completed') {
      _len = calender.completedEventList.length;
    } else if (type == 'task') {
      _len = calender.holidayEventList.length;
    }
    return Container(
      child: Card(
        color: c.theme == 0 ? Style.primaryColor : Style.invertPrimaryColor,
        margin: EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 25,
              ),
              child: Text(
                type == 'task' ? "TODAY'S TASK" : type.toUpperCase(),
                textAlign: TextAlign.left,
                style: TextStyle(
                  // fontSize: 16,
                  color: c.theme == 1
                      ? Style.primaryColor
                      : Style.invertPrimaryColor,
                ),
              ),
            ),
            mapData(
              context,
              type,
              currentDate2,
              notify,
              '5',
              scaffoldKey,
            ),
            _len <= 5 ? Container() : viewAll(context),
          ],
        ),
      ),
    );
  }

  Widget viewAll(
    BuildContext context,
  ) {
    return Container(
      width: c.cWidth,
      height: 55,
      child: RaisedButton(
        onPressed: () {
          print("go to EventListPage");
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => EventDetailPage(
                type: type,
                currentDate2: currentDate2,
                scaffoldKey: scaffoldKey,
              ),
            ),
          );
        },
        elevation: 0,
        color: c.theme == 0 ? Style.primaryColor : Style.invertPrimaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
          ),
        ),
        child: Text(
          "View All",
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 20,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }
}
