import 'package:facultysupportdesk/layout/main_layout.dart';
import 'package:facultysupportdesk/models/app_user.dart';
import 'package:facultysupportdesk/models/consultation_request.dart';
import 'package:facultysupportdesk/utils/format_date.dart';
import 'package:facultysupportdesk/widgets/consultations/manage_consultation_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';


class ConsultationDetailsView extends StatefulWidget {
  const ConsultationDetailsView({
    super.key,
    required this.consultation,
    required this.student,
    required this.isPending,
    required this.faculty
  });



  final ConsultationRequest consultation;
  final AppUser student;
  final AppUser faculty;
  final bool isPending;

  @override
  State<ConsultationDetailsView> createState() => _ConsultationDetailsViewState();
}

class _ConsultationDetailsViewState extends State<ConsultationDetailsView> {
  String role = 'faculty';
  Role get userRole {
    if(role == 'faculty'){
      return Role.faculty;
    } else if(role == 'registrar'){
      return Role.registrar;
    } else {
      return Role.admin;
    }
  }

  int get index {
    if(role == 'faculty'){
      return widget.isPending ? 0 : 1;
    } else if(role == 'registrar'){
      return widget.isPending ? 1 : 2;
    } else {
      return widget.isPending ? 2 : 3;
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AppUser().getUserRoleById(FirebaseAuth.instance.currentUser!.uid!).then((value) =>
      setState(() {
        role = value;
      })
    );
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
                    onUpdateConsultationList: (){
                      Navigator.of(context).pushReplacementNamed('/history');
                    },
                  )
                ],
              )
      );
    }

    return MainLayout(
      role: userRole,
      title: 'Consultation Request Details',
      index: index,
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
                    if(widget.isPending){
                      Navigator.of(context).pop();
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                  icon: const PhosphorIcon(PhosphorIconsRegular.arrowLeft),
                  label: widget.isPending ? const Text('Back to Pending Consultations') : const Text('Back to Consultation History')
                ),
                const SizedBox(height:  20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.consultation.requestTitle!,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16
                            ),
                          ),
                          Text(widget.consultation.requestDescription!)
                        ],
                      ),
                    ),
                    widget.isPending ? ClipRRect(
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
                          Text(widget.student.name!)
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Requestor Email'),
                          Text(widget.student.email!),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height:  10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Faculty Name'),
                          Text(widget.faculty.name!)
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Faculty Email'),
                          Text(widget.faculty.email!),
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
                          Text('${formatTimestamp(widget.consultation.proposedTimeStart!)} - ${formatTimestamp(widget.consultation.proposedTimeEnd!)}')
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Status'),
                          Text(widget.consultation.status!),
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
                          Text(formatTimestamp(widget.consultation.statusUpdateDate!)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: widget.consultation.facultyComment != null ?
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Your Comment'),
                          Text(widget.consultation.facultyComment!),
                        ],
                      ) :
                      const SizedBox.shrink(),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    widget.consultation.status == 'Approved' ? Expanded(
                      child: widget.consultation.room != null ?
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Room'),
                          Text(widget.consultation.room!),
                        ],
                      ) :
                      const SizedBox.shrink(),
                    ) :
                    const SizedBox.shrink(),
                  ],
                )


              ],
            ),
          ),
        ),
    );
  }
}
