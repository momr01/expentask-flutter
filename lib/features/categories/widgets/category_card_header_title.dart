import 'package:flutter/material.dart';
import 'package:payments_management/constants/utils.dart';

class CategoryCardHeaderTitle extends StatelessWidget {
  final String text;
  const CategoryCardHeaderTitle({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      capitalizeFirstLetter(text),
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
    );
  }
}
