import 'package:calender_app/src/UI/calenderWidget/eventListShape.dart';
import 'package:calender_app/src/style/theme.dart';
import 'package:flutter/material.dart';
import 'package:calender_app/src/functions/common.dart' as c;

class EventDetailPage extends StatefulWidget {
  final String type;
  final DateTime currentDate2;
  dynamic scaffoldKey;
  EventDetailPage({
    @required this.type,
    @required this.currentDate2,
    @required this.scaffoldKey,
  });

  @override
  _EventDetailPageState createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
   @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
  refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          c.theme == 0 ? Style.backgreyColor : Style.backInvertGreyColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.type == 'task' ? "TODAY'S TASK" : widget.type.toUpperCase(),
          style: TextStyle(
            fontSize: 20,
            color: Style.primaryColor,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Style.primaryColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: mapData(
          context,
          widget.type,
          widget.currentDate2,
          refresh,
          "full",
          widget.scaffoldKey,
        ),
      ),
    );
  }
}
