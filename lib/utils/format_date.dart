import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facultysupportdesk/models/academic_year.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatTimestamp(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate();
  String formattedDate = DateFormat.yMMMMd().format(dateTime);
  String formattedTime = DateFormat.jm().format(dateTime);
  return '$formattedDate $formattedTime';
}

String formatTimestamptoTime(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate();
  String formattedTime = DateFormat.jm().format(dateTime);
  return formattedTime;
}

DateTime combineDateTimeAndTimeOfDay(DateTime date, TimeOfDay time) {
  return DateTime(
    date.year,
    date.month,
    date.day,
    time.hour,
    time.minute,
  );
}

// Function to convert combined DateTime to Firebase Timestamp
Timestamp convertToFirebaseTimestamp(DateTime date, TimeOfDay time) {
  var datetime = combineDateTimeAndTimeOfDay(date, time);
  return Timestamp.fromDate(datetime);
}

DateTime convertTimestampToDateTime(Timestamp timestamp) {
  return timestamp.toDate();
}

TimeOfDay convertTimestampToTimeOfDay(Timestamp timestamp) {
  // Convert timestamp to DateTime
  DateTime dateTime = timestamp.toDate();

  // Extract time components
  int hour = dateTime.hour;
  int minute = dateTime.minute;

  // Create TimeOfDay object
  return TimeOfDay(hour: hour, minute: minute);
}

Future<Timestamp> convertTimeOfDayToTimeStampV2(TimeOfDay time ) async {
  AcademicYear academicYear = await AcademicYear().getDefault();
  Timestamp date;
  switch (academicYear.semester) {
    case '1st Semester':
      date = Timestamp.fromDate(DateTime(
          int.parse(academicYear.yearStart!), 8, 1, time.hour, time.minute
      ));

      break;
    case '2nd Semester':
      date = Timestamp.fromDate(DateTime(
          int.parse(academicYear.yearEnd!), 1, 1, time.hour, time.minute
      ));
      break;
    case 'Midyear':
      date = Timestamp.fromDate(DateTime(
          int.parse(academicYear.yearStart!), 6, 1, time.hour, time.minute
      ));
      break;
    default:
      throw Exception('Unknown semester type');
  }
  return date;
}

Timestamp convertTimeOfDayToTimeStamp(TimeOfDay time ){
  return Timestamp.fromDate(DateTime(
      1970, 1, 1, time.hour, time.minute
  ));
}