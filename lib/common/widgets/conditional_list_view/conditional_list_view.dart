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
  final ScrollController? controller; // 👈 nuevo parámetro

  const ConditionalListView({
    Key? key,
    required this.items,
    this.foundItems,
    required this.loader,
    required this.emptyMessage,
    this.noResultsMessage,
    required this.itemBuilder,
    this.separatorBuilder,
    this.paddingEnd = 0,
    this.verticalPosition = true,
    this.controller, // 👈 nuevo
  }) : super(key: key);

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
                controller: controller, // 👈 agregado aquí
                scrollDirection:
                    verticalPosition ? Axis.vertical : Axis.horizontal,
                padding: EdgeInsets.only(bottom: paddingEnd),
                itemBuilder: (context, index) =>
                    itemBuilder(context, foundItems![index]),
                separatorBuilder: separatorBuilder!,
                itemCount: foundItems!.length,
              )
            : ListView.builder(
                controller: controller, // 👈 agregado aquí también
                scrollDirection:
                    verticalPosition ? Axis.vertical : Axis.horizontal,
                padding: EdgeInsets.only(bottom: paddingEnd),
                itemBuilder: (context, index) =>
                    itemBuilder(context, items![index]),
                itemCount: items!.length,
              ));

/*    return Expanded(
      child: Stack(
        children: [
          separatorBuilder != null
              ? ListView.separated(
                  controller: controller,
                  scrollDirection:
                      verticalPosition ? Axis.vertical : Axis.horizontal,
                  padding: EdgeInsets.only(bottom: paddingEnd),
                  itemBuilder: (context, index) =>
                      itemBuilder(context, foundItems![index]),
                  separatorBuilder: separatorBuilder!,
                  itemCount: foundItems!.length,
                )
              : ListView.builder(
                  controller: controller,
                  scrollDirection:
                      verticalPosition ? Axis.vertical : Axis.horizontal,
                  padding: EdgeInsets.only(bottom: paddingEnd),
                  itemBuilder: (context, index) =>
                      itemBuilder(context, items![index]),
                  itemCount: items!.length,
                ),

          // 👇 Botón flotante de scroll (seguro para nulls)
          ValueListenableBuilder<bool>(
            valueListenable: controller?.position.isScrollingNotifier ??
                ValueNotifier(false),
            builder: (context, isScrolling, _) {
              // Evitar errores si el controller no está listo
              if (controller == null || !controller!.hasClients) {
                return const SizedBox.shrink();
              }

              final offset = controller!.offset;
              final maxExtent = controller!.position.maxScrollExtent;

              // Mostrar solo si no estás al inicio ni al final
              final showButton = offset > 200 && offset < maxExtent - 200;

              if (!showButton) return const SizedBox.shrink();

              // Determinar dirección
              final isNearTop = offset < maxExtent / 2;

              return Positioned(
                bottom: 20,
                right: 20,
                child: FloatingActionButton.small(
                  backgroundColor: Colors.grey[800],
                  onPressed: () {
                    if (!controller!.hasClients) return;
                    controller!.animateTo(
                      isNearTop ? maxExtent : 0,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOut,
                    );
                  },
                  child: Icon(
                    isNearTop ? Icons.arrow_downward : Icons.arrow_upward,
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );*/
  }
}


/*

import 'package:flutter/material.dart';

class ConditionalListView<T> extends StatefulWidget {
  final List<T>? items;
  final List<T>? foundItems;
  final Widget loader;
  final String emptyMessage;
  final String? noResultsMessage;
  final Widget Function(BuildContext, T) itemBuilder;
  final Widget Function(BuildContext, int)? separatorBuilder;
  final double paddingEnd;
  final bool verticalPosition;
  final ScrollController? controller;

  const ConditionalListView({
    Key? key,
    required this.items,
    this.foundItems,
    required this.loader,
    required this.emptyMessage,
    this.noResultsMessage,
    required this.itemBuilder,
    this.separatorBuilder,
    this.paddingEnd = 0,
    this.verticalPosition = true,
    this.controller,
  }) : super(key: key);

  @override
  State<ConditionalListView<T>> createState() => _ConditionalListViewState<T>();
}

class _ConditionalListViewState<T> extends State<ConditionalListView<T>> {
  late final ScrollController _controller;
  bool _showButton = false;
  bool _scrollUp = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? ScrollController();

    // Se asegura de que el scroll esté escuchando solo cuando está montado
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_controller.hasClients) {
        _controller.addListener(_onScroll);
      }
    });
  }

  void _onScroll() {
    if (!_controller.hasClients) return;

    final offset = _controller.offset;
    final maxExtent = _controller.position.maxScrollExtent;

    final newShowButton = offset > 200 && offset < maxExtent - 200;
    final newScrollUp = offset < maxExtent / 2;

    if (newShowButton != _showButton || newScrollUp != _scrollUp) {
      setState(() {
        _showButton = newShowButton;
        _scrollUp = newScrollUp;
      });
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      // Solo lo limpiamos si lo creamos internamente
      _controller.dispose();
    } else {
      _controller.removeListener(_onScroll);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.items;
    final foundItems = widget.foundItems;

    if (items == null) return widget.loader;

    if (items.isEmpty) {
      return Text(widget.emptyMessage, style: const TextStyle(fontSize: 16));
    }

    if (foundItems != null && foundItems.isEmpty) {
      return Text(
        widget.noResultsMessage ?? '¡No existen resultados a su búsqueda!',
        style: const TextStyle(fontSize: 16),
      );
    }

    final listView = widget.separatorBuilder != null
        ? ListView.separated(
            controller: _controller,
            scrollDirection:
                widget.verticalPosition ? Axis.vertical : Axis.horizontal,
            padding: EdgeInsets.only(bottom: widget.paddingEnd),
            itemBuilder: (context, index) =>
                widget.itemBuilder(context, foundItems![index]),
            separatorBuilder: widget.separatorBuilder!,
            itemCount: foundItems!.length,
          )
        : ListView.builder(
            controller: _controller,
            scrollDirection:
                widget.verticalPosition ? Axis.vertical : Axis.horizontal,
            padding: EdgeInsets.only(bottom: widget.paddingEnd),
            itemBuilder: (context, index) =>
                widget.itemBuilder(context, items[index]),
            itemCount: items.length,
          );

    return Expanded(
      child: Stack(
        children: [
          listView,
          if (_showButton)
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton.small(
                backgroundColor: Colors.grey[850],
                onPressed: () {
                  if (!_controller.hasClients) return;
                  _controller.animateTo(
                    _scrollUp ? _controller.position.maxScrollExtent : 0,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOut,
                  );
                },
                child: Icon(
                  _scrollUp ? Icons.arrow_downward : Icons.arrow_upward,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
*/