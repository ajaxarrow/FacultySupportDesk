import 'package:facultysupportdesk/models/consultation_request.dart';
import 'package:facultysupportdesk/themes/theme.dart';
import 'package:facultysupportdesk/views/admin/admin_main_view.dart';
import 'package:facultysupportdesk/views/admin/users_view.dart';
import 'package:facultysupportdesk/views/faculty/activities_view.dart';
import 'package:facultysupportdesk/views/auth_view.dart';
import 'package:facultysupportdesk/views/faculty/calendar_view.dart';
import 'package:facultysupportdesk/views/faculty/history_view.dart';
import 'package:facultysupportdesk/views/faculty/main_view.dart';
import 'package:facultysupportdesk/views/faculty/schedule_history.dart';
import 'package:facultysupportdesk/views/faculty/schedule_view.dart';
import 'package:facultysupportdesk/views/redirect_view.dart';
import 'package:facultysupportdesk/views/registrar/registrar_consultation.dart';
import 'package:facultysupportdesk/views/registrar/registrar_consultation_history.dart';
import 'package:facultysupportdesk/views/registrar/registrar_main_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await dotenv.load(fileName: ".env");

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
        '/faculty/main': (context) => const MainView(),
        '/faculty/history': (context) => const HistoryView(),
        '/faculty/calendar': (context) => const CalendarOfActivitiesView(),
        '/faculty/activities': (context) => const ActivitiesView(),
        '/faculty/schedule': (context) => const ScheduleView(),
        '/faculty/schedule-history': (context) => const ScheduleHistory(),
        '/registrar/main': (context) => const RegistrarMainView(),
        '/registrar/consultation': (context) => const RegistrarConsultation(),
        '/registrar/history': (context) => const RegistrarConsultationHistory(),
        '/admin/main': (context) => const AdminMainView(),
        '/admin/users': (context) => const UsersView(),
        '/admin/consultation': (context) => const RegistrarConsultation(),
        '/admin/history': (context) => const RegistrarConsultationHistory()
      },
    );
  }
}
