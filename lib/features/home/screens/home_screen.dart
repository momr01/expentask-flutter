import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:payments_management/common/widgets/loader.dart';
import 'package:payments_management/common/widgets/main_title.dart';
import 'package:payments_management/constants/global_variables.dart';
import 'package:payments_management/features/home/services/home_services.dart';
import 'package:payments_management/features/home/widgets/payment_card.dart';
import 'package:payments_management/features/home/widgets/search_text_field.dart';
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

  final GlobalKey<_HomeScreenState> homeScreenKey = GlobalKey();
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
    super.dispose();
    _searchController.dispose();
  }

  fetchUndonePayments() async {
    // final context = homeScreenKey.currentContext;

    // if (context != null && context.mounted) {
    setState(() {
      _isLoading = true;
    });
    payments = await homeServices.fetchUndonePayments(context: context);
    setState(() {
      _foundPayments = payments!;
      _isLoading = false;
    });
    // }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ModalProgressHUD(
      color: GlobalVariables.greyBackgroundColor,
      opacity: 0.8,
      blur: 0.8,
      inAsyncCall: _isLoading,
      child: Padding(
        padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
        child: Column(
          children: [
            const MainTitle(title: 'Pagos en tratamiento'),
            const SizedBox(
              height: 20,
            ),
            SearchTextField(
                searchController: _searchController,
                onChange: (value) => _runFilter(value)),
            const SizedBox(
              height: 20,
            ),
            payments == null
                ? const Loader()
                : payments!.isEmpty
                    ? const Text('¡No existen pagos para mostrar!')
                    : _foundPayments.isEmpty
                        ? const Text(
                            '¡No existen resultados a su búsqueda!',
                            style: TextStyle(fontSize: 16),
                          )
                        : Expanded(
                            child: ListView.separated(
                                itemBuilder: (context, index) {
                                  return PaymentCard(
                                      payment: _foundPayments[index]);
                                },
                                separatorBuilder: (context, _) {
                                  return const Divider();
                                },
                                itemCount: _foundPayments.length))
          ],
        ),
      ),
    ));
  }
}
