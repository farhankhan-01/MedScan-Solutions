import 'package:age/age.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctors_prescription/components/patient/add_patient/detail_profile_card.dart';
import 'package:doctors_prescription/models/doctor.dart';
import 'package:doctors_prescription/models/models.dart';
import 'package:doctors_prescription/pages/doctor/components/app_bar.dart';
import 'package:doctors_prescription/pages/doctor/components/drawer.dart';
import 'package:doctors_prescription/providers/auth_bloc.dart';
import 'package:doctors_prescription/providers/doctor_bloc.dart';
import 'package:doctors_prescription/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScanResultPage extends StatefulWidget {
  const ScanResultPage({Key key}) : super(key: key);

  @override
  _ScanResultPageState createState() => _ScanResultPageState();
}

class _ScanResultPageState extends State<ScanResultPage> {
  bool _isLoading = false;
  String _message = '';
  Color _messageColor = Colors.black;

  // ADD PATIENT DETAILS TO PATIENTS COLLECTION OF DOCTOR'S DOCUMENT
  addPatient(UserData patient, UserData doctor) async {
    setState(() {
      _isLoading = true;
    });
    bool result = await Provider.of<DoctorBloc>(context, listen: false)
        .addNewPatient(patient, doctor);
    print(result);
    if (result == true) {
      setState(() {
        _isLoading = false;
        _message = 'Patient Added Successfully';
        _messageColor = Colors.blue;
      });
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.of(context).pushReplacementNamed(DOCTOR_DASHBOARD);
      });
    } else {
      setState(() {
        _isLoading = false;
        _message = 'An Error Occurred. Please Try Again';
        _messageColor = Colors.red;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final QRScanResult args = ModalRoute.of(context).settings.arguments;
    DoctorBloc doctorBloc = Provider.of<DoctorBloc>(context);
    AuthBloc authBloc = Provider.of<AuthBloc>(context);
    CollectionReference patientCollectionRef =
        FirebaseFirestore.instance.collection('Patient');
    return Scaffold(
      appBar: DoctorAppBar(
        title: 'Scan Result',
      ),
      drawer: const DoctorAppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: patientCollectionRef.doc(args.qrResult).get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError ||
                      (snapshot.connectionState == ConnectionState.done &&
                          snapshot.data.data == null)) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/icons/database.png',
                              width: 200.0,
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            const Text(
                              'Something went wrong.',
                              style: TextStyle(
                                fontSize: 21.0,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            const Text(
                              'Please make sure that the patient has registered and you are connected to the internet.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                                color: Colors.black45,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  if (snapshot.hasData && snapshot.data.exists) {
                    Map<String, dynamic> data = {};
                    data = snapshot.data.data();

                    UserData patient = UserData.fromJson(data);
                    int ageInYears = Age.dateDifference(
                            fromDate: patient.dateOfBirth,
                            toDate: DateTime.now())
                        .years;
                    return Column(
                      children: [
                        PatientDetailProfileCard(
                          email: patient.email,
                          name: patient.username,
                          gender: patient.gender,
                          height: '${patient.height.toString()} cm',
                          weight: '${patient.weight.toString()} Kg',
                          age: '$ageInYears Years',
                        ),
                        const SizedBox(height: 25.0),
                        _isLoading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : ElevatedButton.icon(
                                // color: Colors.blueAccent,
                                // textColor: Colors.white,
                                onPressed: () {
                                  addPatient(patient, authBloc.userData);
                                },
                                icon: const Icon(Icons.add),
                                label: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 15.0),
                                  child: Text(
                                    'Add as Patient',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        _message == ''
                            ? const SizedBox()
                            : Text(
                                _message,
                                style: TextStyle(
                                  color: _messageColor,
                                  fontSize: 14.0,
                                ),
                              )
                      ],
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
