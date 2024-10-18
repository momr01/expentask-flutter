import 'package:flutter/material.dart';
import 'package:payments_management/features/categories/widgets/category_card_header_title.dart';
import 'package:payments_management/models/category/category.dart';

class CategoryCardHeader extends StatelessWidget {
  final Category category;
  final double paddingX;
  const CategoryCardHeader(
      {super.key, required this.category, required this.paddingX});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: paddingX),
      height: 70,
      decoration: BoxDecoration(border: Border.all(), color: Colors.grey),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CategoryCardHeaderTitle(text: category.name),
          CategoryCardHeaderTitle(
              text: category.listNames == []
                  ? "0"
                  : category.listNames!.length.toString())
        ],
      ),
    );
  }
}
