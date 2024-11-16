import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:submission_story_app/common/enum_state.dart';
import 'package:submission_story_app/data/api/api_service.dart';

import '../common/app_const.dart';
import '../data/preferences.dart';

class AddStoryProvider extends ChangeNotifier {
  final ApiService apiService = ApiService();
  ResponseState responseState = ResponseState.initial;

  String _message = "";
  String get message => _message;

  Future<void> addStory(
      String description, File photo, double lat, double lon) async {
    try {
      responseState = ResponseState.loading;
      notifyListeners();

      var prefs = Preferences();
      await prefs.getPrefs();
      var token = prefs.token;
      final response =
          await apiService.postStory(token ?? '', description, photo, lat, lon);

      if (!response.error) {
        responseState = ResponseState.success;
        _message = "Success add a new post";
      } else {
        responseState = ResponseState.failed;
        _message = "Failed add a new post";
      }
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
