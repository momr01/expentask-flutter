import 'package:flutter/material.dart';
import 'package:payments_management/common/widgets/buttons/custom_button.dart';
import 'package:payments_management/common/widgets/custom_app_bar.dart';
import 'package:payments_management/common/widgets/main_title.dart';
import 'package:payments_management/constants/global_variables.dart';
import 'package:payments_management/features/generate/screens/generate_%C3%AFnstallments_form_screen.dart';
import 'package:payments_management/features/generate/widgets/card_checkbox_item.dart';
import 'package:payments_management/features/generate/widgets/modal_generate.dart';
import 'package:payments_management/models/generate_payment.dart';

class GenerateDetailsScreen extends StatefulWidget {
  static const String routeName = '/generate-payments';
  final String title;
  final List<GeneratePayment> payments;
  final String type; // "individual", "installments", "group"

  const GenerateDetailsScreen({
    Key? key,
    required this.title,
    required this.payments,
    this.type = "individual",
  }) : super(key: key);

  @override
  State<GenerateDetailsScreen> createState() => _GenerateDetailsScreenState();
}

class _GenerateDetailsScreenState extends State<GenerateDetailsScreen> {
  bool totalIsChecked = true;
  final TextEditingController _searchController = TextEditingController();
  List<GeneratePayment> filteredPayments = [];

  @override
  void initState() {
    super.initState();
    filteredPayments = List.from(widget.payments);
  }

  void checkedSelectAll() {
    int checked = filteredPayments.where((p) => p.state).length;
    totalIsChecked =
        checked == filteredPayments.length && filteredPayments.isNotEmpty;
  }

  void updateAllPayments(bool val) {
    for (var payment in filteredPayments) {
      payment.state = val;
      final original = widget.payments.firstWhere((p) => p.id == payment.id);
      original.state = val;
    }
  }

  void onChangeCheckboxEverything(bool? value) {
    setState(() {
      totalIsChecked = value!;
      updateAllPayments(value);
      checkedSelectAll();
    });
  }

  void filterPayments(String keyword) {
    setState(() {
      if (keyword.isEmpty) {
        filteredPayments = List.from(widget.payments);
      } else {
        filteredPayments = widget.payments
            .where((p) => p.name.toLowerCase().contains(keyword.toLowerCase()))
            .toList();
      }
      checkedSelectAll();
    });
  }

  List<GeneratePayment> generateGroupContent(List<GeneratePayment> list) {
    final List<GeneratePayment> result = [];
    for (var group in list) {
      if (group.state && group.namesList != null) {
        for (var name in group.namesList!) {
          result.add(GeneratePayment(
            id: name.id!,
            name: name.name,
            state: true,
          ));
        }
      }
    }
    return result;
  }

  void defineRedirect() {
    switch (widget.type) {
      case "installments":
        openInstallmentsScreen();
        break;
      case "group":
        openGroupGenerateModal();
        break;
      default:
        openIndividualGenerateModal();
    }
  }

  void openIndividualGenerateModal() {
    showDialog<String>(
      barrierDismissible: false,
      context: context,
      builder: (context) => ModalGenerate(
        totalSelected: filteredPayments.where((p) => p.state == true).length,
        payments: filteredPayments,
        type: widget.type,
      ),
    );
  }

  void openGroupGenerateModal() {
    showDialog<String>(
      barrierDismissible: false,
      context: context,
      builder: (context) => ModalGenerate(
        totalSelected: filteredPayments.where((p) => p.state == true).length,
        payments: generateGroupContent(filteredPayments),
        type: "group",
      ),
    );
  }

  void openInstallmentsScreen() async {
    await Navigator.pushNamed(
      context,
      GenerateInstallmentsFormScreen.routeName,
      arguments: [
        filteredPayments.where((p) => p.state == true).length,
        filteredPayments
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context),
      body: Padding(
        padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
        child: Column(
          children: [
            MainTitle(title: widget.title),
            const SizedBox(height: 30),

            // 🔍 Buscador
            TextField(
              controller: _searchController,
              onChanged: filterPayments,
              decoration: InputDecoration(
                hintText: 'Buscar...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          _searchController.clear();
                          filterPayments('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            CardCheckboxItem(
              state: totalIsChecked,
              text: 'Seleccionar Todo',
              onChanged: onChangeCheckboxEverything,
            ),

            filteredPayments.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      itemCount: filteredPayments.length,
                      itemBuilder: (context, index) {
                        final payment = filteredPayments[index];
                        return CardCheckboxItem(
                          state: payment.state,
                          text: payment.name,
                          onChanged: (value) {
                            setState(() {
                              payment.state = value!;
                              final original = widget.payments
                                  .firstWhere((p) => p.id == payment.id);
                              original.state = value;
                              checkedSelectAll();
                            });
                          },
                        );
                      },
                    ),
                  )
                : const Expanded(
                    child: Center(
                      child: Text('¡No existen resultados!'),
                    ),
                  ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 30)
                  .copyWith(top: 40),
              child: filteredPayments
                      .where((payment) => payment.state == true)
                      .isNotEmpty
                  ? CustomButton(
                      text: 'GENERAR',
                      color: GlobalVariables.completeButtonColor,
                      textColor: Colors.white,
                      onTap: defineRedirect,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
