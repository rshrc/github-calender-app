import 'package:url_launcher/url_launcher.dart';

privacyPolicy() async {
  // Android
  String uri = "http://calendar365.in/privacy.html";
  if (await canLaunch(uri)) {
    await launch(uri);
  }
}
