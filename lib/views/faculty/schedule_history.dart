import 'package:facultysupportdesk/layout/main_layout.dart';
import 'package:facultysupportdesk/models/academic_year.dart';
import 'package:facultysupportdesk/models/schedule.dart';
import 'package:facultysupportdesk/widgets/schedules/schedule_form_dialog.dart';
import 'package:facultysupportdesk/widgets/schedules/schedule_list.dart';
import 'package:flutter/material.dart';

import '../../route_guards.dart';

class ScheduleHistory extends StatefulWidget {
  const ScheduleHistory({super.key});

  @override
  State<ScheduleHistory> createState() => _ScheduleHistoryState();
}

class _ScheduleHistoryState extends State<ScheduleHistory> {
  List<Schedule> _schedules = [];
  String selectedSemester = '1st Semester';
  String selectedAcademicYearID = '';
  List<DropdownMenuItem<String>> items = [];



  Future<void> fetchSchedules() async {
    _schedules = await Schedule(
      academicYearID: selectedAcademicYearID,
    ).getScheduleByFacultyIDByAY();
  }


  @override
  void initState() {
    isAuthenticated('faculty', context);
    // TODO: implement initState
    items.clear();
    AcademicYear().getAcademicYears().then((value){
      selectedAcademicYearID = value[0].id!;
      fetchSchedules();
      items = value.map((academicYear) {
        return DropdownMenuItem(
          value: academicYear.id,
          child: Text('${academicYear.yearStart} - ${academicYear.yearEnd} (${academicYear.semester})'),
        );
      }).toList();
      fetchSchedules();
    });

  }


  void _refreshList() {
    setState(() {});
  }

  void _removeSchedule(String id) async {
    await Schedule(id: id).deleteSchedule();
    _refreshList();
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        duration: Duration(seconds: 2),
        content: Text("Schedule Deleted!"),
      ),
    );
  }

  void showScheduleFormDialog() {
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        children: [
          ScheduleFormDialog(
            mode: Mode.create,
            onAddSchedule: _refreshList,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: fetchSchedules(),
      builder: (ctx, snapshot) {
        Widget body;
        if (snapshot.connectionState == ConnectionState.waiting) {
          body = const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          body = Center(child: Text('Error: ${snapshot.error}'));
        } else {
          Widget mainContent = const SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'OOPS!',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 50,
                  ),
                ),
                SizedBox(height: 5),
                Text('There are no schedules added.'),
              ],
            ),
          );

          if (_schedules.isNotEmpty) {
            mainContent = ScheduleList(
              schedules: _schedules,
              onRemoveSchedule: _removeSchedule,
              onScheduleActivityList: _refreshList,
            );
          }

          body = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    const Text('Academic Year: '),
                    DropdownButton<String>(
                      value: selectedAcademicYearID,
                      items: items,
                      onChanged: (value) async {
                        setState(() {
                          selectedAcademicYearID = value!;
                        });
                      },
                    ),
                    const Spacer(),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              _schedules.isNotEmpty
                  ? const Padding(
                padding: EdgeInsets.only(left: 15, bottom: 5),
                child: Text(
                  'Schedules',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
              )
                  : const SizedBox.shrink(),
              Expanded(child: mainContent),
            ],
          );
        }

        return MainLayout(
          role: Role.faculty,
          title: 'Schedule History',
          index: 5,
          content: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: RefreshIndicator(
              onRefresh: () async {
                await fetchSchedules();
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    duration: Duration(seconds: 2),
                    content: Text("Schedule List Updated"),
                  ),
                );
              },
              child: Scaffold(
                body: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: body,
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: showScheduleFormDialog,
                  child: const Icon(Icons.add),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
