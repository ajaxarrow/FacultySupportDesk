import 'package:facultysupportdesk/layout/main_layout.dart';
import 'package:facultysupportdesk/models/app_user.dart';
import 'package:facultysupportdesk/models/consultation_request.dart';
import 'package:facultysupportdesk/utils/format_date.dart';
import 'package:facultysupportdesk/widgets/consultations/manage_consultation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ConsultationDetailsView extends StatelessWidget {
  const ConsultationDetailsView({
    super.key,
    required this.consultation,
    required this.student,
    required this.isPending,
  });

  final ConsultationRequest consultation;
  final AppUser student;
  final bool isPending;

  @override
  Widget build(BuildContext context) {
    void showManageConsultationDialog() {
      showDialog(
          context: context,
          builder: (ctx) =>
              SimpleDialog(
                children: [
                  ManageConsultationDialog(
                    consultation: consultation,
                    onUpdateConsultationList: (){
                      Navigator.of(context).pushReplacementNamed('/history');
                    },
                  )
                ],
              )
      );
    }

    return MainLayout(
      role: Role.faculty,
      title: 'Consultation Request Details',
      index: isPending ? 0 : 1,
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
                    if(isPending){
                      Navigator.of(context).pushReplacementNamed('/main');
                    } else {
                      Navigator.of(context).pushReplacementNamed('/history');
                    }
                  },
                  icon: const PhosphorIcon(PhosphorIconsRegular.arrowLeft),
                  label: isPending ? const Text('Back to Pending Consultations') : const Text('Back to Consultation History')
                ),
                const SizedBox(height:  20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          consultation.requestTitle!,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16
                          ),
                        ),
                        Text(consultation.requestDescription!)
                      ],
                    ),
                    isPending ? ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20)
                        ),
                        icon: const PhosphorIcon(PhosphorIconsRegular.pencil),
                        onPressed: showManageConsultationDialog,
                        label: const Text('Manage Request'),
                      ),
                    )
                        :  const SizedBox.shrink()
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
                          const Text('Requestor Name'),
                          Text(student.name!)
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Requestor Email'),
                          Text(student.email!),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Proposed Time'),
                          Text('${formatTimestamp(consultation.proposedTimeStart!)} - ${formatTimestamp(consultation.proposedTimeEnd!)}')
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Status'),
                          Text(consultation.status!),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Status Update Date'),
                          Text(formatTimestamp(consultation.statusUpdateDate!)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: consultation.facultyComment != null ?
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Your Comment'),
                          Text(consultation.facultyComment!),
                        ],
                      ) :
                      const SizedBox.shrink(),
                    ),
                  ],
                )


              ],
            ),
          ),
        ),
    );
  }
}
