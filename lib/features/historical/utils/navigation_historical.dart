import 'package:flutter/material.dart';
import 'package:payments_management/features/historical/screens/historical_filter_screen.dart';
import 'package:payments_management/features/historical/screens/historical_screen.dart';

void fromFilterToMain(context, List<HistoricalFilter> finalFilter) {
  Navigator.pop(context);
  Navigator.popAndPushNamed(context, HistoricalScreen.routeName,
      arguments: finalFilter);
}

void cleanFiltersAndReturnToMain(context) {
  List<HistoricalFilter> finalFilter = [];
  Navigator.pop(context);
  Navigator.popAndPushNamed(context, HistoricalScreen.routeName,
      arguments: finalFilter);
}
