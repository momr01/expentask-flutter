// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:payments_management/constants/global_variables.dart';

class CustomPasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String text;
  const CustomPasswordField({
    Key? key,
    required this.controller,
    required this.text,
  }) : super(key: key);

  @override
  State<CustomPasswordField> createState() => _CustomPasswordFieldState();
}

class _CustomPasswordFieldState extends State<CustomPasswordField> {
  bool _isObscured = false;

  @override
  void initState() {
    super.initState();
    _isObscured = true;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: _isObscured,
      textAlign: TextAlign.start,
      controller: widget.controller,
      decoration: InputDecoration(
        suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                _isObscured = !_isObscured;
              });
            },
            icon: _isObscured
                ? const Icon(
                    Icons.visibility,
                    size: 30,
                  )
                : const Icon(
                    Icons.visibility_off,
                    size: 30,
                  )),
        hintText: widget.text,
        border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black38)),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black38)),
        filled: true,
        fillColor: GlobalVariables.greyBackgroundColor,
        isDense: true,
        errorStyle: const TextStyle(color: Colors.yellow, fontSize: 14),
      ),
      validator: (val) {
        if (val == null || val.isEmpty) {
          return widget.text;
        }
        return null;
      },
      maxLines: 1,
    );
  }
}
