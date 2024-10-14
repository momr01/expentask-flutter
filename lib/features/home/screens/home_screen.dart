import 'package:flutter/material.dart';
import 'package:payments_management/common/layouts/title_search_layout.dart';
import 'package:payments_management/common/utils/fetch_data.dart';
import 'package:payments_management/common/utils/run_filter.dart';
import 'package:payments_management/common/widgets/conditional_list_view/conditional_list_view.dart';
import 'package:payments_management/common/widgets/loader.dart';
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

  @override
  Widget build(BuildContext context) {
    return TitleSearchLayout(
      isMain: true,
      isLoading: _isLoading,
      title: 'Pagos en tratamiento',
      searchController: _searchController,
      onSearch: _runFilter,
      searchPlaceholder: "Buscar pago...",
      child: ConditionalListView(
        items: payments,
        foundItems: _foundPayments,
        loader: const Loader(),
        emptyMessage: "¡No existen pagos para mostrar!",
        itemBuilder: (context, payment) => PaymentCard(payment: payment),
        separatorBuilder: (context, _) => const Divider(),
      ),
    );
  }
}
