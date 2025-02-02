import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveUserPreference(String key, String value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(key, value);
}

Future<String?> getUserPreference(String key) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}
