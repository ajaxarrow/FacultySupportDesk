import 'package:facultysupportdesk/models/consultation_request.dart';
import 'package:facultysupportdesk/widgets/consultations/consultation_item.dart';
import 'package:flutter/material.dart';

class ConsultationList extends StatelessWidget {
  const ConsultationList({
    super.key,
    required this.onUpdateConsultationList,
    required this.consultations
  });

  final void Function() onUpdateConsultationList;
  final List<ConsultationRequest> consultations;


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: consultations.length,
      itemBuilder: (ctx, index) =>
        ConsultationItem(
          consultation: consultations[index],
          onUpdateConsultationList: onUpdateConsultationList
        )
    );
  }
}
