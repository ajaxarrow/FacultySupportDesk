import 'package:facultysupportdesk/models/activity.dart';
import 'package:facultysupportdesk/widgets/activities/activity_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ActivityList extends StatelessWidget {
  const ActivityList({
    super.key,
    required this.onUpdateActivityList,
    required this.activities,
    required this.onRemoveActivity
  });

  final void Function(String id) onRemoveActivity;
  final List<Activity> activities;
  final Function() onUpdateActivityList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: activities.length,
        itemBuilder: (ctx, index) =>
            Dismissible(
                confirmDismiss: (direction) async {
                  if (FirebaseAuth.instance.currentUser?.uid != activities[index].facultyID){
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          duration: Duration(seconds: 2),
                          content: Text("Deletion Prohibited! You cannot delete someone's activities"),
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
                key: ValueKey(activities[index]),
                onDismissed: (direction){
                  onRemoveActivity(activities[index].id!);
                },
                child: ActivityItem(
                  activity: activities[index],
                  onUpdateActivityList: onUpdateActivityList,
                )
            )
    );
  }
}
