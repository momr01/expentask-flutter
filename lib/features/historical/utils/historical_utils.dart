import 'package:flutter/material.dart';
import 'package:payments_management/constants/date_format.dart';
import 'package:payments_management/features/historical/screens/historical_details_screen.dart';
import 'package:payments_management/features/historical/screens/historical_filter_screen.dart';
import 'package:payments_management/models/payment/payment.dart';

void navigateToHistoricalDetailsScreen(BuildContext context, Payment payment) {
  Navigator.pushNamed(context, HistoricalDetailsScreen.routeName,
      arguments: payment);
}

void navigateToHistoricalFilterScreen(BuildContext context) {
  Navigator.pushNamed(context, HistoricalFilterScreen.routeName);
}

String getTaskState(bool isActive, bool isCompleted) {
  String state = "";
  if (isActive) {
    if (isCompleted) {
      state = "ACTIVO - COMPLETO";
    } else {
      state = "ACTIVO - PENDIENTE";
    }
  } else {
    if (isCompleted) {
      state = "INACTIVO - COMPLETO";
    } else {
      state = "INACTIVO - PENDIENTE";
    }
  }

  return state;
}

Color getTaskStateColor(bool isActive, bool isCompleted) {
  Color state = Colors.black;
  if (isActive) {
    if (isCompleted) {
      state = Colors.green;
    } else {
      state = Colors.blue;
    }
  } else {
    if (isCompleted) {
      state = Colors.orange;
    } else {
      state = Colors.red;
    }
  }

  return state;
}

List<Payment> filterByState(
    List<Payment> allItems, List<HistoricalFilter> finalFilter) {
  List<Payment> list = [];

  for (var element in finalFilter) {
    if (element.id == 1) {
      for (var option in element.options) {
        if (option.name.toLowerCase() == 'completados') {
          list += allItems
              .where((item) => item.isActive && item.isCompleted)
              .toList();
        } else if (option.name.toLowerCase() == 'anulados') {
          list += allItems.where((item) => !item.isActive).toList();
        } else {
          list += allItems
              .where((item) => item.isActive && !item.isCompleted)
              .toList();
        }
      }
    }
  }

  return list;
}

List<Payment> filterByName(
    List<Payment> allItems, List<HistoricalFilter> finalFilter) {
  List<Payment> list = [];

  for (var element in finalFilter) {
    if (element.id == 2) {
      for (var option in element.options) {
        list += allItems.where((item) => item.name.id == option.id).toList();
      }
    }
  }

  return list;
}

List<Payment> filterByCategory(
    List<Payment> allItems, List<HistoricalFilter> finalFilter) {
  List<Payment> list = [];

  for (var element in finalFilter) {
    if (element.id == 3) {
      for (var option in element.options) {
        list += allItems
            .where((item) => item.name.category.id == option.id)
            .toList();
      }
    }
  }
  return list;
}

List<Payment> filterByDate(
    List<Payment> allItems, List<HistoricalFilter> finalFilter) {
  List<Payment> list = [];

  for (var element in finalFilter) {
    if (element.id == 4) {
      String from = element.options
          .where(
            (val) => val.name.toLowerCase() == "desde",
          )
          .first
          .id;
      String to = element.options
          .where(
            (val) => val.name.toLowerCase() == "hasta",
          )
          .first
          .id;

      list += allItems
          .where((item) =>
              stringToDateTime(item.dataEntry!)
                      .compareTo(DateTime.parse(dateFormatWithDash(from))) >
                  0 &&
              stringToDateTime(item.dataEntry!)
                      .compareTo(DateTime.parse(dateFormatWithDash(to))) <
                  0)
          .toList();
    }
  }

  return list;
}
