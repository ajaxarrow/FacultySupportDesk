import 'package:facultysupportdesk/layout/main_layout.dart';
import 'package:facultysupportdesk/models/activity.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../route_guards.dart';


class CalendarOfActivitiesView extends StatefulWidget {
  const CalendarOfActivitiesView({super.key});

  @override
  State<CalendarOfActivitiesView> createState() =>
      _CalendarOfActivitiesViewState();
}

class _CalendarOfActivitiesViewState extends State<CalendarOfActivitiesView> {
  List<Appointment> _appointments = <Appointment>[];

  CalendarView _currentView = CalendarView.month;

  Future<void> fetchAppointments() async {
    _appointments.clear();
    _appointments = await Activity().getAppointmentsByFacultyID();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isAuthenticated('faculty', context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchAppointments(),
      builder: (ctx, snapshot) {
        Widget body;
        if (snapshot.connectionState == ConnectionState.waiting) {
          body = const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          body = Center(child: Text('Error: ${snapshot.error}'));
        } else {
          body = Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [SizedBox(
                    height: 50,
                    child: DropdownButton<CalendarView>(
                      alignment: Alignment.bottomCenter,
                      value: _currentView,
                      onChanged: (newValue) {
                        setState(() {
                          _currentView = newValue!;
                        });
                      },
                      items: const [
                        DropdownMenuItem(
                          value: CalendarView.schedule,
                          child: Text('Schedule View'),
                        ),
                        DropdownMenuItem(
                          value: CalendarView.timelineDay,
                          child: Text('Timeline View'),
                        ),
                        DropdownMenuItem(
                          value: CalendarView.workWeek,
                          child: Text('Workweek View'),
                        ),
                        DropdownMenuItem(
                          value: CalendarView.day,
                          child: Text('Day View'),
                        ),
                        DropdownMenuItem(
                          value: CalendarView.week,
                          child: Text('Week View'),
                        ),
                        DropdownMenuItem(
                          value: CalendarView.month,
                          child: Text('Month View'),
                        ),
                      ],
                    ),
                  ),],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SfCalendar(
                    initialSelectedDate: DateTime.now(),
                    monthViewSettings: const MonthViewSettings(
                      showAgenda: true,
                      agendaViewHeight: 200,
                    ),
                    allowViewNavigation: true,
                    allowedViews: const <CalendarView>[
                      CalendarView.day,
                      CalendarView.schedule,
                      CalendarView.month,
                      CalendarView.week
                    ],
                    showNavigationArrow: true,
                    showCurrentTimeIndicator: true,
                    showTodayButton: true,
                    view: _currentView,
                    dataSource: _getCalendarDataSource(_appointments),
                    timeSlotViewSettings: const TimeSlotViewSettings(
                      timeIntervalHeight: 100,
                    ),
                    showDatePickerButton: true,
                  ),
                ),
              ),
              // Expanded(
              //   child: Padding(
              //     padding: const EdgeInsets.all(20.0),
              //     child: SfCalendar(
              //
              //       // allowViewNavigation: true,
              //       showNavigationArrow: true,
              //       showCurrentTimeIndicator: true,
              //       view: CalendarView.month,
              //       dataSource: _getCalendarDataSource(_appointments),
              //       showDatePickerButton: true,
              //     ),
              //   ),
              // ),
            ],
          );
        }

        return MainLayout(
          role: Role.faculty,
          title: 'Calendar of Activities',
          index: 2,
          content: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Scaffold(body: body),
          ),
        );
      },
    );
  }

  _DataSource _getCalendarDataSource(List<Appointment> appointments) {
    return _DataSource(appointments);
  }
}

class _DataSource extends CalendarDataSource {
  _DataSource(List<Appointment> source) {
    appointments = source;
  }
}
