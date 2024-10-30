import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void showSnackBar(
  BuildContext context,
  String text,
) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  // SnackbarGlobal.show(text);
}

String capitalizeFirstLetter(String text) {
  List<String> listOfWords = text.split(" ");
  String capitalized = "";

  for (var word in listOfWords) {
    if (word.isNotEmpty) {
      capitalized +=
          '${word[0].toUpperCase()}${word.substring(1).toLowerCase()} ';
    }
  }
  return capitalized.trim();
}

String formatMoney(double money) {
  NumberFormat formatter =
      NumberFormat.decimalPatternDigits(locale: 'es_ar', decimalDigits: 2);

  return formatter.format(money);
}

String defineTextTask(int code) {
  switch (code) {
    case 1:
      return "Pagar";
    case 2:
      return "Factura";
    case 3:
      return "Comp. Pago";
    case 4:
      return "Email";
    default:
      return "";
  }
}

Color defineColorTask(int code) {
  switch (code) {
    case 1:
      return Colors.pink.shade100;
    case 2:
      return Colors.lightBlue.shade100;
    case 3:
      return Colors.purple.shade100;
    case 4:
      return Colors.yellow.shade100;
    default:
      return Colors.white;
  }
}
