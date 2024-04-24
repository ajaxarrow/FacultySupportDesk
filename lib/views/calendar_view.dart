import 'package:facultysupportdesk/layout/main_layout.dart';
import 'package:flutter/material.dart';

class CalendarView extends StatelessWidget {
  const CalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainLayout(index: 2, content: Text('Calendar'),);
  }
}
