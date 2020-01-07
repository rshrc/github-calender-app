import 'package:calender_app/src/style/theme.dart';
import 'package:flutter/material.dart';
import 'package:calender_app/src/functions/common.dart' as c;

import 'balanceListShape.dart';

class BalanceAllPage extends StatefulWidget {
  Function notify;
  dynamic data;
  BalanceAllPage({
    @required this.notify,
    @required this.data,
  });

  @override
  _EventDetailPageState createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<BalanceAllPage> {
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
          'Trip Expenses',
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
        child: showData(
          context,
          widget.notify,
          'full',
        ),
      ),
    );
  }
}
