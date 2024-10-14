import 'package:flutter/material.dart';
import 'package:payments_management/constants/global_variables.dart';

class SearchTextField extends StatelessWidget {
  final TextEditingController searchController;
  final Function(String value) onChange;
  final String placeholder;
  const SearchTextField(
      {Key? key,
      required this.searchController,
      required this.onChange,
      required this.placeholder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: searchController,
      onChanged: (value) => onChange(value),
      decoration: InputDecoration(
        suffixIcon: const Icon(
          Icons.search,
          size: 30,
        ),
        hintText: placeholder,
        border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black38)),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black38)),
        filled: true,
        fillColor: GlobalVariables.greyBackgroundColor,
        isDense: true,
        errorStyle: const TextStyle(color: Colors.red, fontSize: 14),
      ),
      maxLines: 1,
    );
  }
}
