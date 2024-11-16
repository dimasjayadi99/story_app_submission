import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/app_const.dart';

class LogoutProvider extends ChangeNotifier {
  Future<void> logoutAccount() async {
    final response = await SharedPreferences.getInstance();
    response.remove(AppConst.prefsToken);
  }
}
