import 'package:doctors_prescription/providers/auth_bloc.dart';
import 'package:doctors_prescription/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DoctorAppDrawer extends StatelessWidget {
  const DoctorAppDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.blueAccent,
        child: Column(
          children: [
            Container(
              color: Colors.blueAccent,
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
                Navigator.of(context).pushReplacementNamed(DOCTOR_DASHBOARD);
              },
              title: const Text(
                "Dashboard",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).pushNamed(DOCTOR_SCAN_QR);
              },
              title: const Text(
                "Add Patient",
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
            ),
          ],
        ),
      ),
    );
  }
}
