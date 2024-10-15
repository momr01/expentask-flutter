import 'package:flutter/material.dart';
import 'package:payments_management/models/category/category.dart';

class CategoryCard extends StatefulWidget {
  final Category category;
  const CategoryCard({super.key, required this.category});

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Column(
        children: [
          Row(
            children: [
              Text(widget.category.name),
              Text(widget.category.listNames == []
                  ? "0"
                  : widget.category.listNames!.length.toString())
            ],
          )
        ],
      ),
    );
  }
}
