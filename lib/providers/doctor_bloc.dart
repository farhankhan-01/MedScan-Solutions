import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctors_prescription/models/models.dart';
import 'package:flutter/material.dart';

class DoctorBloc extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserData _currentDoctor;

  UserData get currentDoctor => _currentDoctor;

  set currentDoctor(UserData val) {
    _currentDoctor = val;
    notifyListeners();
  }

  Future<bool> addNewPatient(UserData patient, UserData doctor) async {
    try {
      print('**CURRENT DOCTOR** ${doctor.uid}');
      print("***CURRENT PATIENT*** ${patient.uid}");
      final newPatientRef = _firestore
          .collection('Doctor')
          .doc(doctor.uid)
          .collection('Patients')
          .doc(patient.uid);
      await newPatientRef.set({
        'username': patient.username,
        'email': patient.email,
        'uid': patient.uid,
        'DOB': patient.dobString,
        'userType': patient.userType,
        'gender': patient.gender,
      });
      return true;
    } catch (err) {
      print(err);
      return false;
    }
  }
}
