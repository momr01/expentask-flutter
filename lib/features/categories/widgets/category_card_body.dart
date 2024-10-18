import 'package:flutter/material.dart';
import 'package:payments_management/models/name/payment_name.dart';

class CategoryCardBody extends StatelessWidget {
  final List<PaymentName> listNames;
  final double paddingX;
  const CategoryCardBody(
      {super.key, required this.listNames, required this.paddingX});

  @override
  Widget build(BuildContext context) {
    TextStyle formatText() {
      return const TextStyle(
          fontWeight: FontWeight.bold, fontSize: 15, letterSpacing: 1);
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: paddingX),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: listNames.asMap().entries.map((e) {
            final index = e.key + 1;
            final name = e.value.name;

            return Column(
              children: [
                Row(
                  children: [
                    Text(
                      index.toString(),
                      style: formatText(),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      name,
                      style: formatText(),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                )
              ],
            );
          }).toList()),
    );
  }
}
