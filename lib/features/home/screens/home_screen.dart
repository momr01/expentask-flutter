import 'package:flutter/material.dart';
import 'package:payments_management/common/layouts/title_search_layout.dart';
import 'package:payments_management/common/utils/fetch_data.dart';
import 'package:payments_management/common/utils/run_filter.dart';
import 'package:payments_management/common/widgets/conditional_list_view/conditional_list_view.dart';
import 'package:payments_management/common/widgets/loader.dart';
import 'package:payments_management/features/home/services/home_services.dart';
import 'package:payments_management/features/home/utils/filter_data.dart';
import 'package:payments_management/features/home/utils/filter_option.dart';
import 'package:payments_management/features/home/widgets/filter_row.dart';
import 'package:payments_management/features/home/widgets/payment_card.dart';
import 'package:payments_management/models/payment/payment.dart';
import 'package:provider/provider.dart';

/*
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
    for (var data in filterData) {
      filterOptions.add(FilterOption(
          id: data["id"],
          name: data["name"],
          type: data["type"],
          state: data["state"],
          filter: data["filter"]));
    }
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

  Future<void> _refreshData() async {
    fetchUndonePayments();
    filterOptions.clear();
    fillFilterOptionsList();
  }

  @override
  Widget build(BuildContext context) {
    return
        // RefreshIndicator(
        // onRefresh: _refreshData,
        // child:
        TitleSearchLayout(
      refreshData: _refreshData,
      isMain: true,
      isLoading: _isLoading,
      title: 'Pagos en tratamiento',
      searchController: _searchController,
      onSearch: _runFilter,
      searchPlaceholder: "Buscar pago...",
      child: Flexible(
        child: Column(
          children: [
            FilterRow(
              filterOptions: filterOptions,
              payments: payments != null ? payments! : [],
              foundPayments: _foundPayments,
              onPaymentsFiltered: (filteredList) {
                setState(() {
                  _foundPayments =
                      filteredList; // Actualiza la lista en el widget padre
                });
              },
            ),
            const SizedBox(
              height: 15,
            ),
            ConditionalListView(
              items: payments,
              foundItems: _foundPayments,
              loader: const Loader(),
              emptyMessage: "¡No existen pagos para mostrar!",
              itemBuilder: (context, payment) => PaymentCard(payment: payment),
              separatorBuilder: (context, _) => const Divider(),
            ),
          ],
        ),
      ),
    );
    //);
  }
}
*/

// class HomeScreenProvider extends StatelessWidget {
//   const HomeScreenProvider({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (_) => HomeScreenViewModel()..init(),
//       child: const HomeScreenUI(),
//     );
//   }
// }
class HomeScreenProvider extends StatelessWidget {
  // final HomeServices homeServices;
  const HomeScreenProvider({
    super.key,
    //  required this.homeServices,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeScreenViewModel()..init(),
      child: const HomeScreenUI(),
    );
  }
}

class HomeScreenViewModel extends ChangeNotifier {
  static const String routeName = '/home';
  //  @override
  // void setState(fn) {
  //   if (mounted) {
  //     super.setState(fn);
  //   }
  // }

  // final HomeServices homeServices;

//  HomeScreenViewModel({required this.homeServices});

  final HomeServices homeServices;

  HomeScreenViewModel({HomeServices? homeServices})
      : homeServices = homeServices ?? HomeServices();

  List<Payment>? payments;
  // List<Payment> payments = []; // ya no nullable, siempre inicializada
  List<Payment> _foundPayments = [];
  List<FilterOption> filterOptions = [];
  bool _isLoading = false;

  //final HomeServices homeServices = HomeServices();

  final TextEditingController _searchController = TextEditingController();

  TextEditingController get searchController => _searchController;
  List<Payment> get foundPayments => _foundPayments;
  bool get isLoading => _isLoading;

  // @override
  // void initState() {
  //   super.initState();
  //   fetchUndonePayments();
  //   fillFilterOptionsList();
  // }

  // @override
  // void dispose() {
  //   _searchController.dispose();
  //   super.dispose();
  // }

  void init() {
    fetchUndonePayments();
    fillFilterOptionsList();
  }

  void fillFilterOptionsList() {
    for (var data in filterData) {
      filterOptions.add(FilterOption(
          id: data["id"],
          name: data["name"],
          type: data["type"],
          state: data["state"],
          filter: data["filter"]));
    }

    notifyListeners();
  }

  Future<void> fetchUndonePayments() async {
    fetchData<Payment>(
      // context: null,
      fetchFunction: homeServices.fetchUndonePayments,
      // onStart: () => setState(() => _isLoading = true),
      onStart: () {
        _isLoading = true;
        notifyListeners();
      },
      // onSuccess: (items) => setState(() {
      //   payments = items;
      //   _foundPayments = items;
      // }),
      onSuccess: (items) {
        payments = items;
        _foundPayments = items;
        notifyListeners();
      },
      //onComplete: () => setState(() => _isLoading = false),
      onComplete: () {
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  void filter(String keyword) {
    //  setState(() {
    _foundPayments = runFilter<Payment>(
      keyword,
      //  payments!,
      payments!,
      (payment) =>
          payment.name.name.toLowerCase().contains(keyword.toLowerCase()),
    );

    for (var element in filterOptions) {
      if (element.type == "month") {
        element.state = true;
      } else {
        element.state = false;
      }
    }
    // });
    notifyListeners();
  }

  Future<void> _refreshData() async {
    fetchUndonePayments();
    filterOptions.clear();
    fillFilterOptionsList();
  }

  void onPaymentsFiltered(List<Payment> filteredList) {
    _foundPayments = filteredList;
    notifyListeners();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class HomeScreenUI extends StatelessWidget {
  const HomeScreenUI({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<HomeScreenViewModel>(context);

    return
        // RefreshIndicator(
        // onRefresh: _refreshData,
        // child:
        TitleSearchLayout(
      refreshData: vm._refreshData,
      isMain: true,
      isLoading: vm._isLoading,
      title: 'Pagos en tratamiento',
      searchController: vm.searchController,
      onSearch: vm.filter,
      searchPlaceholder: "Buscar pago...",
      child: Flexible(
        child: Column(
          children: [
            FilterRow(
              filterOptions: vm.filterOptions,
              payments: vm.payments ?? [],
              foundPayments: vm.foundPayments,
              // onPaymentsFiltered: (filteredList) {
              //   setState(() {
              //     _foundPayments =
              //         filteredList; // Actualiza la lista en el widget padre
              //   });
              // },
              onPaymentsFiltered: vm.onPaymentsFiltered,
            ),
            const SizedBox(
              height: 15,
            ),
            ConditionalListView(
              items: vm.payments,
              foundItems: vm.foundPayments,
              loader: const Loader(),
              emptyMessage: "¡No existen pagos para mostrar!",
              itemBuilder: (context, payment) => PaymentCard(payment: payment),
              separatorBuilder: (context, _) => const Divider(),
            ),
          ],
        ),
      ),
    );
    //);
  }
}
