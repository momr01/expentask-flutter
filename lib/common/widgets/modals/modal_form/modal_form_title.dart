import 'package:flutter/material.dart';

class ModalFormTitle extends StatelessWidget {
  final String text;
  const ModalFormTitle({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      // 'Tarea "${capitalizeFirstLetter(text)}"',
      text,

      //toBeginningOfSentenceCase(text)!,
      //StringUtils.capitalize("helloworld"),
      style: const TextStyle(fontSize: 30),

      overflow: TextOverflow.ellipsis,
      maxLines: 2,
      textAlign: TextAlign.center,
    );
  }
}
