import 'package:calender_app/src/style/theme.dart';
import 'package:flutter/material.dart';
import 'package:page_indicator/page_indicator.dart';
import './walkthrough1.dart';
import './walkthrough2.dart';
import './walkthrough3.dart';

PageController _controller;

class WalkThroughManager extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: PageIndicatorContainer(
        pageView: PageView(
          children: <Widget>[
            WalkThrough1(),
            WalkThrough2(),
            WalkThrough3(),
          ],
          controller: _controller,
        ),
        length: 3,
        indicatorSelectorColor:  Style.secondaryColor,
        indicatorColor: Color(0xffd3d3d3),
        padding: EdgeInsets.only(bottom: height * 0.05),
      ),
    );
  }
}
