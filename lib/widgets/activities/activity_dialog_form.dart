import 'package:facultysupportdesk/models/activity.dart';
import 'package:facultysupportdesk/utils/format_date.dart';
import 'package:flutter/material.dart';

enum Mode{update, create}
enum Type{start, end}

class ActivityDialogForm extends StatefulWidget {
  const ActivityDialogForm({
    super.key,
    this.activity,
    this.mode,
    this.onAddActivity,
    this.onUpdateActivity
  });

  final void Function()? onAddActivity;
  final void Function()? onUpdateActivity;
  final Mode? mode;
  final Activity? activity;

  @override
  State<ActivityDialogForm> createState() => _ActivityDialogFormState();
}

class _ActivityDialogFormState extends State<ActivityDialogForm> {
  bool isLoading = false;
  final _form = GlobalKey<FormState>();
  final activityTitleController = TextEditingController();
  final activityDescriptionController = TextEditingController();
  DateTime activityDateStart = DateTime.now();
  TimeOfDay activityTimeStart= TimeOfDay.now();
  DateTime activityDateEnd = DateTime.now();
  TimeOfDay activityTimeEnd = TimeOfDay.now();

  Future<void> _selectDate(DateTime selectedDate, Type type) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      if(type == Type.start){
        setState(() {
          activityDateStart = pickedDate;
        });
      } else {
        setState(() {
          activityDateEnd = pickedDate;
        });
      }
    }
  }

  Future<void> _selectTime(TimeOfDay selectedTime, Type type) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (pickedTime != null && pickedTime != selectedTime) {
      if(type == Type.start){
        setState(() {
          activityTimeStart = pickedTime;
        });
      } else {
        setState(() {
          activityTimeEnd = pickedTime;
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.activity != null){
      activityTitleController.text = widget.activity!.activityTitle!;
      activityDescriptionController.text = widget.activity!.activityDescription!;
      activityDateStart = convertTimestampToDateTime(widget.activity!.timeStart!);
      activityDateEnd = convertTimestampToDateTime(widget.activity!.timeEnd!);
      activityTimeStart = convertTimestampToTimeOfDay(widget.activity!.timeStart!);
      activityTimeEnd = convertTimestampToTimeOfDay(widget.activity!.timeEnd!);
    }
  }

  void addActivity(Activity activity) async{
    await activity.addActivity();
    widget.onAddActivity!();
    Navigator.pop(context);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      duration: Duration(seconds: 2),
      content: Text("Activity Added!"),
    ));
  }

  void updateActivity(Activity activity) async{
    await activity.updateActivity();
    widget.onUpdateActivity!();
    Navigator.pop(context);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      duration: Duration(seconds: 2),
      content: Text("Activity Updated!"),
    ));
  }

  void submitActivity(){
    setState(() {
      isLoading = true;
    });
    final isValid = _form.currentState!.validate();
    if(!isValid){
      return;
    }
    _form.currentState!.save();
    if (widget.mode == Mode.create) {
      addActivity(
        Activity(
          activityTitle: activityTitleController.text,
          activityDescription: activityDescriptionController.text,
          timeStart: convertToFirebaseTimestamp(activityDateStart, activityTimeStart),
          timeEnd: convertToFirebaseTimestamp(activityDateEnd, activityTimeEnd)
        )
      );
    } else {
      updateActivity(
        Activity(
          activityTitle: activityTitleController.text,
          activityDescription: activityDescriptionController.text,
          timeStart: convertToFirebaseTimestamp(activityDateStart, activityTimeStart),
          timeEnd: convertToFirebaseTimestamp(activityDateEnd, activityTimeEnd),
          id: widget.activity!.id!
        )
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        width: 400,
        child: isLoading ? const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 70),
            child: CircularProgressIndicator(),
          ),
        ) :  Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    widget.mode == Mode.create
                        ? 'Add Activity'
                        : 'Update Activity',
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close_rounded))
                ],
              ),
              const SizedBox(height: 25),
              const Text('Activity Title:', style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              TextFormField(
                validator: (value){
                  if (value!.trim().isEmpty || value == null){
                    return 'Title must not be empty';
                  }
                  return null;
                },
                controller: activityTitleController,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.title),
                    hintText: 'Enter Title'
                ),
              ),
              const SizedBox(height: 25),
              const Text('Activity Description:', style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              TextFormField(
                validator: (value){
                  if (value!.trim().isEmpty || value == null){
                    return 'Description must not be empty';
                  }
                  return null;
                },
                controller: activityDescriptionController,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.comment),
                    hintText: 'Enter Description'
                ),
              ),
              const SizedBox(height: 25),
              Text('Time Start: (Selected: ${formatTimestamp(convertToFirebaseTimestamp(activityDateStart, activityTimeStart))})', style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: (){
                      _selectDate(activityDateStart, Type.start);
                    },
                    child: const Text('Select Start Date')
                  ),
                  const SizedBox(width: 5,),
                  ElevatedButton(
                      onPressed: (){
                        _selectTime(activityTimeStart, Type.start);
                      },
                      child: const Text('Select Start Time')
                  )
                ],
              ),
              const SizedBox(height: 25),
              Text('Time End: (Selected: ${formatTimestamp(convertToFirebaseTimestamp(activityDateEnd, activityTimeEnd))})', style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              Row(
                children: [
                  ElevatedButton(
                      onPressed: (){
                        _selectDate(activityDateEnd, Type.end);
                      },
                      child: const Text('Select End Date')
                  ),
                  const SizedBox(width: 5,),
                  ElevatedButton(
                      onPressed: (){
                        _selectTime(activityTimeEnd, Type.end);
                      },
                      child: const Text('Select End Time')
                  )
                ],
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffdae2f3),
                            padding: const EdgeInsets.symmetric(vertical: 19)
                        ),
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                            'Cancel',
                            style: TextStyle(
                                fontSize: 16,
                                color: Color(0xff3b5ba9)
                            )
                        )
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 19)
                        ),
                        onPressed: submitActivity,
                        child: const Text(
                            'Save',
                            style: TextStyle(
                                fontSize: 16
                            )
                        )
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
