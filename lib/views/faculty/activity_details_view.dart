import 'package:facultysupportdesk/layout/main_layout.dart';
import 'package:facultysupportdesk/models/activity.dart';
import 'package:facultysupportdesk/widgets/activities/activity_dialog_form.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../utils/format_date.dart';

class ActivityDetailsView extends StatelessWidget {
  const ActivityDetailsView({
    super.key,
    required this.activity
  });

  final Activity activity;

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
                    onUpdateActivity: (){
                      Navigator.of(context).pop();
                    },
                  )
                ],
              )
      );
    }

    return MainLayout(
      role: Role.faculty,
      title: 'Scheduled Activity Details',
      index: 3,
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
                  label: const Text('Back to Scheduled Activities')
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
                          activity.activityTitle!,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16
                          ),
                        ),
                        Text(activity.activityDescription!)
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
                      onPressed: showActivityFormDialog,
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
                        const Text('Start Date'),
                        Text(formatTimestamp(activity.timeStart!))
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('End Date'),
                        Text(formatTimestamp(activity.timeEnd!)),
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
