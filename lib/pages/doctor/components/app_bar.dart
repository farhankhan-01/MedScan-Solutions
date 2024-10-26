import 'package:flutter/material.dart';

class DoctorAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;

  DoctorAppBar({Key key, @required this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blueAccent,
      title: Text(title),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
