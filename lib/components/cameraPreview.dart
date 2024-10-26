import 'dart:io';

import 'package:flutter/material.dart';

class CameraPreviewWidget extends StatelessWidget {
  const CameraPreviewWidget({Key key, this.imagePath, this.retry, this.upload})
      : super(key: key);

  final String imagePath;
  final Function retry;
  final Function upload;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: FileImage(
                  File(imagePath),
                ),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        Container(
          height: 80.0,
          color: Colors.black,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              TextButton.icon(
                onPressed: retry,
                icon: const Icon(
                  Icons.arrow_back,
                  size: 25.0,
                  color: Colors.white,
                ),
                label: const Text(
                  'Retry',
                  style: TextStyle(fontSize: 18.0, color: Colors.white),
                ),
              ),
              TextButton.icon(
                onPressed: upload,
                icon: const Icon(
                  Icons.cloud_upload,
                  size: 25.0,
                  color: Colors.white,
                ),
                label: const Text(
                  'Upload',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
