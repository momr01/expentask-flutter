import 'package:flutter/material.dart';
import 'package:payments_management/common/utils/run_filter.dart';
import 'package:payments_management/common/widgets/color_rounded_item.dart';
import 'package:payments_management/constants/global_variables.dart';
import 'package:payments_management/constants/navigator_keys.dart';
import 'package:payments_management/constants/utils.dart';
import 'package:payments_management/features/categories/services/categories_services.dart';
import 'package:payments_management/features/home/screens/home_screen.dart';
import 'package:payments_management/features/home/utils/filter_data.dart';
import 'package:payments_management/features/home/utils/filter_option.dart';
import 'package:payments_management/features/home/utils/show_category_dialog.dart';
import 'package:payments_management/features/home/widgets/categories_dialog.dart';
import 'package:payments_management/models/category/category.dart';
import 'package:payments_management/models/payment/payment.dart';
import 'package:provider/provider.dart';

class FilterRow extends StatefulWidget {
  final List<FilterOption> filterOptions;
  final List<Payment> payments;
  final List<Payment> foundPayments;
  final Function(List<Payment>) onPaymentsFiltered; // Agregamos el callback
  const FilterRow({
    super.key,
    required this.filterOptions,
    required this.payments,
    required this.foundPayments,
    required this.onPaymentsFiltered, // Lo hacemos obligatorio
  });

  @override
  State<FilterRow> createState() => _FilterRowState();
}

class _FilterRowState extends State<FilterRow> {
  late List<Payment> _foundPayments;

  @override
  void initState() {
    super.initState();
    // _foundPayments =
    //  widget.foundPayments; // Inicializa la variable con los datos originales
    // _filterHasInstallments("month");

    /*_foundPayments = widget.foundPayments
        .where((payment) => payment.tasks.any((task) =>
            !task.isCompleted &&
            task.deadline.month == DateTime.now().month &&
            task.deadline.year == DateTime.now().year))
        .toList();*/
    //  _foundPayments = widget.foundPayments;
    //  _applyDefaultFilter();
  }

  /*void _applyDefaultFilter() {
    _foundPayments = widget.foundPayments
        .where((payment) => payment.tasks.any((task) =>
            !task.isCompleted &&
            task.deadline.month == DateTime.now().month &&
            task.deadline.year == DateTime.now().year))
        .toList();

    // Notificar al padre
    widget.onPaymentsFiltered(_foundPayments);
  }*/

/*  void _updateFilterState(String selectedType) {
    widget.filterOptions
        .where((element) => element.type == selectedType)
        .first
        .state = true;

    widget.filterOptions
        .where((element) => element.type != selectedType)
        .forEach((element) => element.state = false);
  }

  void _filterHasInstallments(String type, {String? keyword}) {
    setState(() {
      // Buscar el filtro en la lista
      var selectedFilter = filterData
          .firstWhere((filter) => filter["type"] == type, orElse: () => {});

      if (selectedFilter.isNotEmpty) {
        // Aplicar el filtro correspondiente
        _foundPayments = selectedFilter["filter"](widget.payments);
        _updateFilterState(type);
      }

      // Caso especial para búsqueda
      if (type == "search" && keyword != null) {
        _foundPayments = runFilter<Payment>(
          keyword,
          widget.payments,
          //widget.foundPayments,
          (payment) =>
              payment.name.name.toLowerCase().contains(keyword.toLowerCase()),
        );
      }

      // Notificar al widget padre
      widget.onPaymentsFiltered(_foundPayments);
    });
  }*/

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<HomeScreenViewModel>(context, listen: false);

    return SizedBox(
      height: 40,
      child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) => ColorRoundedItem(
                colorBackCard: widget.filterOptions[index].state
                    ? GlobalVariables.blueActionColor
                    : GlobalVariables.greyBackgroundColor,
                colorBorderCard: GlobalVariables.blueActionColor,
                text: capitalizeFirstLetter(widget.filterOptions[index].name),
                colorText: Colors.black,
                sizeText: 13,
                /*onTap: () {
                  _filterHasInstallments(widget.filterOptions[index].type);
                },*/
                // onTap: () =>
                //     vm.filterHasInstallments(widget.filterOptions[index].type),
                // onTap: () async {
                //   if (widget.filterOptions[index].type == "category") {
                //     final categorySelected = await _showCategoryDialog(context);
                //     debugPrint("categoria elegida: " + categorySelected != null ? "ss" : "ss");
                //   } else {
                //     vm.filterHasInstallments(widget.filterOptions[index].type);
                //   }
                // },
                onTap: () async {
                  if (widget.filterOptions[index].type == "category") {
                    final String? categorySelected =
                        await showCategoryDialog(context);

                    // debugPrint(
                    //   "Categoría elegida: ${categorySelected != null ? categorySelected : 'ninguna'}",
                    // );

                    if (categorySelected != null) {
                      // Aquí podés aplicar tu filtro o acción
                      // vm.applyCategoryFilter(categorySelected);
                      // vm.filterCategory(
                      //     widget.filterOptions[index].type, categorySelected);
                      vm.filterHasInstallments(widget.filterOptions[index].type,
                          keyword: categorySelected);
                    }
                  } else {
                    vm.filterHasInstallments(widget.filterOptions[index].type);
                  }
                },
              ),
          separatorBuilder: (context, index) => const SizedBox(
                width: 15,
              ),
          itemCount: widget.filterOptions.length),
    );
  }
}

/*
Future<String?> _showCategoryDialog(BuildContext context) async {
  //final context = NavigatorKeys.navKey.currentContext!;

  return showDialog<String>(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    builder: (context) {
      return Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Selecciona una categoría',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ...['Hogar', 'Trabajo', 'Otros'].map((opt) {
                return ListTile(
                  title: Text(opt),
                  onTap: () => Navigator.pop(context, opt),
                );
              }),
            ],
          ),
        ),
      );
    },
  );
}*/

/*

Future<String?> _showCategoryDialog(BuildContext context) async {
  return showDialog<String>(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Selecciona una categoría',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ...[
                'Hogar',
                'Trabajo',
                'Otros',
                'Hogar',
                'Trabajo',
                'Otros',
                'Hogar',
                'Trabajo',
                'Otros'
              ].map((opt) {
                return ListTile(
                  title: Text(opt),
                  onTap: () => Navigator.pop(context, opt),
                );
              }),
            ],
          ),
        ),
      );
    },
  );
}*/
