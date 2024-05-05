import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facultysupportdesk/models/app_user.dart';
import 'package:facultysupportdesk/models/consultation_request.dart';
import 'package:facultysupportdesk/widgets/consultations/manage_consultation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ConsultationItem extends StatefulWidget {
  const ConsultationItem({
    super.key,
    required this.consultation,
    required this.onUpdateConsultationList
  });

  final ConsultationRequest consultation;
  final Function() onUpdateConsultationList;

  @override
  State<ConsultationItem> createState() => _ConsultationItemState();
}

class _ConsultationItemState extends State<ConsultationItem> {
  AppUser? student;


  Future<void> fetchStudent() async {
    student = await AppUser().getUserById(widget.consultation!.studentID!);
  }


  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate(); // Convert Timestamp to DateTime
    String formattedDate = DateFormat.yMMMMd().format(dateTime); // Format date
    String formattedTime = DateFormat.jm().format(dateTime); // Format time
    return '$formattedDate $formattedTime';
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

    return FutureBuilder(
        future: fetchStudent(),
        builder: (ctx, snapshot) {
          Widget body;
          if (snapshot.connectionState == ConnectionState.waiting) {
            body = const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            body = Center(child: Text('Error: ${snapshot.error}'));
          }

          if(student != null){
            body = Column(
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
                          Icon(Icons.person),
                          Text(student!.name!)
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
                    TextButton.icon(
                        onPressed: showManageConsultationDialog,
                        label: const Text('Manage Request'),
                        icon: const Icon(Icons.edit_calendar,
                            size: 16)
                    )
                  ],
                )
              ],
            );
          } else {
            body = const Center(child: CircularProgressIndicator());
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
                child: body
            ),
          );
        }
    );
  }
}
