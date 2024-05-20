import 'package:facultysupportdesk/models/schedule.dart';
import 'package:facultysupportdesk/widgets/schedules/schedule_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ScheduleList extends StatelessWidget {
  const ScheduleList({
    super.key,
    required this.schedules,
    required this.onRemoveSchedule,
    required this.onScheduleActivityList
  });

  final void Function(String id) onRemoveSchedule;
  final List<Schedule> schedules;
  final Function() onScheduleActivityList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: schedules.length,
      itemBuilder: (ctx, index) =>
        Dismissible(
            confirmDismiss: (direction) async {
              if (FirebaseAuth.instance.currentUser?.uid != schedules[index].facultyID){
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      duration: Duration(seconds: 2),
                      content: Text("Deletion Prohibited! You cannot delete someone's schedule"),
                    ));
                return false;
              }
              else{
                return true;
              }
            },
            background: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Theme.of(context).colorScheme.error.withOpacity(0.85),
              ),

              margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16
              ),

            ),
            key: ValueKey(schedules[index]),
            onDismissed: (direction){
              onRemoveSchedule(schedules[index].id!);
            },
            child: ScheduleItem(
              schedule: schedules[index],
              onUpdateScheduleList: onScheduleActivityList,
            )
        )
    );
  }
}
