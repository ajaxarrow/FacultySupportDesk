import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'mixins/display_mixin.dart';

final _firebase = FirebaseAuth.instance;
final CollectionReference users = FirebaseFirestore.instance.collection('users');


class AppUser with DisplayMixin{
  AppUser({
    this.name,
    this.email,
    this.password,
    this.context,
    this.uid,
    this.role
  });

  final String? uid;
  final String? name;
  final String? email;
  final String? password;
  final String? role;
  final BuildContext? context;

  factory AppUser.fromMap(Map<String, dynamic> data, id) {
    return AppUser(
      uid: id,
      name: data['name'],
      email: data['email'],
      password: data['password'],
    );
  }


  Future<void> register() async {
    try{
      UserCredential userCredential = await _firebase.createUserWithEmailAndPassword(
          email: email!,
          password: password!
      );

      await users.add({
        'id': userCredential.user!.uid,
        'name': name,
        'email': email,
        'role': role
      });

    } on FirebaseAuthException catch(e){
      showError(
          errorMessage: e.message!,
          errorTitle: 'Authentication Error!'
      );
      return;

    }
  }

  Future<void> login() async {
    try{

      final user = await getUserByEmail(email!);

      if (user.role == 'faculty'){
        await _firebase.signInWithEmailAndPassword(
            email: email!,
            password: password!
        );
      } else if (user.role == 'registrar'){
        await _firebase.signInWithEmailAndPassword(
            email: email!,
            password: password!
        );
      } else {
        showError(
          errorMessage: 'This account is prohibited for this module',
          errorTitle: 'Authentication Error'
        );
      }





    } on FirebaseAuthException catch(e){
      showError(
          errorMessage: e.message!,
          errorTitle: 'Authentication Error!'
      );
      return;
    }
  }

  Future<AppUser> getUserById(String id) async {
    QuerySnapshot querySnapshot =  await users
        .where('id', isEqualTo: id)
        .get();

    final result = querySnapshot.docs.map((doc) =>
        AppUser.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    return result[0];
  }


  Future<AppUser> getUserByEmail(String email) async {
    QuerySnapshot querySnapshot =  await users
        .where('email', isEqualTo: email)
        .get();

    final result = querySnapshot.docs.map((doc) =>
        AppUser.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    return result[0];
  }


}