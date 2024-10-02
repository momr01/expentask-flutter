import 'package:flutter/material.dart';

class CustomButtonGreenDisabled extends StatelessWidget {
  const CustomButtonGreenDisabled({super.key});

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: Center(
        child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Colors.green,
                width: 3,
              ),
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: InkWell(
              onTap: null,
              child: SizedBox(
                width: 160,
                height: 40,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Center(
                      child: CircularProgressIndicator(
                    color: Colors.green,
                    strokeWidth: 6,
                  )),
                ),
              ),
            )),
      ),
    );
  }
}
