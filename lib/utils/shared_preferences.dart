import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static const String _firstTimeKey = 'first_time_open';

  static Future<bool> isFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_firstTimeKey) ?? true;
  }

  static Future<void> setFirstTimeDone() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_firstTimeKey, false);
  }
}
