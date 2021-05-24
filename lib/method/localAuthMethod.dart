import 'package:shared_preferences/shared_preferences.dart';

loadLocalAuth() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  return _prefs.getBool('local_auth')??false;
}

saveLocalAuth(bool localAuth) async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  await _prefs.setBool('local_auth', localAuth??false);
}
