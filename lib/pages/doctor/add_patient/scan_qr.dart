import 'package:doctors_prescription/models/doctor.dart';
import 'package:doctors_prescription/pages/doctor/components/app_bar.dart';
import 'package:doctors_prescription/pages/doctor/components/drawer.dart';
import 'package:doctors_prescription/routes.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanQRPage extends StatefulWidget {
  const ScanQRPage({Key key}) : super(key: key);

  @override
  _ScanQRPageState createState() => _ScanQRPageState();
}

class _ScanQRPageState extends State<ScanQRPage> {
  String qrText = "";
  GlobalKey qrKey = GlobalKey();
  QRViewController controller;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void closeQr() {
    controller?.dispose();
  }

  void _onQRViewCreate(QRViewController controller) async {
    this.controller = controller;
    await controller.scannedDataStream.first.then((scanData) {
      print("PATIENT ID: ${scanData.code}");
      scanSuccess(scanData.code);
    });
  }

  void scanSuccess(scanData) {
    dispose();
    controller.dispose();
    Navigator.of(context).pushReplacementNamed(
      DOCTOR_SCAN_RESULT,
      arguments: QRScanResult(qrResult: scanData),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DoctorAppBar(
        title: 'Add Patient',
      ),
      drawer: DoctorAppDrawer(),
      body: Stack(
        children: <Widget>[
          Center(
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: QRView(
                    key: qrKey,
                    overlay: QrScannerOverlayShape(
                        borderRadius: 10,
                        borderColor: Colors.blueAccent,
                        borderLength: 30,
                        borderWidth: 10,
                        cutOutSize: 300),
                    onQRViewCreated: _onQRViewCreate,
                  ),
                ),
              ],
            ),
          ),
          const Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 25.0),
              child: Hero(
                tag: 'addPatient',
                child: Text(
                  'Place the QR code in the box.',
                  style: TextStyle(color: Colors.white, fontSize: 21.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
