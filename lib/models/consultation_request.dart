import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facultysupportdesk/mixins/display_mixin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

final _firebase = FirebaseAuth.instance;
final CollectionReference consultationRequests = FirebaseFirestore.instance.collection('consultationRequests');

class ConsultationRequest with DisplayMixin{
  ConsultationRequest({
    this.id,
    this.studentID,
    this.facultyID,
    this.requestTitle,
    this.requestDescription,
    this.proposedTimeStart,
    this.proposedTimeEnd,
    this.status,
    this.statusUpdateDate,
    this.context,
  });

  final BuildContext? context;
  final String? id;
  final String? studentID;
  final String? facultyID;
  final String? requestTitle;
  final String? requestDescription;
  final Timestamp? proposedTimeStart;
  final Timestamp? proposedTimeEnd;
  final String? status;
  final Timestamp? statusUpdateDate;

  factory ConsultationRequest.fromMap(Map<String, dynamic> data, id){
    return ConsultationRequest(
        id: id,
        studentID: data['studentID'],
        facultyID: data['facultyID'],
        requestTitle: data['requestTitle'],
        requestDescription: data['requestDescription'],
        proposedTimeStart: data['proposedTimeStart'],
        proposedTimeEnd: data['proposedTimeEnd'],
        status: data['status'],
        statusUpdateDate: data['statusUpdateData']
    );
  }

  Future<void> manageConsultationRequest() async{
    DateTime now = DateTime.now();
    Timestamp timestamp = Timestamp.fromDate(now);
    try{
      await consultationRequests.doc(id).update({
        'status': status,
        'statusUpdateDate': timestamp
      });
    } on FirebaseException catch(e){
      showError(
          errorMessage: e.message!,
          errorTitle: 'Database Error!'
      );
      return;
    }
  }

  Future <List<ConsultationRequest>> getConsultationRequests() async {
    QuerySnapshot querySnapshot = await consultationRequests.get();
    final allConsultationRequests = querySnapshot.docs.map((doc) => ConsultationRequest.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    return allConsultationRequests;
  }

  Future <List<ConsultationRequest>> getConsultationRequestsByStatus(String status) async {
    QuerySnapshot querySnapshot =  await consultationRequests.where('status', isEqualTo: 'Pending').get();
    final allConsultationRequests = querySnapshot.docs.map((doc) => ConsultationRequest.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    return allConsultationRequests;
  }

}