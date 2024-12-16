// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/widgets.dart';
import 'package:payments_management/constants/global_variables.dart';

class MainCardType extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const MainCardType({
    Key? key,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        //width: 200,
        //height: 60,
        decoration: BoxDecoration(
            //color: GlobalVariables.primaryColor,
            gradient: GlobalVariables.generateButtonGradient,
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                  fontSize: 25,
                  color: GlobalVariables.whiteColor,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
