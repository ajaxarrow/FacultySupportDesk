import 'package:facultysupportdesk/models/schedule.dart';
import 'package:facultysupportdesk/utils/format_date.dart';
import 'package:flutter/material.dart';

enum Mode{update, create}
enum Type{start, end}

class ScheduleFormDialog extends StatefulWidget {
  const ScheduleFormDialog({
    super.key,
    this.schedule,
    this.mode,
    this.onAddSchedule,
    this.onUpdateSchedule
  });

  final void Function()? onAddSchedule;
  final void Function()? onUpdateSchedule;
  final Mode? mode;
  final Schedule? schedule;

  @override
  State<ScheduleFormDialog> createState() => _ScheduleFormDialogState();
}

class _ScheduleFormDialogState extends State<ScheduleFormDialog> {
  final _form = GlobalKey<FormState>();
  TimeOfDay timeStart= TimeOfDay.now();
  TimeOfDay timeEnd = TimeOfDay.now();
  final scheduleTitle = TextEditingController();
  String selectedSemester = '1st Semester';

  Future<void> _selectTime(TimeOfDay selectedTime, Type type) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (pickedTime != null && pickedTime != selectedTime) {
      if(type == Type.start){
        setState(() {
          timeStart = pickedTime;
        });
      } else {
        setState(() {
          timeEnd = pickedTime;
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.schedule != null){
      scheduleTitle.text = widget.schedule!.title!;
      timeStart = convertTimestampToTimeOfDay(widget.schedule!.timeStart!);
      timeEnd = convertTimestampToTimeOfDay(widget.schedule!.timeEnd!);
      setState(() {
        selectedSemester = widget.schedule!.semester!;
      });
    }
  }

  void addSchedule(Schedule schedule) async{
    await schedule.addSchedule();
    widget.onAddSchedule!();
    Navigator.pop(context);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      duration: Duration(seconds: 2),
      content: Text("Schedule Added!"),
    ));
  }

  void updateSchedule(Schedule schedule) async{
    await schedule.updateSchedule();
    widget.onUpdateSchedule!();
    Navigator.pop(context);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      duration: Duration(seconds: 2),
      content: Text("Schedule Updated!"),
    ));
  }

  void submitSchedule() {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    if (widget.mode == Mode.create) {
      addSchedule(Schedule(
        title: scheduleTitle.text,
        semester: selectedSemester,
        timeStart: convertTimeOfDayToTimeStamp(timeStart),
        timeEnd: convertTimeOfDayToTimeStamp(timeEnd)
      ));
    } else {
      updateSchedule(Schedule(
        title: scheduleTitle.text,
        semester: selectedSemester,
        timeStart: convertTimeOfDayToTimeStamp(timeStart),
        timeEnd: convertTimeOfDayToTimeStamp(timeEnd),
        id: widget.schedule!.id!
      ));
    }
  }
    

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        width: 400,
        child: Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    widget.mode == Mode.create
                        ? 'Add Schedule'
                        : 'Update Schedule',
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
              const Text('Schedule Title:', style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              TextFormField(
                validator: (value){
                  if (value!.trim().isEmpty || value == null){
                    return 'Title must not be empty';
                  }
                  return null;
                },
                controller: scheduleTitle,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.title),
                    hintText: 'Enter Title'
                ),
              ),
              const SizedBox(height: 25),
              const Text('Semester:', style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              DropdownButton(
                value: selectedSemester,
                items: const [
                  DropdownMenuItem(
                    value: '1st Semester',
                    child: Text('1st Semester')
                  ),
                  DropdownMenuItem(
                      value: '2nd Semester',
                      child: Text('2nd Semester')
                  ),
                  DropdownMenuItem(
                      value: 'Midyear',
                      child: Text('Midyear')
                  )
                ],
                onChanged: (value){
                  setState(() {
                    selectedSemester = value!;
                  });
                }
              ),
              const SizedBox(height: 25),
              Text('Schedule: (Selected: ${formatTimestamptoTime(convertTimeOfDayToTimeStamp(timeStart))} - ${formatTimestamptoTime(convertTimeOfDayToTimeStamp(timeEnd))})',
                  style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              Row(
                children: [
                  ElevatedButton(
                      onPressed: (){
                        _selectTime(timeStart, Type.start);
                      },
                      child: const Text('Select Start Time')
                  ),
                  const SizedBox(width: 5,),
                  ElevatedButton(
                      onPressed: (){
                        _selectTime(timeEnd, Type.end);
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
                        onPressed: submitSchedule,
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
