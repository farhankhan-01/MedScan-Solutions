import 'package:camera/camera.dart';
import 'package:doctors_prescription/constants.dart';
import 'package:doctors_prescription/firebase_options.dart';
import 'package:doctors_prescription/pages/auth/login.dart';
import 'package:doctors_prescription/pages/auth/registration.dart';
import 'package:doctors_prescription/pages/doctor/add_patient/scan_qr.dart';
import 'package:doctors_prescription/pages/doctor/add_patient/scan_result.dart';
import 'package:doctors_prescription/pages/doctor/dashboard.dart';
import 'package:doctors_prescription/pages/patient/dashboard.dart';
import 'package:doctors_prescription/pages/patient/prescriptionScan.dart';
import 'package:doctors_prescription/pages/patient/scan_prescription/add_medicine.dart';
import 'package:doctors_prescription/pages/patient/scan_prescription/scan_prescription.dart';
import 'package:doctors_prescription/pages/patient/scan_prescription/scan_result.dart';
import 'package:doctors_prescription/pages/patient/showQR.dart';
import 'package:doctors_prescription/pages/splash.dart';
import 'package:doctors_prescription/providers/auth_bloc.dart';
import 'package:doctors_prescription/providers/doctor_bloc.dart';
import 'package:doctors_prescription/providers/patient_bloc.dart';
import 'package:doctors_prescription/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  await Hive.initFlutter();
  await Hive.openBox(MEDICINES_BOX);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return MultiProvider(
              providers: [
                ChangeNotifierProvider<AuthBloc>(
                  create: (_) => AuthBloc(),
                ),
                ChangeNotifierProvider<PatientBloc>(
                  create: (_) => PatientBloc(),
                ),
                ChangeNotifierProvider<DoctorBloc>(
                  create: (_) => DoctorBloc(),
                ),
              ],
              child: MaterialApp(
                title: 'Doctor\'s Prescription',
                initialRoute: SPLASH,
                theme: ThemeData(
                  fontFamily: GoogleFonts.lato().fontFamily,
                ),
                routes: {
                  SPLASH: (context) => SplashScreenPage(),
                  LOGIN: (context) => LoginPage(),
                  REGISTER: (context) => Registration(),

                  // DOCTOR ROUTES
                  DOCTOR_DASHBOARD: (context) => const DoctorDashboard(),
                  DOCTOR_SCAN_QR: (context) => ScanQRPage(),
                  DOCTOR_SCAN_RESULT: (context) => ScanResultPage(),

                  // PATIENT ROUTE
                  PATIENT_DASHBOARD: (context) => PatientDashboard(),
                  PATIENT_SCAN_PRESCRIPTION: (context) =>
                      PatientScanPrescription(),
                  PATIENT_SCAN_RESULT: (context) => PatientScanResult(),
                  PATIENT_ADD_MEDICINE: (context) => const PatientAddMedicine(),

                  PATIENT_PRESCRIPTION_SCAN: (context) => PrescriptionScan(),

                  PATIENT_SHOW_QR: (context) => QrCodePage(),
                },
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
