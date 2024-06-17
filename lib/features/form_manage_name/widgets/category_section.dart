// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:payments_management/constants/global_variables.dart';
import 'package:payments_management/constants/utils.dart';
import 'package:payments_management/models/category/category.dart';

class CategorySection extends StatelessWidget {
  final String categoryValue;
  final Function(String? value) onChange;
  final List<Category>? categories;
  const CategorySection({
    Key? key,
    required this.categoryValue,
    required this.onChange,
    this.categories,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Categoría:',
          style: TextStyle(fontSize: 18),
        ),
        const SizedBox(
          height: 10,
        ),
        categoryValue == "-Seleccione-"
            ? const Text('No existen categorías para seleccionar')
            : DropdownButtonFormField<String>(
                isExpanded: true,
                value: categoryValue,
                icon: const Icon(Icons.arrow_downward),
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: GlobalVariables.greyBackgroundColor,
                    isDense: true),
                onChanged: (String? value) => onChange(value),
                items: categories != null
                    ? categories!
                        .map<DropdownMenuItem<String>>((Category value) {
                        return DropdownMenuItem<String>(
                          value: value.id,
                          //value: "",
                          child: Text(capitalizeFirstLetter(value.name)),
                        );
                      }).toList()
                    : [],
              ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
