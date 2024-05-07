import 'package:facultysupportdesk/models/activity.dart';
import 'package:facultysupportdesk/utils/format_date.dart';
import 'package:facultysupportdesk/widgets/activities/activity_dialog_form.dart';
import 'package:flutter/material.dart';

class ActivityItem extends StatelessWidget {
  const ActivityItem({
    super.key,
    required this.activity,
    required this.onUpdateActivityList,
  });

  final Activity activity;
  final Function() onUpdateActivityList;

  @override
  Widget build(BuildContext context) {
    void showActivityFormDialog() {
      showDialog(
        context: context,
        builder: (ctx) =>
          SimpleDialog(
            children: [
              ActivityDialogForm(
                activity: activity,
                mode: Mode.update,
                onUpdateActivity: onUpdateActivityList,
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
                      activity.activityTitle!,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16
                      )
                  ),
                  const Spacer(),
                  Text('Proposed Time: ${formatTimestamp(activity.timeStart!)} - ${formatTimestamp(activity.timeEnd!)}'),
                ],
              ),
              const SizedBox(
                height: 4,
              ),
              Row(
                children: [
                  Text(activity.activityDescription!),
                  const Spacer(),
                  TextButton.icon(
                      onPressed: showActivityFormDialog,
                      label: const Text('Edit'),
                      icon: const Icon(Icons.edit,
                          size: 16)
                  )
                ],
              )
            ],
          )
      ),
    );
  }
}
