import 'package:flutter/material.dart';

class EditTaskCheckbox {
  final String? id;
  final String? name;
  bool? state;
  final TextEditingController? controller;

  EditTaskCheckbox({this.id, this.name, this.state, this.controller});
}
