// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:payments_management/features/historical/screens/historical_filter_screen.dart';

class DrawerItem {
  final String title;
  final Icon icon;
  final String route;
  final List<HistoricalFilter> args;
  final bool closeSession;

  DrawerItem(
    this.title,
    this.icon,
    this.route,
    this.args,
    this.closeSession,
  );
}
