import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission_story_app/data/preferences.dart';
import 'package:submission_story_app/ui/pages/add_story_page.dart';
import 'package:submission_story_app/ui/pages/detail_story_page.dart';
import 'package:submission_story_app/ui/pages/home_page.dart';
import 'package:submission_story_app/ui/pages/login_page.dart';
import 'package:submission_story_app/ui/pages/register_page.dart';
import 'package:submission_story_app/ui/pages/setting_page.dart';
import 'package:submission_story_app/ui/pages/splash_screen_page.dart';

import '../provider/list_story_provider.dart';
import '../ui/pages/introduction_page.dart';

class RouterDelegates extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final GlobalKey<NavigatorState> _navigatorKey;

  RouterDelegates() : _navigatorKey = GlobalKey<NavigatorState>() {
    _init();
  }

  _init() async {
    final prefs = Preferences();
    await prefs.getPrefs();
    token = prefs.token ?? '';
    isFirstTime = prefs.isFirst;
    await Future.delayed(const Duration(seconds: 2));
    notifyListeners();
  }

  String? storyId;
  List<Page> listStack = [];
  String token = '';
  bool isFirstTime = true;
  bool isRegister = false;
  bool isSetting = false;
  bool isAddPost = false;
  bool isDetail = false;

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  @override
  Widget build(BuildContext context) {
    listStack = listStack.isEmpty
        ? _splashStack
        : (token.isNotEmpty ? _loggedInStack : _loggedOutStack);

    return Navigator(
      key: navigatorKey,
      pages: listStack,
      onDidRemovePage: (Page<Object?> page) {
        listStack.remove(page);
        isRegister = false;
        isSetting = false;
        isAddPost = false;
        isDetail = false;
        notifyListeners();
      },
    );
  }

  List<Page> get _splashStack => [
        const MaterialPage(
            key: ValueKey('splashPage'), child: SplashScreenPage()),
      ];

  List<Page> get _loggedOutStack => [
        if (isFirstTime)
          MaterialPage(
              key: const ValueKey('introductionPage'),
              child: IntroductionPage(
                onDone: () {
                  isFirstTime = false;
                  notifyListeners();
                },
              ))
        else
          MaterialPage(
              key: const ValueKey('loginPage'),
              child: LoginPage(
                processLogin: (String value) {
                  token = value;
                  notifyListeners();
                },
                toRegisterPage: () {
                  isRegister = true;
                  notifyListeners();
                },
              )),
        if (isRegister == true)
          MaterialPage(
              child: RegisterPage(
            processRegister: () {
              navigatorKey.currentState?.pop();
            },
            toLoginPage: () {
              navigatorKey.currentState?.pop();
            },
          ))
      ];

  List<Page> get _loggedInStack => [
        MaterialPage(
            key: const ValueKey('homePage'),
            child: HomePage(
              toSettingPage: () {
                isSetting = true;
                notifyListeners();
              },
              toAddPost: () {
                isAddPost = true;
                notifyListeners();
              },
              toDetail: (String? value) {
                isDetail = true;
                storyId = value;
                notifyListeners();
              },
            )),
        if (isSetting == true)
          MaterialPage(child: SettingPage(
            onLogout: () {
              token = "";
              isRegister = false;
              notifyListeners();
            },
          )),
        if (isAddPost)
          MaterialPage(child: AddStoryPage(
            onPostStory: () {
              navigatorKey.currentState?.pop();
              Provider.of<ListStoryProvider>(navigatorKey.currentContext!,
                      listen: false)
                  .fetchListStory();
            },
          )),
        if (isDetail) MaterialPage(child: DetailStoryPage(id: storyId!)),
      ];

  @override
  Future<void> setNewRoutePath(configuration) async {}
}
