import 'package:http/http.dart' as http;

import 'dart:convert';

import 'package:url_launcher/url_launcher.dart';

Future<dynamic> getNews() async {
  
  String url =
      "https://newsapi.org/v2/top-headlines?country=in&apiKey=72fd68d8dc9a48739c7cea3aaf7b4e57";
  print(url);

  var data;
  var response = await http.get(url);
  // print(response.statusCode);
  // print(response.body);

  if (response.statusCode == 200) {
    data = json.decode(response.body);
    return data;
  }
  return false;
}

goToUrl(
  String url,
) async {
  // Android
  String uri = url;
  if (await canLaunch(uri)) {
    await launch(uri);
  } else {
    // iOS
    String uri = url;
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }
}
