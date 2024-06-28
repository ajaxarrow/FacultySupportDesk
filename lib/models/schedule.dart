import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facultysupportdesk/models/academic_year.dart';
import 'package:facultysupportdesk/models/mixins/display_mixin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

final _firebase = FirebaseAuth.instance;
final CollectionReference schedules = FirebaseFirestore.instance.collection('schedules');

class Schedule with DisplayMixin{
  Schedule({
    this.context,
    this.id,
    this.title,
    this.timeEnd,
    this.timeStart,
    this.academicYearID,
    this.facultyID,
    this.days,
    this.abbreviatedDays,
    this.color
  });

  final BuildContext? context;
  final String? id;
  final String? title;
  final Timestamp? timeStart;
  final Timestamp? timeEnd;
  final String? academicYearID;
  final String? facultyID;
  final List<String>? days;
  final String? abbreviatedDays;
  final List<int>? color;


  factory Schedule.fromMap(Map<String, dynamic> data, String id){
    List<int> colorData = (data['color'] as List<dynamic>).cast<int>();

    return Schedule(
      id: id,
      title: data['title'],
      timeStart: data['timeStart'],
      timeEnd: data['timeEnd'],
      academicYearID: data['academicYearID'],
      facultyID: data['facultyID'],
      days: List<String>.from(data['days'] ?? []),
      color: colorData,
      abbreviatedDays: abbreviateDays(List<String>.from(data['days'] ?? []))
    );
  }

  Future<Appointment> convertToAppointment(Map<String, dynamic> data, id) async {
    String endDate;
    AcademicYear academicYear = await AcademicYear().getAcademicYearByID(data['academicYearID']);

    Timestamp startTimeStamp = data['timeStart'] as Timestamp;
    Timestamp endTimeStamp = data['timeEnd'] as Timestamp;

    DateTime dateTimeStart = startTimeStamp.toDate();
    DateTime dateTimeEnd = endTimeStamp.toDate();

    List<dynamic> colorData = data['color'] as List<dynamic>;

    List<int> colorIntegers = colorData.map((dynamic value) => value as int).toList();

    Color color = Color.fromRGBO(
      colorIntegers[0],
      colorIntegers[1],
      colorIntegers[2],
      1.0, // Opacity
    );

    switch (academicYear.semester) {
      case '1st Semester':
        endDate='${academicYear.yearStart!}1223';
        break;
      case '2nd Semester':
        endDate='${academicYear.yearEnd!}0531';
        break;
      case 'Midyear':
        endDate='${academicYear.yearStart!}0731';
        break;
      default:
        throw Exception('Unknown semester type');
    }


    return Appointment(
      color: color,
      subject: data['title'],
      startTime: dateTimeStart,
      endTime: dateTimeEnd,
      recurrenceRule: 'FREQ=WEEKLY;INTERVAL=1;BYDAY=${convertDaysToWeekdays(List<String>.from(data['days'] ?? []))};UNTIL=$endDate'
    );
  }


  static String abbreviateDays(List<String> days) {
    const dayAbbreviations = {
      'Monday': 'M',
      'Tuesday': 'T',
      'Wednesday': 'W',
      'Thursday': 'Th',
      'Friday': 'F',
      'Saturday': 'Sa',
      'Sunday': 'Su',
    };

    return days.map((day) => dayAbbreviations[day] ?? '').join();
  }

  String convertDaysToWeekdays(List<String> days) {
    List<String> weekdays = days.map((day) {
      switch (day) {
        case 'Monday':
          return 'MO';
        case 'Tuesday':
          return 'TU';
        case 'Wednesday':
          return 'WE';
        case 'Thursday':
          return 'TH';
        case 'Friday':
          return 'FR';
        case 'Saturday':
          return 'SA';
        case 'Sunday':
          return 'SU';
        default:
          throw Exception('Invalid day');
      }
    }).toList();

    return weekdays.join(', ');
  }


  Future<void> addSchedule() async {
    try{
      final academicYear = await AcademicYear().getDefault();
      await schedules.add({
        'title': title,
        'timeStart': timeStart,
        'timeEnd': timeEnd,
        'academicYearID': academicYear.id,
        'facultyID': _firebase.currentUser?.uid!,
        'days': days,
        'color': getRandomColor()
      });
    } on FirebaseException catch (e){
      showError(
          errorMessage: e.message!,
          errorTitle: 'Database Error!'
      );
      return;
    }
  }

  Future<void> updateSchedule() async {
    try{
      await schedules.doc(id).update({
        'title': title,
        'timeStart': timeStart,
        'timeEnd': timeEnd,
        'days': days
      });
    } on FirebaseException catch (e){
      showError(
          errorMessage: e.message!,
          errorTitle: 'Database Error!'
      );
      return;
    }
  }

  Future<void> deleteSchedule() async {
    try{
      await schedules.doc(id).delete();
    } on FirebaseException catch (e){
      showError(
          errorMessage: e.message!,
          errorTitle: 'Database Error!'
      );
      return;
    }
  }

  Future <List<Appointment>> getAppointments() async {
    final academicYear = await AcademicYear().getDefault();
    QuerySnapshot querySnapshot =  await schedules
        .where('academicYearID', isEqualTo: academicYear.id)
        .get();
    List<Future<Appointment>> futureAppointments = querySnapshot.docs.map((doc) async {
      return await convertToAppointment(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
    return await Future.wait(futureAppointments);
  }

  Future <List<Schedule>> getScheduleByFacultyID() async {
    final academicYear = await AcademicYear().getDefault();
    QuerySnapshot querySnapshot =  await schedules
        .where('academicYearID', isEqualTo: academicYear.id)
        .where('facultyID', isEqualTo: _firebase.currentUser?.uid)
        .get();
    final result = querySnapshot.docs.map((doc) => Schedule.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    return result;
  }

  Future <List<Schedule>> getScheduleByFacultyIDByAY() async {
    QuerySnapshot querySnapshot =  await schedules
        .where('academicYearID', isEqualTo: academicYearID)
        .where('facultyID', isEqualTo: _firebase.currentUser?.uid)
        .get();
    final result = querySnapshot.docs.map((doc) => Schedule.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    return result;
  }

  List<int> getRandomColor(){
    List<int> colorInts = [];
    Random random = Random();
    for (int j = 0; j < 3; j++) {
      colorInts.add(random.nextInt(256));
    }
    return colorInts;
  }


}