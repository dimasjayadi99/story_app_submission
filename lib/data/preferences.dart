import 'package:shared_preferences/shared_preferences.dart';
import 'package:submission_story_app/common/app_const.dart';

class Preferences {
  String? _token;
  String? get token => _token;

  bool _isFirst = true;
  bool get isFirst => _isFirst;

  setPrefs(String token, bool isFirst) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(AppConst.prefsToken, token);
    prefs.setBool(AppConst.prefsIsFirst, isFirst);
  }

  Future<void> getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(AppConst.prefsToken);
    _isFirst = prefs.getBool(AppConst.prefsIsFirst) ?? true;
  }
}
