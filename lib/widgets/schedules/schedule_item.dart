import 'package:facultysupportdesk/models/schedule.dart';
import 'package:facultysupportdesk/utils/format_date.dart';
import 'package:facultysupportdesk/widgets/schedules/schedule_form_dialog.dart';
import 'package:flutter/material.dart';

class ScheduleItem extends StatelessWidget {
  const ScheduleItem({
    super.key,
    required this.schedule,
    required this.onUpdateScheduleList
  });

  final Schedule schedule;
  final Function() onUpdateScheduleList;

  @override
  Widget build(BuildContext context) {
    bool isLarge = MediaQuery.of(context).size.width > 900;

    void showScheduleFormDialog() {
      showDialog(
          context: context,
          builder: (ctx) =>
              SimpleDialog(
                children: [
                  ScheduleFormDialog(
                    mode: Mode.update,
                    schedule: schedule,
                    onUpdateSchedule: onUpdateScheduleList,
                  )
                ],
              )
      );
    }

    return Card(
      margin: const EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 15
      ),
      child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 20
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                      schedule.title!,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16
                      )
                  ),
                  const Spacer(),
                  Text(schedule.semester!)
                  // isLarge ? Text(schedule.semester!) : const SizedBox.shrink(),
                ],
              ),
              const SizedBox(
                height: 4,
              ),
              Row(
                children: [
                  Text('${formatTimestamptoTime(schedule.timeStart!)} - ${formatTimestamptoTime(schedule.timeEnd!)}'),
                  const Spacer(),
                  isLarge ? TextButton.icon(
                      onPressed: showScheduleFormDialog,
                      label: const Text('Edit'),
                      icon: const Icon(Icons.edit,
                          size: 16)
                  ) : const SizedBox.shrink(),
                ],
              )
            ],
          )
      ),
    );
  }
}
