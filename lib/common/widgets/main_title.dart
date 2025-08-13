// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class MainTitle extends StatelessWidget {
  final String title;
  final bool? bold;
  const MainTitle({
    Key? key,
    required this.title,
    this.bold = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(
      title,
      style: TextStyle(
          fontSize: 25.0,
          fontWeight: bold! ? FontWeight.bold : FontWeight.normal),
      textAlign: TextAlign.center,
    ));
  }
}
