// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:payments_management/common/widgets/color_rounded_item.dart';
import 'package:payments_management/common/widgets/custom_app_bar.dart';
import 'package:payments_management/common/widgets/main_title.dart';
import 'package:payments_management/constants/date_format.dart';
import 'package:payments_management/constants/global_variables.dart';
import 'package:payments_management/features/categories/services/categories_services.dart';
import 'package:payments_management/features/form_edit_payment/services/form_edit_payment_services.dart';
import 'package:payments_management/features/historical/utils/navigation_historical.dart';
import 'package:payments_management/features/historical/widgets/date_selection_filter_item.dart';
import 'package:payments_management/features/names/services/names_services.dart';

class HistoricalFilter {
  final int id;
  final String name;
  bool checkState;
  final List<FilterOption> options;
  final bool isDate;
  final List<FilterByDateOption> dateFields;

  HistoricalFilter(
      {required this.id,
      required this.name,
      required this.checkState,
      required this.options,
      required this.isDate,
      required this.dateFields});
}

class FilterOption {
  final String id;
  final String name;
  bool checkState;

  FilterOption({
    required this.id,
    required this.name,
    required this.checkState,
  });
}

class FilterByDateOption {
  final String id;
  final String label;
  TextEditingController controller;

  FilterByDateOption({
    required this.id,
    required this.label,
    required this.controller,
  });
}

class HistoricalFilterScreen extends StatefulWidget {
  static const String routeName = '/historical-filter';
  const HistoricalFilterScreen({super.key});

  @override
  State<HistoricalFilterScreen> createState() => _HistoricalFilterScreenState();
}

class _HistoricalFilterScreenState extends State<HistoricalFilterScreen> {
  final List<FilterOption> estados = [
    FilterOption(id: 'completados', name: 'COMPLETADOS', checkState: false),
    FilterOption(id: 'anulados', name: 'ANULADOS', checkState: false),
    FilterOption(id: 'pendientes', name: 'PENDIENTES', checkState: false)
  ];
  List<FilterOption> names = [];
  List<FilterOption> categories = [];

  late List<HistoricalFilter> values;

  bool _isLoading = false;
  bool _btnApplyEnabled = false;

  final FormEditPaymentServices formEditPaymentServices =
      FormEditPaymentServices();
  final NamesServices namesServices = NamesServices();
  final CategoriesServices categoriesServices = CategoriesServices();

  final TextEditingController _dateFrom = TextEditingController();
  final TextEditingController _dateTo = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _dateFrom.dispose();
    _dateTo.dispose();
    BackButtonInterceptor.remove(backDeviceInterceptor);
  }

  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(backDeviceInterceptor);
    fetchFilterData();

    values = [
      HistoricalFilter(
          id: 1,
          name: 'Estado',
          checkState: false,
          options: estados,
          isDate: false,
          dateFields: []),
      HistoricalFilter(
          id: 2,
          name: 'Nombre',
          checkState: false,
          options: names,
          isDate: false,
          dateFields: []),
      HistoricalFilter(
          id: 3,
          name: 'Categoría',
          checkState: false,
          options: categories,
          isDate: false,
          dateFields: []),
      HistoricalFilter(
          id: 4,
          name: 'Fecha',
          checkState: false,
          options: [],
          isDate: true,
          dateFields: [
            FilterByDateOption(id: '1', label: 'Desde', controller: _dateFrom),
            FilterByDateOption(id: '2', label: 'Hasta', controller: _dateTo)
          ])
    ];

    _dateFrom.text = datetimeToString(DateTime(
        DateTime.now().year - 1, DateTime.now().month, DateTime.now().day));
    _dateTo.text = datetimeToString(DateTime.now());
  }

  fetchFilterData() async {
    setState(() {
      _isLoading = true;
    });
    final resNames = await namesServices.fetchPaymentNames();

    for (var name in resNames) {
      names.add(FilterOption(id: name.id!, name: name.name, checkState: false));
    }

    final resCategories =
        await categoriesServices.fetchCategories(context: context);
    for (var category in resCategories) {
      categories.add(FilterOption(
          id: category.id!, name: category.name, checkState: false));
    }

    setState(() {
      _isLoading = false;
    });
  }

  bool backDeviceInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    return true;
  }

  // fetchCategories() async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   final response = await namesServices.fetchCategories(context: context);
  //   for (var category in response) {
  //     categories.add(FilterOption(
  //         id: category.id!, name: category.name, checkState: false));
  //   }

  //   setState(() {
  //     _isLoading = false;
  //   });
  // }

  void selectAnOption(int idTitle, String idOption) {
    HistoricalFilter item =
        values.where((val) => val.id == idTitle).toList()[0];

    FilterOption option =
        item.options.where((opt) => opt.id == idOption).toList()[0];

    option.checkState = !option.checkState;

    changeCheckboxState();
    checkAtLeastOneFilterToApply();

    setState(() {});
  }

  void changeCheckboxState() {
    for (var element in values) {
      if (!element.isDate) {
        int quantity = 0;

        for (var option in element.options) {
          if (option.checkState) quantity++;
        }

        if (quantity > 0) {
          element.checkState = true;
        } else {
          element.checkState = false;
        }
      }
    }

    setState(() {});
  }

  void checkAtLeastOneFilterToApply() {
    int quantity = 0;
    for (var element in values) {
      if (element.checkState) {
        quantity++;
      }
    }

    if (quantity >= 1) {
      _btnApplyEnabled = true;
    } else {
      _btnApplyEnabled = false;
    }

    setState(() {});
  }

  void applyFilter() {
    List<HistoricalFilter> finalFilter = [];
    for (var element in values) {
      if (element.checkState) {
        //   debugPrint(element.name);
        if (!element.isDate) {
          HistoricalFilter newFilter = HistoricalFilter(
              id: element.id,
              name: element.name,
              checkState: true,
              options: [],
              isDate: false,
              dateFields: []);
          for (var option in element.options) {
            if (option.checkState) {
              newFilter.options.add(FilterOption(
                  id: option.id, name: option.name, checkState: true));
            }
          }

          if (newFilter.options.isNotEmpty) {
            finalFilter.add(newFilter);
          }
        } else {
          HistoricalFilter newFilter = HistoricalFilter(
              id: element.id,
              name: element.name,
              checkState: true,
              options: [],
              isDate: true,
              dateFields: []);

          newFilter.options.add(
            FilterOption(id: _dateFrom.text, name: 'Desde', checkState: true),
          );
          newFilter.options.add(
              FilterOption(id: _dateTo.text, name: 'Hasta', checkState: true));

          if (newFilter.options.isNotEmpty) {
            finalFilter.add(newFilter);
          }
        }
      }
    }
    // for (var element in finalFilter) {
    //   debugPrint(element.id.toString());
    //   debugPrint(element.name);

    //   for (var el in element.options) {
    //     debugPrint(el.id);
    //     debugPrint(el.name);
    //   }

    //   debugPrint("----------------");
    // }
    // Navigator.popUntil(
    //     context,
    //     ModalRoute.withName(
    //       BottomBar.routeName,
    //     ));

    // Navigator.pop(context);
    // Navigator.popAndPushNamed(context, HistoricalScreen.routeName,
    //     arguments: finalFilter);
    fromFilterToMain(context, finalFilter);
  }

  void selectDate(TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101));

    if (pickedDate != null) {
      String formattedDate =
          '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';

      setState(() {
        controller.text = formattedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return
        // WillPopScope(
        //     onWillPop: () async {
        //       // await Navigator.pushNamedAndRemoveUntil(
        //       //     context, HistoricalScreen.routeName, (route) => false);
        //       // await Navigator.pushNamed(context, HistoricalScreen.routeName);
        //       return true;
        //     },
        //     child:
        Scaffold(
      appBar: customAppBar(context),
      floatingActionButton: SizedBox(
        height: 80,
        width: 80,
        child: FloatingActionButton(
          shape: const CircleBorder(),
          backgroundColor: GlobalVariables.historicalPending,
          foregroundColor: Colors.white,
          //onPressed: () => navigateToFormNameScreen(context),
          //onPressed: _getDataToForm,
          // onPressed: () => getDataToForm(
          //     context,
          //     PaymentName(
          //         name: "name",
          //         isActive: false,
          //         category: Category(name: "", isActive: false))),
          onPressed: () => cleanFiltersAndReturnToMain(context),
          child: const Icon(
            Icons.cleaning_services,
            size: 40,
          ),
        ),
      ),
      body: ModalProgressHUD(
        color: GlobalVariables.greyBackgroundColor,
        opacity: 0.8,
        blur: 0.8,
        inAsyncCall: _isLoading,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const MainTitle(title: 'Filtros'),
                  _btnApplyEnabled
                      ? ColorRoundedItem(
                          colorBackCard: GlobalVariables.primaryColor,
                          colorBorderCard: GlobalVariables.primaryColor,
                          text: 'APLICAR',
                          colorText: Colors.white,
                          sizeText: 18,
                          onTap: applyFilter,
                        )
                      : const SizedBox()
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                  child: ListView.builder(
                      itemCount: values.length,
                      itemBuilder: (context, indexTitle) {
                        return Container(
                          decoration: const BoxDecoration(
                              border: Border(bottom: BorderSide())),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 30, top: 8),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Checkbox(
                                      value: values[indexTitle].checkState,
                                      onChanged: (bool? value) {
                                        if (values[indexTitle].isDate) {
                                          setState(() {
                                            values[indexTitle].checkState =
                                                value!;
                                            checkAtLeastOneFilterToApply();
                                          });
                                        }
                                        /* if (values[indexTitle]
                                                .options
                                                .isNotEmpty) {
                                              setState(() {
                                                //paymentState = value!;
                                                values[indexTitle].checkState =
                                                    value!;
                                              });
                                            } else {
                                              setState(() {
                                                values[indexTitle].checkState =
                                                    false;
                                              });
                                            }*/
                                      },
                                    ),
                                    Text(
                                      values[indexTitle].name,
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                  ],
                                ),
                                !values[indexTitle].isDate &&
                                        values[indexTitle].dateFields.isEmpty
                                    ? SizedBox(
                                        height: 40,
                                        child: ListView.separated(
                                            separatorBuilder:
                                                (context, index) =>
                                                    const SizedBox(
                                                      width: 15,
                                                    ),
                                            scrollDirection: Axis.horizontal,
                                            itemCount: values[indexTitle]
                                                .options
                                                .length,
                                            itemBuilder:
                                                (context, indexOption) {
                                              return ColorRoundedItem(
                                                colorBackCard: values[
                                                            indexTitle]
                                                        .options[indexOption]
                                                        .checkState
                                                    ? GlobalVariables
                                                        .selectedNavBarColor
                                                    : Colors.white,
                                                colorBorderCard: Colors.white,
                                                text: values[indexTitle]
                                                    .options[indexOption]
                                                    .name
                                                    .toUpperCase(),
                                                colorText: values[indexTitle]
                                                        .options[indexOption]
                                                        .checkState
                                                    ? Colors.white
                                                    : Colors.black,
                                                onTap: () => selectAnOption(
                                                    values[indexTitle].id,
                                                    values[indexTitle]
                                                        .options[indexOption]
                                                        .id),
                                              );
                                            }),
                                      )
                                    : Row(
                                        children: [
                                          DateSelectionFilterItem(
                                              label: 'Desde',
                                              controller: _dateFrom,
                                              onTap: () =>
                                                  selectDate(_dateFrom)),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          DateSelectionFilterItem(
                                              label: 'Hasta',
                                              controller: _dateTo,
                                              onTap: () => selectDate(_dateTo)),
                                        ],
                                      ),
                              ],
                            ),
                          ),
                        );
                      }))
            ],
          ),
        ),
      ),
      //)
    );
  }
}
