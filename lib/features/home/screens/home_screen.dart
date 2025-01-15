import 'package:flutter/material.dart';
import 'package:payments_management/common/layouts/title_search_layout.dart';
import 'package:payments_management/common/utils/fetch_data.dart';
import 'package:payments_management/common/utils/run_filter.dart';
import 'package:payments_management/common/widgets/color_rounded_item.dart';
import 'package:payments_management/common/widgets/conditional_list_view/conditional_list_view.dart';
import 'package:payments_management/common/widgets/loader.dart';
import 'package:payments_management/constants/global_variables.dart';
import 'package:payments_management/constants/utils.dart';
import 'package:payments_management/features/home/services/home_services.dart';
import 'package:payments_management/features/home/widgets/payment_card.dart';
import 'package:payments_management/models/filter/filter_option.dart';
import 'package:payments_management/models/payment/payment.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  List<Payment>? payments;
  List<Payment> _foundPayments = [];
  List<FilterOption> filterOptions = [];
  bool _isLoading = false;

  final HomeServices homeServices = HomeServices();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUndonePayments();
    fillFilterOptionsList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void fillFilterOptionsList() {
    filterOptions
        .add(FilterOption(id: 1, name: "todos", type: "all", state: true));
    filterOptions.add(FilterOption(
        id: 2, name: "individuales", type: "individual", state: false));
    filterOptions.add(FilterOption(
        id: 3, name: "cuotas", type: "installments", state: false));
  }

  void fetchUndonePayments() {
    fetchData<Payment>(
      context: context,
      fetchFunction: homeServices.fetchUndonePayments,
      onStart: () => setState(() => _isLoading = true),
      onSuccess: (items) => setState(() {
        payments = items;
        _foundPayments = items;
      }),
      onComplete: () => setState(() => _isLoading = false),
    );
  }

  void _runFilter(String keyword) {
    setState(() {
      _foundPayments = runFilter<Payment>(
        keyword,
        payments!,
        (payment) =>
            payment.name.name.toLowerCase().contains(keyword.toLowerCase()),
      );

      for (var element in filterOptions) {
        if (element.type == "all") {
          element.state = true;
        } else {
          element.state = false;
        }
      }
    });
  }

  void _updateFilterState(String selectedType) {
    filterOptions.where((element) => element.type == selectedType).first.state =
        true;

    filterOptions
        .where((element) => element.type != selectedType)
        .forEach((element) => element.state = false);
  }

  void _filterHasInstallments(String type, {String? keyword}) {
    setState(() {
      switch (type) {
        case "individual":
          {
            _foundPayments =
                payments!.where((payment) => !payment.hasInstallments).toList();

            _updateFilterState(type);
          }

          break;
        case "installments":
          {
            _foundPayments =
                payments!.where((payment) => payment.hasInstallments).toList();

            _updateFilterState(type);
          }
          break;
        case "all":
          {
            _foundPayments = payments!;

            _updateFilterState(type);
          }
          break;
        case "search":
          {
            _foundPayments = runFilter<Payment>(
              keyword!,
              payments!,
              (payment) => payment.name.name
                  .toLowerCase()
                  .contains(keyword.toLowerCase()),
            );
          }
          break;
        default:
      }
    });
  }

  Future<void> _refreshData() async {
    fetchUndonePayments();
    filterOptions.clear();
    fillFilterOptionsList();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: TitleSearchLayout(
        isMain: true,
        isLoading: _isLoading,
        title: 'Pagos en tratamiento',
        searchController: _searchController,
        onSearch: _runFilter,
        searchPlaceholder: "Buscar pago...",
        child: Flexible(
          child: Column(
            children: [
              SizedBox(
                height: 40,
                child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => ColorRoundedItem(
                          colorBackCard: filterOptions[index].state
                              ? GlobalVariables.blueActionColor
                              : GlobalVariables.greyBackgroundColor,
                          colorBorderCard: GlobalVariables.blueActionColor,
                          text:
                              capitalizeFirstLetter(filterOptions[index].name),
                          colorText: Colors.black,
                          sizeText: 13,
                          onTap: () {
                            _filterHasInstallments(filterOptions[index].type);
                          },
                        ),
                    separatorBuilder: (context, index) => const SizedBox(
                          width: 15,
                        ),
                    itemCount: filterOptions.length),
              ),
              const SizedBox(
                height: 15,
              ),
              ConditionalListView(
                items: payments,
                foundItems: _foundPayments,
                loader: const Loader(),
                emptyMessage: "¡No existen pagos para mostrar!",
                itemBuilder: (context, payment) =>
                    PaymentCard(payment: payment),
                separatorBuilder: (context, _) => const Divider(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
