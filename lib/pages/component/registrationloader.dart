import 'package:flutter/material.dart';

Widget registrationloader() {
  return const Center(
    child: CircularProgressIndicator(
      strokeWidth: 2.0,
      valueColor: AlwaysStoppedAnimation<Color>(Colors.blueGrey),
    ),
  );
}