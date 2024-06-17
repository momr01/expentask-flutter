import 'package:flutter/material.dart';

Color cardColor(int days) {
  if (days < 0) {
    return Colors.green.shade600;
  } else if (days == 0) {
    return Colors.amber;
  } else {
    return Colors.red.shade900;
  }
}

TextSpan cardText(int days) {
  if (days < 0) {
    return TextSpan(children: [
      const TextSpan(
          text: "está a ", style: TextStyle(fontWeight: FontWeight.normal)),
      TextSpan(
          text: "${days * -1} días",
          style: TextStyle(color: Colors.green.shade600)),
      const TextSpan(
          text: " de vencer.", style: TextStyle(fontWeight: FontWeight.normal))
    ]);
  } else if (days == 0) {
    return const TextSpan(children: [
      TextSpan(text: "vence", style: TextStyle(fontWeight: FontWeight.normal)),
      TextSpan(text: " HOY.", style: TextStyle(color: Colors.amber))
    ]);
  } else {
    return TextSpan(children: [
      const TextSpan(
          text: "lleva ", style: TextStyle(fontWeight: FontWeight.normal)),
      TextSpan(
          text: "$days ${days == 1 ? 'día' : 'días'}",
          style: TextStyle(color: Colors.red.shade900)),
      const TextSpan(
          text: " vencida.", style: TextStyle(fontWeight: FontWeight.normal))
    ]);
  }
}
