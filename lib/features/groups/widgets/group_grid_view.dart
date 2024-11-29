import 'package:flutter/material.dart';
import 'package:payments_management/features/groups/utils/navigation_groups.dart';
import 'package:payments_management/features/groups/widgets/group_main_card.dart';
import 'package:payments_management/models/group/group.dart';

class GroupGridView extends StatelessWidget {
  final List<Group>? groups;
  final List<Group>? foundGroups;
  final Widget loader;
  final String emptyMessage;
  final String? noResultsMessage;
  // final Widget Function(BuildContext, T) itemBuilder;
  // final Widget Function(BuildContext, int)? separatorBuilder;
  // final double paddingEnd;
  const GroupGridView({
    super.key,
    required this.groups,
    this.foundGroups,
    required this.loader,
    required this.emptyMessage,
    this.noResultsMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (groups == null) {
      return loader;
    }

    if (groups!.isEmpty) {
      return Text(emptyMessage, style: const TextStyle(fontSize: 16));
    }

    if (foundGroups != null && foundGroups!.isEmpty) {
      return Text(
        noResultsMessage ?? '¡No existen resultados a su búsqueda!',
        style: const TextStyle(fontSize: 16),
      );
    }

    return Expanded(
      child: GridView.count(
        primary: false,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        crossAxisCount: 2,
        //children: _foundGroups
        children: foundGroups!
            .map(
              (group) => GestureDetector(
                onTap: () => fromGroupsToGroupDetails(context, group),
                child: GroupMainCard(
                  group: group,
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
