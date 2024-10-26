import 'package:doctors_prescription/components/detail_row.dart';
import 'package:flutter/material.dart';

class PatientItemCard extends StatelessWidget {
  final String email;
  final String name;
  final String gender;
  final String age;

  const PatientItemCard({Key key, this.email, this.name, this.gender, this.age})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Column(
                children: [
                  Image.asset(
                    'assets/icons/patient.png',
                    width: 80.0,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: DetailRow(
                          title: 'Name',
                          data: name,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: DetailRow(
                          title: 'Gender',
                          data: gender,
                        ),
                      ),
                      Expanded(
                        child: DetailRow(
                          title: 'Age',
                          data: age,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
