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
    return Container(
      decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30))),
      //height: 100,
      child: Column(
        children: [
          Container(
            height: 60,
            decoration: BoxDecoration(border: Border.all()),
            child: Row(
              children: [
                Text(widget.category.name),
                Text(widget.category.listNames == []
                    ? "0"
                    : widget.category.listNames!.length.toString())
              ],
            ),
          ),
          const Row(children: [Text("Editar"), Text("Eliminar")]),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: widget.category.listNames!
                .map((e) => Row(children: [Text(e.name)]))
                .toList(),
          ),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
