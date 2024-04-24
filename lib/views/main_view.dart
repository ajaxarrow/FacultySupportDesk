import 'package:facultysupportdesk/layout/main_layout.dart';
import 'package:flutter/material.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainLayout(index: 0, content: Text('Consultations'),);
  }
}
