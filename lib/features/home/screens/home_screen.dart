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
  final HomeServices homeServices = HomeServices();
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchUndonePayments();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void fetchUndonePayments() {
    fetchData<Payment>(
      context: context,
      fetchFunction: homeServices.fetchUndonePayments,
      onStart: () => setState(() => _isLoading = true),
      onSuccess: (items) => setState(() {
        payments = items;
        _foundPayments = items;

        // _foundPayments.sort((a, b) {
        //   // Extraer año y mes de cada período
        //   final yearA = int.parse(a.period.split('-')[1]);
        //   final monthA = int.parse(a.period.split('-')[0]);
        //   final yearB = int.parse(b.period.split('-')[1]);
        //   final monthB = int.parse(b.period.split('-')[0]);

        //   // Ordenar primero por año y luego por mes
        //   if (yearA == yearB) {
        //     return monthA.compareTo(monthB);
        //   }
        //   return yearA.compareTo(yearB);
        // });
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
    });
  }

  Future<void> _refreshData() async {
    // Simula la carga de nuevos datos
    // await Future.delayed(Duration(seconds: 2));
    // setState(() {
    //   _items.add('Item nuevo');
    // });
    // setState(() {});
    fetchUndonePayments();
  }

  List<Map<String, String>> filterOptions = [
    {"id": "1", "name": "individuales"},
    {"id": "2", "name": "cuotas"},
    {"id": "3", "name": "todos"},
  ];

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
        // child: ConditionalListView(
        //   items: payments,
        //   foundItems: _foundPayments,
        //   loader: const Loader(),
        //   emptyMessage: "¡No existen pagos para mostrar!",
        //   itemBuilder: (context, payment) => PaymentCard(payment: payment),
        //   separatorBuilder: (context, _) => const Divider(),
        // ),

        child: Flexible(
          child: Column(
            children: [
              SizedBox(
                height: 40,
                child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => ColorRoundedItem(
                          colorBackCard: GlobalVariables.blueActionColor,
                          colorBorderCard: GlobalVariables.blueActionColor,
                          text: capitalizeFirstLetter(
                              filterOptions[index]["name"]!),
                          colorText: Colors.black,
                          sizeText: 13,
                          onTap: () {
                            debugPrint(filterOptions[index]["name"]!);
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
