import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:submission_story_app/common/enum_state.dart';
import 'package:submission_story_app/data/api/api_service.dart';
import 'package:submission_story_app/data/preferences.dart';
import '../common/app_const.dart';

class LoginProvider extends ChangeNotifier {
  ResponseState responseState = ResponseState.initial;
  ApiService apiService = ApiService();

  String _message = "";
  String get message => _message;
  String _token = "";
  String get token => _token;

  Future<void> loginAccount(String email, String password) async {
    try {
      responseState = ResponseState.loading;
      notifyListeners();

      final response = await apiService.login(email, password);

      response.fold(
        (errorMessage) {
          responseState = ResponseState.failed;
          _message = "${AppConst.failedLogin} : $errorMessage";
        },
        (loginModel) async {
          responseState = ResponseState.success;
          _token = loginModel.loginResult.token;
          await Preferences().setPrefs(_token, false);
          _message = AppConst.successLogin;
        },
      );
    } catch (error) {
      responseState = ResponseState.failed;
      _message = error is SocketException
          ? AppConst.errorInternet
          : "An error has occurred: $error";
    } finally {
      notifyListeners();
    }
  }
}
