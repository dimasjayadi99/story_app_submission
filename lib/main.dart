import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:submission_story_app/common/app_style.dart';
import 'package:submission_story_app/provider/add_story_provider.dart';
import 'package:submission_story_app/provider/detail_story_provider.dart';
import 'package:submission_story_app/provider/list_story_provider.dart';
import 'package:submission_story_app/provider/login_provider.dart';
import 'package:submission_story_app/provider/register_provider.dart';
import 'package:submission_story_app/routes/route_delegate.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  dotenv.load(fileName: '.env');
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => LoginProvider()),
    ChangeNotifierProvider(create: (context) => RegisterProvider()),
    ChangeNotifierProvider(create: (context) => ListStoryProvider()),
    ChangeNotifierProvider(create: (context) => AddStoryProvider()),
    ChangeNotifierProvider(create: (context) => DetailStoryProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  late RouterDelegates routerDelegate;

  @override
  void initState() {
    super.initState();
    routerDelegate = RouterDelegates();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(textTheme: AppStyle.myTextTheme),
      home: Router(
        routerDelegate: routerDelegate,
        backButtonDispatcher: RootBackButtonDispatcher(),
      ),
    );
  }
}
