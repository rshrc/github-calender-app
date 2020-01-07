import 'package:firebase_database/firebase_database.dart';

Future<String> getKey() async {
  DataSnapshot response =
      await FirebaseDatabase.instance.reference().child('stats').once();
  print("reposnse sjfh gf h: $response");
  print("reposnse sjfh gf h: ${response.value}");
  int key = response.value["key"];
  Map<String, dynamic> data = {
    "key": key + 1,
  };
  updateKey(data);
  print("key here is $key");
  return key.toString();
}

updateKey(
  dynamic data,
) async {
  await FirebaseDatabase.instance.reference().child('stats').update(data);
}
