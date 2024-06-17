import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:payments_management/common/widgets/loader.dart';
import 'package:payments_management/common/widgets/main_title.dart';
import 'package:payments_management/constants/global_variables.dart';
import 'package:payments_management/features/form_edit_payment/services/form_edit_payment_services.dart';
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
  final FormEditPaymentServices formEditPaymentServices =
      FormEditPaymentServices();

  bool _isLoading = false;

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
    names = await formEditPaymentServices.fetchPaymentNames();
    setState(() {
      _foundNames = names!;
      _isLoading = false;
    });

    // await Future.delayed(const Duration(milliseconds: 10000), () {
    //   debugPrint('test');
    //   setState(() {});
    // });
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

/*
  void navigateToFormNameScreen(BuildContext context, List<Category> categories,
      List<TaskCode> taskCodes) {
    Navigator.pushNamed(context, FormManageNameScreen.routeName,
        // arguments: PaymentName(
        //     name: "name",
        //     isActive: false,
        //     category: Category(name: "", isActive: false))
        arguments: FormManageNameArguments(
            PaymentName(
                name: "name",
                isActive: false,
                category: Category(name: "", isActive: false)),
            categories,
            taskCodes));
  }

  void _getDataToForm() async {
    List<Category> categories = [];
    List<TaskCode> taskCodes = [];

    //categories = await formEditPaymentServices.fetchPaymentNames(context: context);

    if (categories.isEmpty) {
      errorModal(
        context: context,
        description:
            "Debe crear al menos una categoría, antes de agregar un nombre.",
        onTap: () {
          Navigator.pushNamedAndRemoveUntil(
              context, BottomBar.routeName, arguments: 1, (route) => true);
        },
      );
    } else {
      // taskCodes =
      //     await formEditPaymentServices.fetchTaskCodes(context: context);
      if (taskCodes.isEmpty) {
        errorModal(
          context: context,
          description:
              "Debe crear al menos un código, antes de agregar un nombre.",
          onTap: () {
            Navigator.pushNamedAndRemoveUntil(
                context, BottomBar.routeName, arguments: 1, (route) => true);
          },
        );
      } else {
        //navigateToFormEditPayment(context, payment!, names, taskCodes);
        navigateToFormNameScreen(context, categories, taskCodes);
      }
    }
    // navigateToFormEditPayment(context, payment!);
  }
*/

  void _prepareDataToSendToForm() {
    getDataToForm(
        context,
        PaymentName(
            name: "name",
            isActive: false,
            category: Category(name: "", isActive: false)));
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
          //onPressed: () => navigateToFormNameScreen(context),
          //onPressed: _getDataToForm,
          // onPressed: () => getDataToForm(
          //     context,
          //     PaymentName(
          //         name: "name",
          //         isActive: false,
          //         category: Category(name: "", isActive: false))),
          onPressed: _prepareDataToSendToForm,
          child: const Icon(
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
