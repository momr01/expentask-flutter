// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:payments_management/common/widgets/color_rounded_item.dart';
import 'package:payments_management/constants/utils.dart';
import 'package:payments_management/features/names/widgets/modal_name_details.dart';
import 'package:payments_management/models/name/payment_name.dart';

class NameCard extends StatelessWidget {
  final PaymentName name;
  const NameCard({
    Key? key,
    required this.name,
  }) : super(key: key);

  void openModalNameDetails(BuildContext context) async {
    showDialog<String>(
        barrierDismissible: false,
        context: context,
        builder: (context) => ModalNameDetails(name: name));
  }

  @override
  Widget build(BuildContext context) {
    return
        //Card(
        Container(
      decoration: const BoxDecoration(border: Border(bottom: BorderSide())),

      // color: Colors.blueGrey.shade100,
      //  clipBehavior: Clip.hardEdge,
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () async {
          openModalNameDetails(context);
        },
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: SizedBox(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(capitalizeFirstLetter(name.name),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                style: const TextStyle(fontSize: 20)),
                            const SizedBox(
                              height: 10,
                            ),
                            ColorRoundedItem(
                                colorBackCard: Colors.purple,
                                colorBorderCard: Colors.purple,
                                text: capitalizeFirstLetter(name.category.name),
                                colorText: Colors.white)
                          ]),
                    ),
                    const Icon(Icons.visibility_outlined, size: 50)
                  ]),
            )),
      ),
    );
  }
}
