import 'package:facultysupportdesk/models/consultation_request.dart';
import 'package:facultysupportdesk/themes/theme.dart';
import 'package:facultysupportdesk/views/activities_view.dart';
import 'package:facultysupportdesk/views/auth_view.dart';
import 'package:facultysupportdesk/views/calendar_view.dart';
import 'package:facultysupportdesk/views/history_view.dart';
import 'package:facultysupportdesk/views/main_view.dart';
import 'package:facultysupportdesk/views/redirect_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      initialRoute: '/redirect',
      routes: {
        '/redirect': (context) => const RedirectView(),
        '/auth': (context) => const AuthView(),
        '/main': (context) => const MainView(),
        '/history': (context) => const HistoryView(),
        '/calendar': (context) => const CalendarOfActivitiesView(),
        '/activities': (context) => const ActivitiesView(),
      },
    );
  }
}
