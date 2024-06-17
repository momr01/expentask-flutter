import 'package:flutter/material.dart';
import 'package:payments_management/features/groups/screens/edit_group_screen.dart';
import 'package:payments_management/features/groups/screens/group_details_screen.dart';
import 'package:payments_management/models/group/group.dart';

void fromGroupsToGroupDetails(context, Group group) {
  Navigator.pushNamed(context, GroupDetailsScreen.routeName, arguments: group);
}

void fromGroupDetailsToEditGroup(context, Group group) {
  Navigator.pushNamed(context, EditGroupScreen.routeName, arguments: group);
}

void fromEditGroupToGroupDetails(context) {
  Navigator.pop(context);
}

void closeModalSelectNames(context) {
  Navigator.pop(context);
}
