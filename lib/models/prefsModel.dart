import 'package:shared_preferences/shared_preferences.dart';

Future getKeyValue(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}

Future<bool> setKeyValue(String key, String value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.setString(key, value);
}
