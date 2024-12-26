import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:payments_management/common/widgets/loader.dart';
import 'package:payments_management/common/widgets/main_title.dart';
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
    super.dispose();
    _searchController.dispose();
  }

  fetchPaymentNames() async {
    setState(() {
      _isLoading = true;
    });
    names = await namesServices.fetchPaymentNames();
    // if (names != null) {
    //   names!.sort((a, b) {
    //     return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    //   });
    // }

    setState(() {
      _foundNames = names!;
      _isLoading = false;
    });
  }

  void _runFilter(String enteredKeyword) {
    List<PaymentName> results = [];
    if (enteredKeyword.isEmpty) {
      results = names!;
    } else {
      results = names!
          .where((name) =>
              name.name.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _foundNames = results;
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SizedBox(
        height: 80,
        width: 80,
        child: FloatingActionButton(
          shape: const CircleBorder(),
          backgroundColor: GlobalVariables.historicalPending,
          foregroundColor: Colors.white,
          onPressed: _newNameScreenLoading ? null : _prepareDataToSendToForm,
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
                  const MainTitle(title: 'Nombres creados'),
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
                      hintText: 'Buscar nombre...',
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
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            names == null
                ? const Loader()
                : names!.isEmpty
                    ? const Text('¡No existen nombres para mostrar!')
                    : _foundNames.isEmpty
                        ? const Text(
                            '¡No existen resultados a su búsqueda!',
                            style: TextStyle(fontSize: 16),
                          )
                        : Expanded(
                            child: ListView.builder(
                                itemBuilder: (context, index) {
                                  return NameCard(name: _foundNames[index]);
                                },
                                itemCount: _foundNames.length)),
          ],
        ),
      ),
    );
  }
}
