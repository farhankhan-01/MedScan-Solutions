import 'dart:convert';

import 'package:doctors_prescription/pages/patient/components/app_bar.dart';
import 'package:doctors_prescription/pages/patient/components/drawer.dart';
import 'package:doctors_prescription/providers/patient_bloc.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScanResult extends StatefulWidget {
  const ScanResult({Key key}) : super(key: key);

  @override
  _ScanResultState createState() => _ScanResultState();
}

class _ScanResultState extends State<ScanResult> {
  static const _base64SafeEncoder = Base64Codec.urlSafe();

  @override
  void initState() {
    super.initState();
    //final imagePath = utf8.decode(_base64SafeEncoder.decode(widget.imagePath));
    //print(imagePath);
  }

  @override
  Widget build(BuildContext context) {
    final PatientBloc patientBloc = Provider.of<PatientBloc>(context);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: PatientAppBar(
          title: 'Scan Result',
        ),
        drawer: PatientDrawer(),
        body: patientBloc.isUploading
            ? Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 300.0,
                  child: const FlareActor(
                    'assets/animations/uploading.flr',
                    alignment: Alignment.topCenter,
                    fit: BoxFit.contain,
                    animation: 'uploading',
                  ),
                ),
              )
            : patientBloc.isProcessing
                ? Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 300.0,
                      child: const FlareActor(
                        'assets/animations/processing.flr',
                        alignment: Alignment.topCenter,
                        fit: BoxFit.contain,
                        animation: 'process',
                      ),
                    ),
                  )
                : patientBloc.medicines.isNotEmpty
                    ? ListView.builder(
                        itemCount: patientBloc.medicines.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 0.0, vertical: 5.0),
                              color: Colors.blue[200],
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: <Widget>[
                                    Center(
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            patientBloc.medicines[index].image),
                                        backgroundColor: Colors.transparent,
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 15.0,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              patientBloc.medicines[index].name,
                                              style: const TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              patientBloc
                                                  .medicines[index].category,
                                              style: const TextStyle(
                                                fontSize: 16.0,
                                              ),
                                            ),
                                            Text(
                                              patientBloc
                                                  .medicines[index].weight,
                                              style: const TextStyle(
                                                fontSize: 16.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset('assets/icons/close.png'),
                            const SizedBox(
                              height: 12.0,
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              child: Text(
                                'There was an error while processing the image.',
                                style: TextStyle(
                                    fontSize: 21.0,
                                    fontWeight: FontWeight.w600),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ));
  }
}
