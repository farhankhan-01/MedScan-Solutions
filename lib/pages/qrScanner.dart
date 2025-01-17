import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/material.dart';

class QrScannerPage extends StatefulWidget {
  const QrScannerPage({Key key}) : super(key: key);

  @override
  _QrScannerState createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScannerPage> {
  String qrText = "";
  GlobalKey qrKey = GlobalKey();
  QRViewController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Scan QR",
        ),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: QRView(
                  key: qrKey,
                  overlay: QrScannerOverlayShape(
                      borderRadius: 10,
                      borderColor: Colors.red,
                      borderLength: 40,
                      borderWidth: 10,
                      cutOutSize: 300),
                  onQRViewCreated: _onQRViewCreate),
            ),
            // *****qrText is the result of scan******
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreate(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrText = scanData.code;
      });
    });
  }
}
