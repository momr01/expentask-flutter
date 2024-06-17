import 'package:flutter/material.dart';
import 'package:payments_management/constants/global_variables.dart';

class SearchTextField extends StatelessWidget {
  final TextEditingController searchController;
  final Function(String value) onChange;
  const SearchTextField({
    Key? key,
    required this.searchController,
    required this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: searchController,
      onChanged: (value) => onChange(value),
      decoration: const InputDecoration(
        suffixIcon: Icon(
          Icons.search,
          size: 30,
        ),
        hintText: 'Buscar pago...',
        border:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.black38)),
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.black38)),
        filled: true,
        fillColor: GlobalVariables.greyBackgroundColor,
        isDense: true,
        errorStyle: TextStyle(color: Colors.red, fontSize: 14),
      ),
      maxLines: 1,
    );
  }
}
