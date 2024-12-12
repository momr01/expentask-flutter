import 'package:intl/intl.dart';

DateTime stringToDateTime(date) {
  final formatter = DateFormat('EEE MMM dd yyyy HH:mm:ss');
  final dateTime = formatter.parse(date.toString());
  return dateTime;
}

String datetimeToString(DateTime date) {
  String day = date.day.toString().padLeft(2, '0');
  String month = date.month.toString().padLeft(2, '0');
  String year = date.year.toString().padLeft(2, '0');

  return "$day/$month/$year";
}

String datetimeToStringWithDash(DateTime date) {
  String day = date.day.toString().padLeft(2, '0');
  String month = date.month.toString().padLeft(2, '0');
  String year = date.year.toString().padLeft(2, '0');

  return "$day-$month-$year";
}

String dateFormatWithDash(String dateText) {
  List<String> dateParts = dateText.split('/');

  String initMonth = dateParts[1];
  String initDay = dateParts[0];

  String finalMonth = "";
  String finalDay = "";

  if (initMonth.length < 2) {
    finalMonth = "0$initMonth";
  } else {
    finalMonth = initMonth;
  }

  if (initDay.length < 2) {
    finalDay = "0$initDay";
  } else {
    finalDay = initDay;
  }

  String completedDate = '${dateParts[2]}-$finalMonth-$finalDay';
  return completedDate;
}

DateTime dateFormatFromString(String date) {
  DateFormat format = DateFormat('EEE MMM dd y hh:mm:ss');
  DateTime finalDate = format.parse(date);

  return finalDate;
}

String formatDateWithTime(String date) {
  // String inputDate = "2024-11-28 16:06:43.000";
  DateTime parsedDate = DateTime.parse(date);

  // Crear un formateador con el formato deseado
  String formattedDate = DateFormat('dd-MM-yyyy').format(parsedDate);

  //print(formattedDate); // Salida: 28-11-2024
  return formattedDate;
}
