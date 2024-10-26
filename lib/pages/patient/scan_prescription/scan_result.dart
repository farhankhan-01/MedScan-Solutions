import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:doctors_prescription/models/medicine.dart';
import 'package:doctors_prescription/models/patient.dart';
import 'package:doctors_prescription/pages/patient/components/app_bar.dart';
import 'package:doctors_prescription/pages/patient/scan_prescription/add_medicine.dart';
import 'package:doctors_prescription/routes.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:string_similarity/string_similarity.dart';

class PatientScanResult extends StatefulWidget {
  const PatientScanResult({Key key}) : super(key: key);

  @override
  _PatientScanResultState createState() => _PatientScanResultState();
}

class _PatientScanResultState extends State<PatientScanResult> {
  bool _isLoading = false;
  String _message = '';
  Color _messageColor = Colors.white;
  String _imagePath = '';
  String scannedText = "";
  bool textScanning = false;

  // static const platform =
  //     const MethodChannel('com.example.flutter_doctorsprescription/pipeline');

  predictMedicine(String imagePath) async {
    Dio dio = Dio();
    setState(() {
      _isLoading = true;
    });
    FormData formData = FormData.fromMap(
      {
        'image': await MultipartFile.fromFile(imagePath, filename: 'image.txt'),
      },
    );
    Response response;
    try {
      response = await dio.post(
        'https://handwriting-recognition-api.herokuapp.com/api/v1/predict-medicine',
        data: formData,
      );
      if (response.statusCode == 200) {
        var result = response.data;
        print(result.toString());
        print(result['result']);
        print(result['prediction']);
        setState(() {
          _isLoading = false;
          _message = 'SUCCESS!\n${result['prediction']}';
          _messageColor = Colors.blue;
        });
      } else {
        // TODO: ERROR HANDLING
        setState(() {
          _isLoading = false;
          _message = 'ERROR! Please Try Again.';
          _messageColor = Colors.red;
        });
      }
    } on DioError catch (err) {
      print(err.response);
      setState(() {
        _isLoading = false;
        _message = 'ERROR! Please Try Again.';
        _messageColor = Colors.red;
      });
    }
  }

  Future<String> getRecognisedText(File image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    final textDetector = TextRecognizer();
    RecognizedText recognisedText = await textDetector.processImage(inputImage);
    await textDetector.close();
    scannedText = "";
    for (TextBlock block in recognisedText.blocks) {
      for (TextLine line in block.lines) {
        scannedText = "$scannedText${line.text}\n";
      }
    }
    print(scannedText);
    textScanning = false;
    setState(() {});
    return scannedText;
  }

  recognisingPipeline(String imagePath) async {
    setState(() {
      _isLoading = true;
    });
    var pres = await FirebaseFirestore.instance
        .collection('Prescriptions')
        .doc('e1VnN0e8ax9SPl82fXct')
        .get();
    var presList = pres.data();
    String scannendText = await getRecognisedText(File(imagePath));
    print(scannendText);
    List<String> preds = scannendText.split('\n');
    List<Medicine> predictions = [];
    // preds.forEach((prediction) {
    //   presList.forEach((medicine) {
    //     if (medicine['name'].toLowerCase().contains(prediction.toLowerCase())) {
    //       Medicine matchedMedicine = Medicine.fromJson(medicine);
    //       predictions.add(matchedMedicine);
    //     }
    //   });
    // });

    List<String> prescList = [];
    presList['prescriptions'].forEach((medicine) {
      prescList.add(medicine);
    });
    print(preds);
    for (var prediction in preds) {
      var matches = prediction.bestMatch(prescList);
      if (matches.bestMatch.rating > 0.1) {
        String match = matches.bestMatch.target;
        predictions.add(Medicine(
          name: match,
          category: prediction,
          id: matches.bestMatch.rating.toString(),
          image: '',
          weight: '',
        ));
        print("MATCHED $match");
      }
    }
    if (predictions.isNotEmpty) {
      setState(() {
        _isLoading = false;
        _imagePath = imagePath;
        _message = 'SUCCESS!';
        _messageColor = Colors.blue;
      });
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.of(context).pushNamed(
          PATIENT_ADD_MEDICINE,
          arguments: AddMedicineArguments(
              medicines: predictions, predictedMedicines: preds),
        );
      });
    } else {
      setState(() {
        _isLoading = false;
        _imagePath = imagePath;
        _message = 'ERROR! No Matches Found.\nPlease try again';
        _messageColor = Colors.red;
      });
    }
  }

  // dpPipeline(String imagePath) async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   print(imagePath);
  //   try {
  //     var result =
  //         await platform.invokeMethod('pipeline', {"imagePath": imagePath});
  //     print("RESULT $result");
  //     final box = Hive.box(MEDICINES_BOX);
  //     var values = box.keys;
  //     List<String> preds = result[1].toString().split(' ');
  //     List<String> valuesString = List<String>.from(values);
  //     List<Medicine> predictions = [];
  //     preds.forEach((prediction) {
  //       var matches = prediction.bestMatch(valuesString);
  //       print(matches.bestMatch.toString());
  //       if (matches.bestMatch.rating > 0.6) {
  //         String match = matches.bestMatch.target;
  //         Medicine matchedMedicine = Medicine.fromJson(box.get(match));
  //         predictions.add(matchedMedicine);
  //       }
  //     });
  //     if (predictions.length > 0) {
  //       setState(() {
  //         _isLoading = false;
  //         _imagePath = result[0];
  //         _message = 'SUCCESS!';
  //         _messageColor = Colors.blue;
  //       });
  //       Future.delayed(Duration(seconds: 1), () {
  //         Navigator.of(context).pushNamed(
  //           PATIENT_ADD_MEDICINE,
  //           arguments: AddMedicineArguments(medicines: predictions),
  //         );
  //       });
  //     } else {
  //       setState(() {
  //         _isLoading = false;
  //         _imagePath = imagePath;
  //         _message = 'ERROR! No Matches Found.\nPlease try again';
  //         _messageColor = Colors.red;
  //       });
  //     }
  //   } catch (err) {
  //     setState(() {
  //       _isLoading = false;
  //       _imagePath = imagePath;
  //       _message = 'ERROR! No Matches Found.\nPlease try again';
  //       _messageColor = Colors.red;
  //     });
  //     print(err);
  //   }
  // }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      final PatientScanImageResult result =
          ModalRoute.of(context).settings.arguments;
      setState(() {
        _imagePath = result.imagePath;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PatientAppBar(title: 'Scan Result'),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 100.0,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Text(
                    'Confirm that the image is sharp and the prescription is visible.',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 18.0,
                    ),
                    softWrap: true,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Text(_imagePath),
            File(_imagePath).existsSync()
                ? Image.file(
                    File(_imagePath),
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  )
                : Container(),
            Flexible(
              fit: FlexFit.loose,
              child: Container(
                color: Colors.grey[200],
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _isLoading
                          ? const CircularProgressIndicator()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                TextButton.icon(
                                  onPressed: () {
                                    Navigator.of(context).pushReplacementNamed(
                                        PATIENT_SCAN_PRESCRIPTION);
                                  },
                                  // padding: const EdgeInsets.all(30.0),
                                  icon: Icon(
                                    Icons.arrow_back,
                                    size: 25.0,
                                    color: Colors.black.withOpacity(0.75),
                                  ),
                                  label: Text(
                                    'Retry',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black.withOpacity(0.75),
                                    ),
                                  ),
                                  // splashColor: Colors.grey.shade200,
                                ),
                                TextButton(
                                  onPressed: () async {
                                    // predictMedicine(_imagePath);
                                    // dpPipeline(_imagePath);
                                    await recognisingPipeline(_imagePath);
                                  },
                                  // padding: const EdgeInsets.all(30.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Continue',
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black.withOpacity(0.75),
                                        ),
                                      ),
                                      const SizedBox(width: 8.0),
                                      Icon(
                                        Icons.arrow_forward,
                                        size: 25.0,
                                        color: Colors.black.withOpacity(0.75),
                                      ),
                                    ],
                                  ),
                                  // splashColor: Colors.grey.shade200,
                                )
                              ],
                            ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      _message == ''
                          ? const SizedBox()
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25.0),
                              child: Text(
                                _message,
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w500,
                                  color: _messageColor,
                                ),
                                softWrap: true,
                                textAlign: TextAlign.center,
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
