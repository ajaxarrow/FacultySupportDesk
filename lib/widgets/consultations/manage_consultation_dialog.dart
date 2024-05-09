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
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xffdae2f3),
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
                              status: 'Declined'
                          ));
                        },
                        child: const Text(
                            'Decline Request',
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
                              status: 'Approved'
                          ));
                        },
                        child: const Text(
                            'Accept Request',
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
