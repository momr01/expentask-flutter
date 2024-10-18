import 'package:flutter/material.dart';
import 'package:payments_management/features/categories/widgets/category_card_body.dart';
import 'package:payments_management/features/categories/widgets/category_card_buttons.dart';
import 'package:payments_management/features/categories/widgets/category_card_header.dart';
import 'package:payments_management/models/category/category.dart';

class CategoryCard extends StatefulWidget {
  final Category category;
  const CategoryCard({super.key, required this.category});

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  final double paddingX = 15;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(),
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30))),
      //height: 100,
      child: Column(
        children: [
          CategoryCardHeader(
            category: widget.category,
            paddingX: paddingX,
          ),
          CategoryCardButtons(
            category: widget.category,
          ),
          CategoryCardBody(
            listNames: widget.category.listNames!,
            paddingX: paddingX,
          ),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
