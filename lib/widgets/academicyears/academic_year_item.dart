import 'package:facultysupportdesk/models/academic_year.dart';
import 'package:facultysupportdesk/widgets/academicyears/academic_year_dialog_form.dart';
import 'package:flutter/material.dart';

class AcademicYearItem extends StatelessWidget {
  const AcademicYearItem({
    super.key,
    required this.academicYear,
    required this.onUpdateList
  });

  final AcademicYear academicYear;
  final Function() onUpdateList;

  @override
  Widget build(BuildContext context) {

    void showAcademicYearFormDialog() {
      showDialog(
          context: context,
          builder: (ctx) =>
              SimpleDialog(
                children: [
                  AcademicYearDialogForm(
                    mode: Mode.update,
                    academicYear: academicYear,
                    onUpdateAcademicYear: onUpdateList,
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
                      '${academicYear.yearStart} - ${academicYear.yearEnd}',
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16
                      )
                  ),
                  const Spacer(),
                  academicYear.isDefault == true ? const Text('Default') : const SizedBox.shrink()
                ],
              ),
              const SizedBox(
                height: 4,
              ),
              Row(
                children: [
                  TextButton.icon(
                      onPressed: showAcademicYearFormDialog,
                      label: const Text('Edit'),
                      icon: const Icon(Icons.edit,
                          size: 16)
                  )
                ],
              )
            ],
          )
      ),
    );
  }
}
