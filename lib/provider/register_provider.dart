import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:submission_story_app/common/app_const.dart';
import 'package:submission_story_app/common/enum_state.dart';
import 'package:submission_story_app/data/api/api_service.dart';

class RegisterProvider extends ChangeNotifier {
  ApiService apiService = ApiService();
  ResponseState responseState = ResponseState.initial;

  String _message = "";
  String get message => _message;

  Future<void> registerAccount(
      String name, String email, String password) async {
    try {
      responseState = ResponseState.loading;
      notifyListeners();

      final response = await apiService.register(name, email, password);

      response.fold((errorMessage) {
        responseState = ResponseState.failed;
        _message = "${AppConst.failedRegister} : $errorMessage";
      }, (responseModel) {
        responseState = ResponseState.success;
        _message = AppConst.successRegister;
      });
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
