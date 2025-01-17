import 'package:doctors_prescription/providers/auth_bloc.dart';
import 'package:doctors_prescription/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PatientDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.blue,
        child: ListView(
          children: <Widget>[
            Container(
              color: Colors.blue,
              width: double.infinity,
              child: Column(
                children: [
                  const SizedBox(height: 50.0),
                  Image.asset(
                    'assets/icons/note2.png',
                    width: 120.0,
                  ),
                  const SizedBox(height: 10.0),
                  const Text(
                    'Doctor\'s Prescription',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20.0)
                ],
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).pushReplacementNamed(PATIENT_DASHBOARD);
              },
              title: const Text(
                "Home",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).pushNamed(PATIENT_SCAN_PRESCRIPTION);
              },
              title: const Text(
                "Scan Prescription",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).pushNamed(PATIENT_SHOW_QR);
              },
              title: const Text(
                "Show QR",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ListTile(
              onTap: () async {
                await Provider.of<AuthBloc>(context, listen: false)
                    .firebaseSignOut();
                Navigator.of(context).pushReplacementNamed(LOGIN);
              },
              title: const Text(
                "Logout",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
