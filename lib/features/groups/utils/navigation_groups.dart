import 'package:flutter/material.dart';
import 'package:payments_management/common/widgets/bottom_bar.dart';
import 'package:payments_management/features/groups/screens/groups_screen.dart';
import 'package:payments_management/features/groups/screens/manage_group_screen.dart';
import 'package:payments_management/features/groups/screens/group_details_screen.dart';
import 'package:payments_management/models/group/group.dart';
import 'package:payments_management/models/group/group_name_checkbox.dart';

void fromGroupsToGroupDetails(context, Group group) {
  Navigator.pushNamed(context, GroupDetailsScreen.routeName, arguments: group);
}

void fromGroupDetailsToManageGroup(context, Group group) {
  Navigator.pushNamed(context, ManageGroupScreen.routeName, arguments: [
    group,
    [GroupNameCheckbox()]
  ]);
}

void fromEditGroupToGroupDetails(context) {
  Navigator.pop(context);
}

void closeModalSelectNames(context) {
  Navigator.pop(context);
}

void fromSuccessToGroups(context) {
  Navigator.pushNamedAndRemoveUntil(
      context, BottomBar.routeName, arguments: 0, (route) => false);

  // Navigator.pushNamedAndRemoveUntil(
  //     context, GroupsScreen.routeName, (route) => false);
  Navigator.pushNamed(context, GroupsScreen.routeName);
  // Navigator.popUntil(
  //     context,
  //    BottomBar.routeName, arguments: 1);

  // Navigator.popAndPushNamed(context, BottomBar.routeName, arguments: 1);
}
