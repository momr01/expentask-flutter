// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:payments_management/common/widgets/custom_app_bar.dart';
import 'package:payments_management/common/widgets/drawer/custom_drawer.dart';
import 'package:payments_management/common/widgets/loader.dart';
import 'package:payments_management/common/widgets/main_title.dart';
import 'package:payments_management/constants/global_variables.dart';
import 'package:payments_management/features/historical/screens/historical_filter_screen.dart';
import 'package:payments_management/features/historical/services/historical_services.dart';
import 'package:payments_management/features/historical/utils/historical_utils.dart';
import 'package:payments_management/features/historical/widgets/historical_item_card.dart';
import 'package:payments_management/models/payment/payment.dart';

class HistoricalScreen extends StatefulWidget {
  static const String routeName = '/historical';
  final List<HistoricalFilter> finalFilter;
  const HistoricalScreen({
    Key? key,
    required this.finalFilter,
  }) : super(key: key);

  @override
  State<HistoricalScreen> createState() => _HistoricalScreenState();
}

class _HistoricalScreenState extends State<HistoricalScreen> {
  List<Payment>? payments;
  List<Payment> _foundPayments = [];
  final TextEditingController _searchController = TextEditingController();
  final HistoricalServices historicalServices = HistoricalServices();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchAllPayments();
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  fetchAllPayments() async {
    setState(() {
      _isLoading = true;
    });
    List<Payment> beforeFilter =
        await historicalServices.fetchAllPayments(context: context);

    payments = customFilter(beforeFilter);
    setState(() {
      _foundPayments = payments!;
      _isLoading = false;
    });
  }

  void _runFilter(String enteredKeyword) {
    List<Payment> results = [];
    if (enteredKeyword.isEmpty) {
      results = payments!;
    } else {
      results = payments!
          .where((payment) => payment.name.name
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _foundPayments = results;
    });
  }

  List<Payment> filterByOneOption(List<Payment> allItems) {
    List<Payment> afterFilter = [];
    for (var element in widget.finalFilter) {
      switch (element.id) {
        case 1:
          afterFilter = filterByState(allItems, widget.finalFilter);
          break;
        case 2:
          afterFilter = filterByName(allItems, widget.finalFilter);
          break;
        case 3:
          afterFilter = filterByCategory(allItems, widget.finalFilter);
          break;
        case 4:
          afterFilter = filterByDate(allItems, widget.finalFilter);
          break;
      }
    }

    return afterFilter;
    //  }
  }

  List<Payment> filterByTwoOptions(List<Payment> allItems, int indexState,
      int indexName, int indexCategory, int indexDate) {
    List<Payment> afterFilter = [];

    if (indexState != -1 && indexName != -1) {
      afterFilter = filterByState(
          filterByName(allItems, widget.finalFilter), widget.finalFilter);
    } else if (indexState != -1 && indexCategory != -1) {
      afterFilter = filterByState(
          filterByCategory(allItems, widget.finalFilter), widget.finalFilter);
    } else if (indexState != -1 && indexDate != -1) {
    } else if (indexName != -1 && indexCategory != -1) {
      afterFilter = filterByName(
          filterByCategory(allItems, widget.finalFilter), widget.finalFilter);
    } else if (indexName != -1 && indexDate != -1) {
    } else {}

    return afterFilter;
  }

  List<Payment> filterByThreeOptions(List<Payment> allItems, int indexState,
      int indexName, int indexCategory, int indexDate) {
    List<Payment> afterFilter = [];

    if (indexState != -1 && indexName != -1 && indexCategory != -1) {
      afterFilter = filterByState(
          filterByName(filterByCategory(allItems, widget.finalFilter),
              widget.finalFilter),
          widget.finalFilter);
    } else if (indexState != -1 && indexName != -1 && indexDate != -1) {
      afterFilter = filterByState(
          filterByName(
              filterByDate(allItems, widget.finalFilter), widget.finalFilter),
          widget.finalFilter);
    } else if (indexState != -1 && indexCategory != -1 && indexDate != -1) {
      afterFilter = filterByState(
          filterByCategory(
              filterByDate(allItems, widget.finalFilter), widget.finalFilter),
          widget.finalFilter);
    } else {
      afterFilter = filterByName(
          filterByCategory(
              filterByDate(allItems, widget.finalFilter), widget.finalFilter),
          widget.finalFilter);
    }

    return afterFilter;
  }

  List<Payment> filterByFourOptions(List<Payment> allItems) {
    List<Payment> afterFilter = [];

    afterFilter = filterByState(
        filterByName(
            filterByCategory(
                filterByDate(allItems, widget.finalFilter), widget.finalFilter),
            widget.finalFilter),
        widget.finalFilter);

    return afterFilter;
  }

  List<Payment> customFilter(List<Payment> allItems) {
    // List<Payment> afterFilter =
    //     allItems.where((item) => item.name.name == "Capilla Aysam").toList();

    List<Payment> afterFilter = [];

    int indexState = widget.finalFilter.indexWhere(
      (element) => element.id == 1,
    );

    int indexName = widget.finalFilter.indexWhere(
      (element) => element.id == 2,
    );

    int indexCategory = widget.finalFilter.indexWhere(
      (element) => element.id == 3,
    );

    int indexDate = widget.finalFilter.indexWhere(
      (element) => element.id == 4,
    );

    // List<Payment> addingNewFilters = [];

    if (widget.finalFilter.isNotEmpty) {
      debugPrint(widget.finalFilter.length.toString());

      switch (widget.finalFilter.length) {
        case 1:
          afterFilter = filterByOneOption(allItems);

          break;
        case 2:
          afterFilter = filterByTwoOptions(
              allItems, indexState, indexName, indexCategory, indexDate);
          break;
        case 3:
          afterFilter = filterByThreeOptions(
              allItems, indexState, indexName, indexCategory, indexDate);
          break;
        case 4:
          afterFilter = filterByFourOptions(allItems);
          break;
        default:
      }

// for (var element in widget.finalFilter) {}

      // switch (element.id) {
      //   case 1:
      //     {
      //       for (var option in element.options) {
      //         if (option.name.toLowerCase() == 'completados') {
      //           afterFilter += allItems
      //               .where((item) => item.isActive && item.isCompleted)
      //               .toList();
      //         } else if (option.name.toLowerCase() == 'anulados') {
      //           afterFilter +=
      //               allItems.where((item) => !item.isActive).toList();
      //         } else {
      //           afterFilter += allItems
      //               .where((item) => item.isActive && !item.isCompleted)
      //               .toList();
      //         }
      //       }
      //     }

      //     break;
      //   case 2:
      //     {
      //       for (var option in element.options) {
      //         afterFilter += allItems
      //             .where((item) => item.name.id == option.id)
      //             .toList();
      //       }
      //     }
      //     break;
      //   case 3:
      //     {
      //       for (var option in element.options) {
      //         afterFilter += allItems
      //             .where((item) => item.name.category.id == option.id)
      //             .toList();
      //       }
      //     }
      //     break;
      //   case 4:
      //     debugPrint('aplicar filtro de fecha');
      //     break;
      // }
      // }
    } else {
      afterFilter = allItems;
    }

    return afterFilter;
  }

  Future<void> _navigateToFilterScreen(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    // final result = await Navigator.push(
    //   context,
    // Create the SelectionScreen in the next step.
    // MaterialPageRoute(builder: (context) => const SelectionScreen()),
    final result =
        await Navigator.pushNamed(context, HistoricalFilterScreen.routeName);

    // );
    if (!context.mounted) return;

    debugPrint(result.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppBar(context),
        drawer: const CustomDrawer(),
        body: ModalProgressHUD(
          color: GlobalVariables.greyBackgroundColor,
          opacity: 0.8,
          blur: 0.8,
          inAsyncCall: _isLoading,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
                child: Column(
                  children: [
                    const MainTitle(title: 'Historial'),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _searchController,
                      onChanged: (value) => _runFilter(value),
                      decoration: const InputDecoration(
                        suffixIcon: Icon(
                          Icons.search,
                          size: 30,
                        ),
                        hintText: 'Buscar',
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black38)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black38)),
                        filled: true,
                        fillColor: GlobalVariables.greyBackgroundColor,
                        isDense: true,
                        errorStyle: TextStyle(color: Colors.red, fontSize: 14),
                      ),
                      maxLines: 1,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              'filtros'.toUpperCase(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Card(
                              color: GlobalVariables.historicalFilterColor,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                  color: GlobalVariables.historicalFilterColor,
                                ),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: SizedBox(
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    child: Text(
                                        widget.finalFilter.length.toString(),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16))),
                              ),
                            ),
                          ],
                        ),
                        //Icon(Icons.arrow_circle_down_sharp),
                        GestureDetector(
                          onTap: () {},
                          child: Image.asset(
                            "assets/images/desc-sort.png",
                            width: 25,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _navigateToFilterScreen(context);
                          },
                          child: Image.asset(
                            'assets/images/filter.png',
                            width: 25,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              payments == null
                  ? const Loader()
                  : payments!.isEmpty
                      ? const Text('No existen pagos para mostrar!')
                      : _foundPayments.isEmpty
                          ? const Text(
                              'No existen resultados a su búsqueda!',
                              style: TextStyle(fontSize: 16),
                            )
                          : Expanded(
                              child: ListView.builder(
                                  itemCount: _foundPayments.length,
                                  itemBuilder: (context, index) {
                                    return HistoricalItemCard(
                                      payment: _foundPayments[index],
                                    );
                                  }),
                            )
            ],
          ),
        ));
  }
}
