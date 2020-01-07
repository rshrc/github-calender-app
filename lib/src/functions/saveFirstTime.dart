import 'package:shared_preferences/shared_preferences.dart';

saveFirstTime() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.setBool('firstTime', true);
}
 