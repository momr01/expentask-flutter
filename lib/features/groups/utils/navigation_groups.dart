import 'package:flutter/material.dart';
import 'package:payments_management/features/groups/screens/manage_group_screen.dart';
import 'package:payments_management/features/groups/screens/group_details_screen.dart';
import 'package:payments_management/models/group/group.dart';

void fromGroupsToGroupDetails(context, Group group) {
  Navigator.pushNamed(context, GroupDetailsScreen.routeName, arguments: group);
}

void fromGroupDetailsToManageGroup(context, Group group) {
  Navigator.pushNamed(context, ManageGroupScreen.routeName, arguments: group);
}

void fromEditGroupToGroupDetails(context) {
  Navigator.pop(context);
}

void closeModalSelectNames(context) {
  Navigator.pop(context);
}
