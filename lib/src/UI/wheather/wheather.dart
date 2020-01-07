import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:calender_app/src/functions/common.dart' as c;
import 'package:calender_app/src/models/wheatherModel.dart';
import 'package:calender_app/src/style/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WheatherPage extends StatefulWidget {
  final WheatherModel wheatherModel;
  WheatherPage({
    @required this.wheatherModel,
  });

  @override
  _WheatherPageState createState() => _WheatherPageState();
}

class _WheatherPageState extends State<WheatherPage> {
  String time = DateFormat.H().format(DateTime.now());
  int i = 0;
  int timeNow = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    timeNow = int.parse(time);
    // print('now time is $timeNow');
    // if (timeNow > 5) {
    //   i = timeNow - 5;
    //   timeNow -= 5;
    // } else {
    //   timeNow = 0;
    // }
  }

  @override
  Widget build(BuildContext context) {
    // print("wheather Model is printing");
    print('time now is : $time');
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
                'Weather'.toUpperCase(),
                textAlign: TextAlign.left,
                style: TextStyle(
                  // fontSize: 16,
                  color: c.theme == 1
                      ? Style.primaryColor
                      : Style.invertPrimaryColor,
                ),
              ),
            ),
            dataWidget(i),
          ],
        ),
      ),
    );
  }

  Widget dataWidget(
    int index,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 15,
      ),
      child: Column(
        children: <Widget>[
          firstContainer(index),
          secondContainer(index),
          // listShape(index),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: thirdContainer(),
          ),
        ],
      ),
    );
  }

  Widget thirdContainer() {
    int _len =
        //  min(
        widget.wheatherModel.hourlyForecasts.forecastLocation.forecast.length
        // ,
        //   24,
        // )
        ;
    print('length ; is 0000000000 : $_len');
    return Container(
      height: 130,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _len,
        itemBuilder: (BuildContext context, int index) {
          return listShape(index);
        },
      ),
    );
  }

  Widget listShape(int index) {
    DateTime utcTime = widget
        .wheatherModel.hourlyForecasts.forecastLocation.forecast[index].utcTime;
    String time = DateFormat.j().format(utcTime);
    print("time here is ------------------------ $utcTime & $time");

    String image = widget.wheatherModel.hourlyForecasts.forecastLocation
        .forecast[index].iconLink;

    String lTemp = widget.wheatherModel.hourlyForecasts.forecastLocation
        .forecast[index].temperature; // add *c
    String hTemp = widget.wheatherModel.hourlyForecasts.forecastLocation
        .forecast[index].comfort; // add *c

    // if (index < timeNow) {
    //   print("index is $index timeNow is $timeNow");
    //   return Container(
    //       // child: Text('data ret'),
    //       );
    // }
    return GestureDetector(
      onTap: () {
        setState(() {
          i = index;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: i == index
              ? c.theme == 0 ? Style.backgreyColor : Style.backInvertGreyColor
              //  Colors.grey[200]
              : Colors.transparent,
          border: Border.all(
            color: i == index ? Colors.grey : Colors.transparent,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              time,
              style: TextStyle(
                // fontSize: 16,
                color: c.theme == 1
                    ? Style.primaryColor
                    : Style.invertPrimaryColor,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 8,
              ),
              child: image == null
                  ? Container()
                  : CachedNetworkImage(
                      fadeInDuration: Duration(
                        seconds: 3,
                      ),
                      imageUrl: image,
                      fit: BoxFit.cover,
                      width: 35,
                      height: 35,
                    ),
            ),
            Text(
              hTemp,
              style: TextStyle(
                // fontSize: 16,
                color: c.theme == 1
                    ? Style.primaryColor
                    : Style.invertPrimaryColor,
              ),
            ),
            Text(
              lTemp,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget secondContainer(int index) {
    String image = widget.wheatherModel.hourlyForecasts.forecastLocation
        .forecast[index].iconLink;
    String temp = widget.wheatherModel.hourlyForecasts.forecastLocation
        .forecast[index].temperature; // add *c

    String percip = widget.wheatherModel.hourlyForecasts.forecastLocation
        .forecast[index].precipitationProbability;

    String humidity = widget.wheatherModel.hourlyForecasts.forecastLocation
        .forecast[index].humidity;

    String windSpeed = widget.wheatherModel.hourlyForecasts.forecastLocation
        .forecast[index].windSpeed;

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 8,
      ),
      child: ListTile(
        leading: image == null
            ? Container()
            : CachedNetworkImage(
                fadeInDuration: Duration(
                  seconds: 3,
                ),
                imageUrl: image,
                fit: BoxFit.cover,
                width: 50,
                height: 50,
              ),
        title: Container(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                // color: Colors.red,
                child: Text(
                  temp,
                  // textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 25,
                    color: c.theme == 1
                        ? Style.primaryColor
                        : Style.invertPrimaryColor,
                  ),
                ),
              ),
              Container(
                // color: Colors.green,
                padding: EdgeInsets.only(
                  top: 3,
                ),
                child: Text(
                  '°C',
                  style: TextStyle(
                    fontSize: 16,
                    color: c.theme == 1
                        ? Style.primaryColor
                        : Style.invertPrimaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        trailing: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Precipitation: $percip%',
              style: TextStyle(
                color: c.theme == 1
                    ? Style.primaryColor
                    : Style.invertPrimaryColor,
              ),
            ),
            Text(
              "Humidity: $humidity%",
              style: TextStyle(
                color: c.theme == 1
                    ? Style.primaryColor
                    : Style.invertPrimaryColor,
              ),
            ),
            // Text(
            //   "Wind: $windSpeed km/h",
            //   style: TextStyle(
            //     color: c.theme == 1
            //         ? Style.primaryColor
            //         : Style.invertPrimaryColor,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget firstContainer(
    int index,
  ) {
    String place = widget.wheatherModel?.hourlyForecasts?.forecastLocation?.city
            ?.toString() ??
        "";
    String stateHere =
        widget.wheatherModel.hourlyForecasts.forecastLocation.state ?? "";
    print('state here is -----------------$stateHere');
    String day = widget.wheatherModel.hourlyForecasts.forecastLocation
            .forecast[index].weekday
            .toString()
            // .substring(0, 3)
            .toLowerCase() ??
        "";
    DateTime utcTime = widget
        .wheatherModel.hourlyForecasts.forecastLocation.forecast[index].utcTime;
    String time = DateFormat.j().format(utcTime);

    String description = widget.wheatherModel.hourlyForecasts.forecastLocation
        .forecast[index].description;

    return Container(
      // color: Colors.red,

      padding: EdgeInsets.symmetric(
        // vertical: 10,
        horizontal: 25,
      ),
      width: c.cWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          // CircleAvatar(
          //   backgroundColor: CupertinoColors.activeBlue,
          //   radius: 5,
          // ),
          Text(
            place + ', ' + stateHere,
            style: TextStyle(
              fontSize: 22,
              color:
                  c.theme == 1 ? Style.primaryColor : Style.invertPrimaryColor,
            ),
          ),
          Text(
            day.substring(0, 1).toUpperCase() +
                day.substring(1, 3) +
                ', ' +
                time +
                ',   ' +
                description,
            style: TextStyle(
              color:
                  c.theme == 1 ? Style.primaryColor : Style.invertPrimaryColor,
            ),
          )
        ],
      ),
    );
  }
}
