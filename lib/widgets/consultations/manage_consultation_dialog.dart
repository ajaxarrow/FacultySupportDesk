import 'package:facultysupportdesk/models/consultation_request.dart';
import 'package:flutter/material.dart';

class ManageConsultationDialog extends StatelessWidget {
  const ManageConsultationDialog({
    super.key,
    required this.consultation,
    required this.onUpdateConsultationList
  });

  final ConsultationRequest consultation;
  final Function() onUpdateConsultationList;

  @override
  Widget build(BuildContext context) {
    final facultyCommentController = TextEditingController();

    return Padding(
      padding: EdgeInsets.all(20),
      child: SizedBox(
        width: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('Manage Consultation Requests'),
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
            TextField(
              controller: facultyCommentController,
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.note),
                  hintText: 'Enter Note'
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
                        ConsultationRequest(
                          id: consultation.id,
                          facultyComment: facultyCommentController.text,
                          status: 'Declined'
                        ).manageConsultationRequest();
                        onUpdateConsultationList();
                        Navigator.pop(context);
                      },
                      child: const Text(
                          'Decline Request',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
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
                        ConsultationRequest(
                            id: consultation.id,
                            facultyComment: facultyCommentController.text,
                            status: 'Approved'
                        ).manageConsultationRequest();
                        onUpdateConsultationList();
                        Navigator.pop(context);
                      },
                      child: const Text(
                          'Accept Request',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
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
    );
  }
}
