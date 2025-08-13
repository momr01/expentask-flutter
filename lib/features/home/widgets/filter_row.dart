import 'package:flutter/material.dart';
import 'package:payments_management/common/utils/run_filter.dart';
import 'package:payments_management/common/widgets/color_rounded_item.dart';
import 'package:payments_management/constants/global_variables.dart';
import 'package:payments_management/constants/utils.dart';
import 'package:payments_management/features/home/utils/filter_data.dart';
import 'package:payments_management/features/home/utils/filter_option.dart';
import 'package:payments_management/models/payment/payment.dart';

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
    _foundPayments =
        widget.foundPayments; // Inicializa la variable con los datos originales
  }

  void _updateFilterState(String selectedType) {
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
  }

  @override
  Widget build(BuildContext context) {
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
                onTap: () {
                  _filterHasInstallments(widget.filterOptions[index].type);
                },
              ),
          separatorBuilder: (context, index) => const SizedBox(
                width: 15,
              ),
          itemCount: widget.filterOptions.length),
    );
  }
}
