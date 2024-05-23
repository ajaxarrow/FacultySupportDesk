import 'package:facultysupportdesk/layout/main_layout.dart';
import 'package:facultysupportdesk/models/activity.dart';
import 'package:facultysupportdesk/widgets/activities/activity_dialog_form.dart';
import 'package:facultysupportdesk/widgets/activities/activity_list.dart';
import 'package:flutter/material.dart';
import 'package:facultysupportdesk/route_guards.dart';


class ActivitiesView extends StatefulWidget {
  const ActivitiesView({super.key});


  @override
  State<ActivitiesView> createState() => _ActivitiesViewState();

}

class _ActivitiesViewState extends State<ActivitiesView> {
  List<Activity> _activities = [];



  Future<void> fetchActivities() async {
    _activities.clear();
    _activities = await Activity().getActivitiesByFacultyID();
  }

  void _refreshList(){
    setState(() {

    });
  }

  void _removeActivity(String id) async {
    await Activity(id: id).deleteActivity();
    _refreshList();
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 2),
          content: Text("Activity Deleted!"),
        )
    );
  }

  void showActivityFormDialog() {
    showDialog(
      context: context,
      builder: (ctx) =>
          SimpleDialog(
            children: [
              ActivityDialogForm(
                mode: Mode.create,
                onAddActivity: _refreshList,
              )
            ],
          )
    );
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
        future: fetchActivities(),
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
                        fontSize:  50
                    ),
                  ),
                  SizedBox(height:  5),
                  Text(
                      'There are no activities scheduled.'
                  )
                ],
              ),
            );

            if (_activities.isNotEmpty) {
              mainContent = ActivityList(
                activities: _activities,
                onUpdateActivityList: _refreshList,
                onRemoveActivity: _removeActivity,
              );
            }

            body = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height:  10),
                _activities.isNotEmpty ? const Padding(
                  padding: EdgeInsets.only(left:  15,  bottom:  5),
                  child: Text(
                    'Scheduled Activities',
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize:  18
                    ),
                  ),
                ) : const SizedBox.shrink(),
                Expanded(child: mainContent),
              ],
            );
          }

          return MainLayout(
            role: Role.faculty,
            title: 'Your Activities',
            index: 3,
            content: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: RefreshIndicator(
                onRefresh: () async{
                  await fetchActivities();
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    duration: Duration(seconds: 2),
                    content: Text("Scheduled Activities List Updated"),
                  ));
                },
                child: Scaffold(
                  body: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: body,
                  ),
                  floatingActionButton: FloatingActionButton(
                    onPressed: showActivityFormDialog,
                    child: const Icon(Icons.add),
                  ),
                )
              ),
            ),
          );

        }
    );
  }
}
