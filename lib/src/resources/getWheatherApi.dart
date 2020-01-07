import 'dart:async';
import 'package:calender_app/src/functions/errorHandling.dart';
import 'package:calender_app/src/models/wheatherModel.dart';
import 'package:http/http.dart' as http;
// import 'dart:convert';
import 'package:flutter/material.dart';

Future<dynamic> getWheather(
  BuildContext context,
  String city,
) async {
  if (city == null) {
    city = 'Jaipur';
  }
  // city = 'Delhi';
  var url =
      "https://weather.api.here.com/weather/1.0/report.json?product=forecast_hourly&name=$city&app_id=DemoAppId01082013GAL&app_code=AJKnXv84fjrb0KIHawS0Tg";

  print("url: $url");

  // Map<String, dynamic> body = {
  //   "product": "forecast_hourly",
  //   "name": city,
  //   "app_id": "DemoAppId01082013GAL",
  //   "app_code": "AJKnXv84fjrb0KIHawS0Tg",
  // };

  http.Response response;
  // try {
  response = await http.get(
    url,

    headers: {
      "Content-Type": 'application/json',

      // "product": "forecast_hourly",
      // "name": city,
      // "app_id": "DemoAppId01082013GAL",
      // "app_code": "AJKnXv84fjrb0KIHawS0Tg",
      // "Authorization": "Bearer $userToken",
    },
    // params
  ).catchError((e) {
    print("eroro here is 0: $e");

    errorDialog(
      context,
      "Oops",
      "Please check you are connected to internet",
    );
    return false;
  });

  print("status: ${response.statusCode}");
  print("body: ${response.body}");
  print("request Type: ${response.request}");

  if (response.statusCode == 200) {
    // return response.body;
    return WheatherModel.fromJson(response.body);
  }
  return false;
}
