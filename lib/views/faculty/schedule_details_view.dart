import 'package:facultysupportdesk/models/schedule.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../layout/main_layout.dart';
import '../../utils/format_date.dart';
import '../../widgets/schedules/schedule_form_dialog.dart';

class ScheduleDetailsView extends StatelessWidget {
  const ScheduleDetailsView({
    super.key,
    required this.schedule
  });

  final Schedule schedule;

  @override
  Widget build(BuildContext context) {

    void showScheduleFormDialog() {
      showDialog(
          context: context,
          builder: (ctx) =>
              SimpleDialog(
                children: [
                  ScheduleFormDialog(
                    mode: Mode.update,
                    schedule: schedule,
                    onUpdateSchedule: (){
                      Navigator.of(context).pop();
                    },
                  )
                ],
              )
      );
    }

    return MainLayout(
      role: Role.faculty,
      title: 'Schedule Details',
      index: 4,
      content: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height:  10),
              TextButton.icon(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  icon: const PhosphorIcon(PhosphorIconsRegular.arrowLeft),
                  label: const Text('Back to Schedule List')
              ),
              const SizedBox(height:  20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          schedule.title!,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16
                          ),
                        ),
                      ],
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20)
                      ),
                      icon: const PhosphorIcon(PhosphorIconsRegular.pencil),
                      onPressed: showScheduleFormDialog,
                      label: const Text('Edit'),
                    ),
                  )
                ],
              ),
              const SizedBox(height:  5),
              const Divider(),
              const SizedBox(height:  10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Time Start'),
                        Text(formatTimestamptoTime(schedule.timeStart!))
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Time End'),
                        Text(formatTimestamptoTime(schedule.timeEnd!)),
                      ],
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}
