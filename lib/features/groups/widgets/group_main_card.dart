// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:payments_management/constants/global_variables.dart';
import 'package:payments_management/features/groups/widgets/group_logo.dart';
import 'package:payments_management/models/group/group.dart';

class GroupMainCard extends StatelessWidget {
  final Group group;
  const GroupMainCard({
    Key? key,
    required this.group,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      color: GlobalVariables.primaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Spacer(),
          GroupLogo(letter: group.name[0]),
          const Spacer(),
          Text(
            'Grupo ${group.name.toUpperCase()}',
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: GlobalVariables.whiteColor,
                fontWeight: FontWeight.w500,
                fontSize: 16),
          ),
          Text(
            group.paymentNames.length.toString(),
            style: const TextStyle(
                color: GlobalVariables.whiteColor,
                fontWeight: FontWeight.w500,
                fontSize: 16),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
