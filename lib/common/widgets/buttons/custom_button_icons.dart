import 'package:flutter/material.dart';

class CustomButtonIcons extends StatelessWidget {
  final VoidCallback onTap;
  final bool delete;
  const CustomButtonIcons({Key? key, required this.onTap, required this.delete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: delete ? Colors.red : Colors.green,
                width: 3,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
            child: InkWell(
              onTap: onTap,
              child: SizedBox(
                width: 160,
                height: 40,
                child: Center(
                    child: Icon(
                        delete ? Icons.delete_forever : Icons.edit_sharp,
                        size: 40,
                        color: delete ? Colors.red : Colors.green)),
              ),
            )),
      ),
    );
  }
}
