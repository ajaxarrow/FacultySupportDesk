import 'package:facultysupportdesk/main.dart';
import 'package:facultysupportdesk/models/app_user.dart';
import 'package:facultysupportdesk/models/consultation_request.dart';
import 'package:facultysupportdesk/services/mail_sender.dart';
import 'package:flutter/material.dart';

class ManageConsultationDialog extends StatefulWidget {
  const ManageConsultationDialog({
    super.key,
    required this.consultation,
    required this.onUpdateConsultationList
  });

  final ConsultationRequest consultation;
  final Function() onUpdateConsultationList;

  @override
  State<ManageConsultationDialog> createState() => _ManageConsultationDialogState();
}

class _ManageConsultationDialogState extends State<ManageConsultationDialog> {
  bool isLoading = false;
  String selectedStatus = 'Declined';
  String selectedRoom = 'Room 1';
  @override
  Widget build(BuildContext context) {
    final facultyCommentController = TextEditingController();
    final form = GlobalKey<FormState>();

    Future<void> sendEmail(ConsultationRequest consultation)async {
      AppUser student = await AppUser().getUserById(consultation.studentID!);
      AppUser faculty = await AppUser().getUserById(consultation.facultyID!);
      await MailSender(
          consultation: consultation,
          faculty: faculty,
          student: student
      ).sendEmail();
    }

    Future<void> save(ConsultationRequest consultationRequest) async{
      setState(() {
        isLoading = true;
      });
      final isValid = form.currentState!.validate();
      if(!isValid){
        return;
      }
      form.currentState!.save();
      consultationRequest.manageConsultationRequest();
      await sendEmail(consultationRequest);
      setState(() {
        isLoading = false;
      });
      Navigator.pop(context);
      widget.onUpdateConsultationList();
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(seconds: 2),
        content: Text("Consultation Request ${consultationRequest.status}"),
      ));
    }





    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        width: 300,
        child: isLoading ? const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 50),
            child: CircularProgressIndicator(),
          ),
        ) : Form(
          key: form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Manage Consultation Requests',
                  style: TextStyle(
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
              const Text('Comment:', style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              TextFormField(
                validator: (value){
                  if (value!.trim().isEmpty || value == null){
                    return 'Comment must not be empty';
                  }
                  return null;
                },
                controller: facultyCommentController,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.comment),
                    hintText: 'Enter Comment'
                ),
              ),
              const SizedBox(height: 25),
              const Text('Response:', style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              DropdownButton(
                  value: selectedStatus,
                  items: const [
                    DropdownMenuItem(
                        value: 'Approved',
                        child: Text('Approved')
                    ),
                    DropdownMenuItem(
                        value: 'Declined',
                        child: Text('Declined')
                    ),
                  ],
                  onChanged: (value){
                    setState(() {
                      selectedStatus = value!;
                    });
                  }
              ),
              selectedStatus == 'Approved' ? const SizedBox(height: 25) : const SizedBox.shrink(),
              selectedStatus == 'Approved' ? const Text('Room:', style: TextStyle(fontWeight: FontWeight.w500)) : const SizedBox.shrink(),
              selectedStatus == 'Approved' ? const SizedBox(height: 8) : const SizedBox.shrink(),
              selectedStatus == 'Approved' ? DropdownButton(
                  value: selectedRoom,
                  items: const [
                    DropdownMenuItem(
                        value: 'Room 1',
                        child: Text('Room 1')
                    ),
                    DropdownMenuItem(
                        value: 'Room 2',
                        child: Text('Room 2')
                    ),
                    DropdownMenuItem(
                        value: 'Room 3',
                        child: Text('Room 3')
                    ),
                    DropdownMenuItem(
                        value: 'Lab 21',
                        child: Text('Lab 21')
                    ),
                    DropdownMenuItem(
                        value: 'Lab 22',
                        child: Text('Lab 22')
                    ),
                    DropdownMenuItem(
                        value: 'Lab 23',
                        child: Text('Lab 23')
                    ),
                    DropdownMenuItem(
                        value: 'Lab 24',
                        child: Text('Lab 24 ')
                    ),
                    DropdownMenuItem(
                        value: 'Lab 25',
                        child: Text('Lab 25')
                    ),
                    DropdownMenuItem(
                        value: 'Lab 26',
                        child: Text('Lab 26')
                    ),
                    DropdownMenuItem(
                        value: 'Conference Room',
                        child: Text('Conference Room')
                    ),
                    DropdownMenuItem(
                        value: 'Training Room',
                        child: Text('Training Room')
                    ),
                    DropdownMenuItem(
                        value: 'Faculty Office',
                        child: Text('Faculty Office')
                    ),
                    DropdownMenuItem(
                        value: 'SDD',
                        child: Text('SDD')
                    ),
                  ],
                  onChanged: (value){
                    setState(() {
                      selectedRoom = value!;
                    });
                  }
              ) : const SizedBox.shrink(),
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
                        onPressed: (){
                          save(ConsultationRequest(
                              id: widget.consultation.id,
                              studentID: widget.consultation.studentID,
                              facultyID: widget.consultation.facultyID,
                              requestTitle: widget.consultation.requestTitle,
                              requestDescription: widget.consultation.requestDescription,
                              proposedTimeStart: widget.consultation.proposedTimeStart,
                              proposedTimeEnd: widget.consultation.proposedTimeEnd,
                              facultyComment: facultyCommentController.text,
                              room: selectedRoom,
                              status: selectedStatus,
                          ));
                        },
                        child: const Text(
                            'Send Request',
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
