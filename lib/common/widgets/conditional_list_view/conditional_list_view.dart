import 'package:flutter/material.dart';
import 'package:payments_management/features/groups/utils/navigation_groups.dart';
import 'package:payments_management/features/groups/widgets/group_main_card.dart';

class ConditionalListView<T> extends StatelessWidget {
  final List<T>? items;
  final List<T>? foundItems;
  final Widget loader;
  final String emptyMessage;
  final String? noResultsMessage;
  final Widget Function(BuildContext, T) itemBuilder;
  final Widget Function(BuildContext, int)? separatorBuilder;
  final double paddingEnd;
  final bool verticalPosition;

  const ConditionalListView(
      {Key? key,
      required this.items,
      this.foundItems,
      required this.loader,
      required this.emptyMessage,
      this.noResultsMessage,
      required this.itemBuilder,
      this.separatorBuilder,
      this.paddingEnd = 0,
      this.verticalPosition = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (items == null) {
      return loader;
    }

    if (items!.isEmpty) {
      return Text(emptyMessage, style: const TextStyle(fontSize: 16));
    }

    if (foundItems != null && foundItems!.isEmpty) {
      return Text(
        noResultsMessage ?? '¡No existen resultados a su búsqueda!',
        style: const TextStyle(fontSize: 16),
      );
    }

    return Expanded(
        child: separatorBuilder != null
            //return separatorBuilder != null
            ? ListView.separated(
                scrollDirection:
                    verticalPosition ? Axis.vertical : Axis.horizontal,
                padding: EdgeInsets.only(bottom: paddingEnd),
                itemBuilder: (context, index) =>
                    itemBuilder(context, foundItems![index]),
                separatorBuilder: separatorBuilder!,
                itemCount: foundItems!.length,
              )
            : ListView.builder(
                scrollDirection:
                    verticalPosition ? Axis.vertical : Axis.horizontal,
                padding: EdgeInsets.only(bottom: paddingEnd),
                itemBuilder: (context, index) =>
                    itemBuilder(context, items![index]),
                itemCount: items!.length,
              ));
  }
}
