import 'package:doctors_prescription/pages/patient/components/app_bar.dart';
import 'package:doctors_prescription/pages/patient/components/drawer.dart';
import 'package:doctors_prescription/providers/patient_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodePage extends StatefulWidget {
  const QrCodePage({Key key}) : super(key: key);

  @override
  _QrCodeState createState() => _QrCodeState();
}

class _QrCodeState extends State<QrCodePage> {
  @override
  Widget build(BuildContext context) {
    final PatientBloc patientBloc = Provider.of<PatientBloc>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PatientAppBar(
        title: 'Show QR',
      ),
      drawer: PatientDrawer(),
      body: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 100.0),
            QrImage(
              data: FirebaseAuth.instance.currentUser.uid,
              version: QrVersions.auto,
              size: 320.0,
              backgroundColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
