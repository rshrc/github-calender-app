import 'package:shared_preferences/shared_preferences.dart';

saveState(String state) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setString('state', state);
}

getState() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String state = preferences.getString('state');
  return state;
}

saveColor(int color) async {
  // o => white
  // 1 => black

  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setInt('color', color);
}

getColor() async {
  // o => white
  // 1 => black

  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getInt('color');
}

incCount(value) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  if (value == null || value == 4) value = 0;
  preferences.setInt('ads', value);
}

getCount() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getInt('ads');
}
