import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:submission_story_app/common/app_const.dart';
import 'package:submission_story_app/common/enum_state.dart';
import 'package:submission_story_app/data/api/api_service.dart';
import 'package:submission_story_app/data/model/detail_story_model.dart';
import 'package:submission_story_app/data/preferences.dart';

class DetailStoryProvider extends ChangeNotifier {
  ResponseState responseState = ResponseState.initial;
  final ApiService apiService = ApiService();

  Story? _detailStoryModel;
  Story? get detailStoryModel => _detailStoryModel;

  String _message = "";
  String get message => _message;

  Future<void> fetchDetail(String id) async {
    try {
      responseState = ResponseState.loading;
      notifyListeners();

      final prefs = Preferences();
      await prefs.getPrefs();
      final token = prefs.token;
      final response = await apiService.fetchDetailStory(token!, id);

      if (!response.error) {
        responseState = ResponseState.success;
        _detailStoryModel = response.story;
      } else {
        responseState = ResponseState.failed;
        _message = response.message;
      }
    } catch (error) {
      responseState = ResponseState.failed;
      if (error is SocketException) {
        _message = AppConst.errorInternet;
      } else {
        _message = "An error has occurred: $error";
      }
    } finally {
      notifyListeners();
    }
  }
}
