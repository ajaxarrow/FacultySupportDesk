import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facultysupportdesk/models/academic_year.dart';
import 'package:facultysupportdesk/models/mixins/display_mixin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
    this.semester
  });

  final BuildContext? context;
  final String? id;
  final String? title;
  final Timestamp? timeStart;
  final Timestamp? timeEnd;
  final String? academicYearID;
  final String? facultyID;
  final String? semester;

  factory Schedule.fromMap(Map<String, dynamic> data, String id){
    return Schedule(
      id: id,
      title: data['title'],
      timeStart: data['timeStart'],
      timeEnd: data['timeEnd'],
      academicYearID: data['academicYearID'],
      facultyID: data['facultyID'],
      semester: data['semester']
    );
  }

  Future<void> addSchedule() async {
    try{
      final academicYear = await AcademicYear().getDefault();
      await schedules.add({
        'title': title,
        'timeStart': timeStart,
        'timeEnd': timeEnd,
        'academicYearID': academicYear.id,
        'semester': semester,
        'facultyID': _firebase.currentUser?.uid!
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
        'semester': semester,
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

  Future <List<Schedule>> getScheduleByFacultyID() async {
    final academicYear = await AcademicYear().getDefault();
    QuerySnapshot querySnapshot =  await schedules
        .where('academicYearID', isEqualTo: academicYear.id)
        .where('facultyID', isEqualTo: _firebase.currentUser?.uid)
        .get();
    final result = querySnapshot.docs.map((doc) => Schedule.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    return result;
  }

  Future <List<Schedule>> getScheduleByFacultyIDSemesterandAY() async {
    QuerySnapshot querySnapshot =  await schedules
        .where('semester', isEqualTo: semester)
        .where('academicYearID', isEqualTo: academicYearID)
        .where('facultyID', isEqualTo: _firebase.currentUser?.uid)
        .get();
    final result = querySnapshot.docs.map((doc) => Schedule.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    return result;
  }


}