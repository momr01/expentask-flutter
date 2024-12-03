// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:payments_management/common/widgets/main_title.dart';
import 'package:payments_management/constants/error_modal.dart';
import 'package:payments_management/constants/global_variables.dart';
import 'package:payments_management/features/form_edit_payment/services/form_edit_payment_services.dart';
import 'package:payments_management/features/generate/screens/generate_details_screen.dart';
import 'package:payments_management/features/generate/widgets/main_card_type.dart';
import 'package:payments_management/features/names/services/names_services.dart';
import 'package:payments_management/models/generate_payment.dart';
import 'package:payments_management/models/name/payment_name.dart';

class GenerateMainScreen extends StatefulWidget {
  static const String routeName = '/generate-payments-main';
  const GenerateMainScreen({super.key});

  @override
  State<GenerateMainScreen> createState() => _GenerateMainScreenState();
}

class _GenerateMainScreenState extends State<GenerateMainScreen> {
  List<PaymentName>? names;
  List<GeneratePayment> _payments = [];

  // final FormEditPaymentServices formEditPaymentServices =
  //    FormEditPaymentServices();
  final NamesServices namesServices = NamesServices();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  fetchPaymentNames() async {
    setState(() {
      _isLoading = true;
    });
    names = await namesServices.fetchPaymentNames();
    setState(() {
      if (names != null) {
        _payments = [];
        for (var name in names!) {
          _payments
              .add(GeneratePayment(id: name.id!, name: name.name, state: true));
        }
      }
      _isLoading = false;

      if (_payments.isNotEmpty) {
        navigateToIndividualList(context);
      } else {
        errorModal(
            context: context,
            description:
                'No existen nombres para generar pagos en forma masiva.');
      }
    });
  }

  fetchGroups() async {
    setState(() {
      _isLoading = true;
    });
    await namesServices.fetchPaymentNames();
    setState(() {
      _payments = [];
      // if (names != null) {
      //   _payments = [];
      //   for (var name in names!) {
      //     _payments
      //         .add(GeneratePayment(id: name.id!, name: name.name, state: true));
      //   }
      // }
      _isLoading = false;

      if (_payments.isNotEmpty) {
        navigateToGroups(context);
      } else {
        errorModal(
            context: context,
            description:
                'No existen grupos para generar pagos en forma masiva.');
      }
    });
  }

  void navigateToGroups(BuildContext context) {
    Navigator.pushNamed(context, GenerateDetailsScreen.routeName,
        arguments: [_payments, 'Generar Pagos por Grupo']);
  }

  void navigateToIndividualList(BuildContext context) {
    Navigator.pushNamed(context, GenerateDetailsScreen.routeName,
        arguments: [_payments, 'Generación Individual de Pagos']);
  }

  @override
  Widget build(BuildContext context) {
    List generationTypes = [
      {'title': 'Grupos', 'onTap': fetchGroups},
      {'title': 'Individual', 'onTap': fetchPaymentNames},
      {'title': 'Cuotas', 'onTap': fetchGroups}
    ];

    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: ModalProgressHUD(
        color: GlobalVariables.greyBackgroundColor,
        opacity: 0.8,
        blur: 0.8,
        inAsyncCall: _isLoading,
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
          child: Column(
            children: [
              const MainTitle(title: 'Generación Masiva de Pagos'),
              const SizedBox(
                height: 40,
              ),
              Flexible(
                  child: SizedBox(
                height: 100,
                child: ListView.separated(
                  separatorBuilder: (context, index) => const SizedBox(
                    width: 20,
                  ),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return MainCardType(
                      title: generationTypes[index]['title'],
                      onTap: generationTypes[index]['onTap'],
                    );
                  },
                  itemCount: generationTypes.length,
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
