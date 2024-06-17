import 'package:flutter/material.dart';

class CustomButtonOptions extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color? color;
  const CustomButtonOptions({
    Key? key,
    required this.text,
    required this.onTap,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0),
            )),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}
