import 'package:flutter/material.dart';
import 'package:payments_management/common/layouts/title_search_layout.dart';
import 'package:payments_management/common/utils/fetch_data.dart';
import 'package:payments_management/common/utils/run_filter.dart';
import 'package:payments_management/common/widgets/conditional_list_view/conditional_list_view.dart';
import 'package:payments_management/common/widgets/float_btn.dart';
import 'package:payments_management/common/widgets/loader.dart';
import 'package:payments_management/constants/global_variables.dart';
import 'package:payments_management/features/names/services/names_services.dart';
import 'package:payments_management/features/names/utils/names_utils.dart';
import 'package:payments_management/features/names/widgets/name_card.dart';
import 'package:payments_management/models/category/category.dart';
import 'package:payments_management/models/name/payment_name.dart';

class NamesScreen extends StatefulWidget {
  static const String routeName = '/names';
  const NamesScreen({super.key});

  @override
  State<NamesScreen> createState() => _NamesScreenState();
}

class _NamesScreenState extends State<NamesScreen> {
  List<PaymentName>? names;
  List<PaymentName> _foundNames = [];

  final TextEditingController _searchController = TextEditingController();
  final NamesServices namesServices = NamesServices();

  bool _isLoading = false;
  bool _newNameScreenLoading = false;

  @override
  void initState() {
    super.initState();
    fetchPaymentNames();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void fetchPaymentNames() {
    fetchData<PaymentName>(
        // context: context,
        fetchFunction: namesServices.fetchPaymentNames,
        onSuccess: (items) => setState(() {
              names = items;
              _foundNames = items;
            }),
        onStart: () => setState(() => _isLoading = true),
        onComplete: () => setState(() => _isLoading = false));
  }

  void _runFilter(String keyword) {
    setState(() {
      _foundNames = runFilter<PaymentName>(
        keyword,
        names!,
        (name) => name.name.toLowerCase().contains(keyword.toLowerCase()),
      );
    });

    for (var element in _foundNames) {
      debugPrint(element.name);
    }
  }

  void _prepareDataToSendToForm() async {
    setState(() {
      _newNameScreenLoading = true;
    });
    await getDataToForm(
        context,
        PaymentName(
            name: "name",
            isActive: false,
            category: Category(name: "", isActive: false)));

    setState(() {
      _newNameScreenLoading = false;
    });
  }

  Future<void> _refreshData() async {
    fetchPaymentNames();
    _searchController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return
        //RefreshIndicator(
        // onRefresh: _refreshData,
        // child:

        TitleSearchLayout(
      refreshData: _refreshData,
      isMain: true,
      isLoading: _isLoading,
      title: 'Nombres creados',
      searchController: _searchController,
      onSearch: _runFilter,
      searchPlaceholder: "Buscar nombre...",
      withFloatBtn: true,
      //loadFloatBtn: _newNameScreenLoading,
      floatBtn: FloatBtn(
        // loadFloatBtn: true,
        loadFloatBtn: _newNameScreenLoading,
        onTapFloatBtn: _prepareDataToSendToForm,
      ),

/*
        floatBtn: SizedBox(
          height: 80,
          width: 80,
          child: FloatingActionButton(
            shape: const CircleBorder(),
            backgroundColor: GlobalVariables.historicalPending,
            foregroundColor: Colors.white,
            onPressed: _prepareDataToSendToForm,
            child: _newNameScreenLoading
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : const Icon(
                    Icons.add,
                    size: 40,
                  ),
          ),
        ),

*/

      //  onTapFloatBtn: _prepareDataToSendToForm,
      child: Flexible(
        child: Column(
          children: [
            ConditionalListView(
              items: _foundNames,
              foundItems: _foundNames,
              loader: const Loader(),
              emptyMessage: "¡No existen nombres para mostrar!",
              itemBuilder: (context, name) => NameCard(name: name),
            ),
          ],
        ),
      ),
    );
    // );
  }
}
