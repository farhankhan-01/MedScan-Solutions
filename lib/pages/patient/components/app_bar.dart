import 'package:flutter/material.dart';

class PatientAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;

  PatientAppBar({Key key, @required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
      ),
      backgroundColor: Colors.blue,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
