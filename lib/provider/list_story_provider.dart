import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:submission_story_app/common/app_const.dart';
import 'package:submission_story_app/common/enum_state.dart';
import 'package:submission_story_app/data/api/api_service.dart';
import 'package:submission_story_app/data/model/list_story_model.dart';
import 'package:submission_story_app/data/preferences.dart';

class ListStoryProvider extends ChangeNotifier {
  ResponseState responseState = ResponseState.initial;
  ApiService apiService = ApiService();

  List<ListStory>? _list;
  List<ListStory>? get list => _list;

  String _message = "";
  String get message => _message;

  Future<void> fetchListStory() async {
    try {
      responseState = ResponseState.loading;
      notifyListeners();

      var prefs = Preferences();
      await prefs.getPrefs();
      var token = prefs.token;
      final response = await apiService.fetchListStory(token ?? '');

      responseState = response.error
          ? ResponseState.failed
          : (response.listStory.isNotEmpty
              ? ResponseState.success
              : ResponseState.empty);

      _list = response.listStory.isNotEmpty ? response.listStory : null;
      _message = response.error
          ? "Failed to load data"
          : response.listStory.isEmpty
              ? "Data not found"
              : "";
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
