import 'package:facultysupportdesk/models/app_user.dart';
import 'package:facultysupportdesk/models/consultation_request.dart';
import 'package:facultysupportdesk/utils/format_date.dart';
import 'package:facultysupportdesk/widgets/consultations/manage_consultation_dialog.dart';
import 'package:flutter/material.dart';


class ConsultationItem extends StatefulWidget {
  const ConsultationItem({
    super.key,
    required this.consultation,
    required this.onUpdateConsultationList,
    required this.isPending
  });

  final ConsultationRequest consultation;
  final Function() onUpdateConsultationList;
  final bool isPending;

  @override
  State<ConsultationItem> createState() => _ConsultationItemState();
}

class _ConsultationItemState extends State<ConsultationItem> {
  String studentName = 'Student Name';


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AppUser().getUserById(widget.consultation!.studentID!).then((value){
      setState(() {
        studentName = value.name!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    void showManageConsultationDialog() {
      showDialog(
        context: context,
        builder: (ctx) =>
          SimpleDialog(
            children: [
              ManageConsultationDialog(
                consultation: widget.consultation,
                onUpdateConsultationList: widget.onUpdateConsultationList,
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
                      widget.consultation.requestTitle!,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16
                      )
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Row(
                      children: [
                        const Icon(Icons.person),
                        Text(studentName)
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 4,
              ),
              Row(
                children: [
                  Text(widget.consultation.requestDescription!),
                ],
              ),
              const SizedBox(
                height: 4,
              ),
              Row(
                children: [
                  Text('Proposed Time: ${formatTimestamp(widget.consultation
                      .proposedTimeStart!)} - ${formatTimestamp(
                      widget.consultation.proposedTimeEnd!)}'),
                  const Spacer(),
                  widget.isPending ? TextButton.icon(
                      onPressed: showManageConsultationDialog,
                      label: const Text('Manage Request'),
                      icon: const Icon(Icons.edit_calendar,
                          size: 16)
                  ) : Text(widget.consultation.status!)
                ],
              )
            ],
          )
      ),
    );

  }
}
